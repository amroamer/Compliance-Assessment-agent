"""
Score Calculation Service — calculates aggregated scores through the hierarchy.
"""
import uuid
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.assessment_engine import (
    AggregationRule, AssessmentInstance, AssessmentNodeScore, AssessmentResponse,
)
from app.models.framework_node import FrameworkNode, NodeType


async def calculate_all_scores(db: AsyncSession, instance_id: uuid.UUID):
    """Full tree recalculation for an assessment instance."""
    instance = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == instance_id))).scalar_one_or_none()
    if not instance:
        return

    # Load all nodes for this framework
    nodes = (await db.execute(
        select(FrameworkNode).where(FrameworkNode.framework_id == instance.framework_id, FrameworkNode.is_active == True)
        .order_by(FrameworkNode.depth.desc())  # bottom-up
    )).scalars().all()

    # Load all responses
    responses = (await db.execute(
        select(AssessmentResponse).where(AssessmentResponse.instance_id == instance_id)
    )).scalars().all()
    resp_map = {str(r.node_id): r for r in responses}

    # Load aggregation rules
    rules = (await db.execute(
        select(AggregationRule).where(AggregationRule.framework_id == instance.framework_id)
    )).scalars().all()

    # Load node types
    node_types = (await db.execute(
        select(NodeType).where(NodeType.framework_id == instance.framework_id)
    )).scalars().all()
    nt_map = {nt.name: str(nt.id) for nt in node_types}

    # Build rule lookup: (parent_nt_id, child_nt_id) -> rule
    rule_map = {}
    for r in rules:
        rule_map[(str(r.parent_node_type_id), str(r.child_node_type_id))] = r

    # Build parent->children map
    children_map: dict[str, list[FrameworkNode]] = {}
    for n in nodes:
        parent_key = str(n.parent_id) if n.parent_id else "ROOT"
        if parent_key not in children_map:
            children_map[parent_key] = []
        children_map[parent_key].append(n)

    # Score cache: node_id -> score
    score_cache: dict[str, Decimal | None] = {}

    # Process bottom-up
    for node in nodes:
        nid = str(node.id)

        if node.is_assessable:
            # Leaf node: score = response computed_score
            resp = resp_map.get(nid)
            score_cache[nid] = resp.computed_score if resp and resp.computed_score is not None else None
        else:
            # Parent node: aggregate children
            children = children_map.get(nid, [])
            if not children:
                score_cache[nid] = None
                continue

            child_scores = []
            child_weights = []
            children_answered = 0

            for child in children:
                cid = str(child.id)
                cscore = score_cache.get(cid)
                if cscore is not None:
                    child_scores.append(float(cscore))
                    child_weights.append(float(child.weight) if child.weight else 1.0)
                    children_answered += 1

            if not child_scores:
                score_cache[nid] = None
                continue

            # Find aggregation rule
            parent_nt_id = nt_map.get(node.node_type)
            child_nt_ids = set(nt_map.get(c.node_type) for c in children if nt_map.get(c.node_type))
            rule = None
            for cnt_id in child_nt_ids:
                rule = rule_map.get((parent_nt_id, cnt_id)) if parent_nt_id else None
                if rule:
                    break

            method = rule.method if rule else "simple_average"

            if method == "weighted_average":
                total_weight = sum(child_weights)
                agg = sum(s * w for s, w in zip(child_scores, child_weights)) / total_weight if total_weight > 0 else 0
            elif method == "simple_average":
                agg = sum(child_scores) / len(child_scores)
            elif method == "percentage_compliant":
                agg = (sum(1 for s in child_scores if s > 0) / len(child_scores)) * 100
            elif method == "minimum":
                agg = min(child_scores)
            elif method == "maximum":
                agg = max(child_scores)
            elif method == "sum":
                agg = sum(child_scores)
            else:
                agg = sum(child_scores) / len(child_scores)

            agg_decimal = Decimal(str(round(agg, rule.round_to if rule else 2)))
            score_cache[nid] = agg_decimal

            # Upsert node score
            existing = (await db.execute(
                select(AssessmentNodeScore).where(
                    AssessmentNodeScore.instance_id == instance_id,
                    AssessmentNodeScore.node_id == node.id,
                )
            )).scalar_one_or_none()

            meets_min = None
            if rule and rule.minimum_acceptable:
                meets_min = agg_decimal >= rule.minimum_acceptable

            if existing:
                existing.aggregated_score = agg_decimal
                existing.child_count = len(children)
                existing.children_answered = children_answered
                existing.meets_minimum = meets_min
                existing.calculated_at = datetime.now(timezone.utc)
            else:
                db.add(AssessmentNodeScore(
                    instance_id=instance_id, node_id=node.id,
                    aggregated_score=agg_decimal, child_count=len(children),
                    children_answered=children_answered, meets_minimum=meets_min,
                    calculated_at=datetime.now(timezone.utc),
                ))

    # Calculate overall score (average of root node scores)
    root_scores = [float(score_cache.get(str(n.id), 0) or 0) for n in nodes if n.depth == 0 and score_cache.get(str(n.id)) is not None]
    if root_scores:
        overall = round(sum(root_scores) / len(root_scores), 2)
        instance.overall_score = Decimal(str(overall))

    await db.flush()
