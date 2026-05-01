"""Dynamic PDF Report Generator for all compliance frameworks."""
import os
import re
import uuid
from io import BytesIO
from datetime import datetime

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm, cm
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, HRFlowable,
)
from reportlab.graphics.shapes import Drawing, Rect, String, Circle
from reportlab.graphics.charts.piecharts import Pie
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase.pdfmetrics import registerFontFamily

import arabic_reshaper
from bidi.algorithm import get_display

# ── Font registration (DejaVu Sans — has Arabic glyphs, installed via fonts-dejavu-core) ──
FONT_NAME = "Helvetica"
FONT_NAME_BOLD = "Helvetica-Bold"

_DEJAVU_CANDIDATES = [
    ("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
     "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"),
    ("/usr/share/fonts/TTF/DejaVuSans.ttf",
     "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"),
]
for _reg, _bold in _DEJAVU_CANDIDATES:
    if os.path.exists(_reg) and os.path.exists(_bold):
        try:
            pdfmetrics.registerFont(TTFont("DejaVuSans", _reg))
            pdfmetrics.registerFont(TTFont("DejaVuSans-Bold", _bold))
            registerFontFamily("DejaVuSans", normal="DejaVuSans", bold="DejaVuSans-Bold",
                               italic="DejaVuSans", boldItalic="DejaVuSans-Bold")
            FONT_NAME = "DejaVuSans"
            FONT_NAME_BOLD = "DejaVuSans-Bold"
        except Exception:
            pass
        break

_ARABIC_RE = re.compile(r"[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]")


def _ar(text):
    """Reshape + bidi-reorder Arabic so it renders correctly in ReportLab.

    Safe to call on pure Latin strings (returned unchanged). Handles None.
    """
    if not text:
        return text
    s = str(text)
    if not _ARABIC_RE.search(s):
        return s
    return get_display(arabic_reshaper.reshape(s))

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.assessment_engine import (
    AssessmentInstance, AssessmentResponse, AssessmentEvidence,
    AssessedEntity, AiProduct,
)
from app.models.compliance_framework import ComplianceFramework
from app.models.framework_node import FrameworkNode

# ── Colors ──
KPMG_NAVY = colors.HexColor("#00338D")
KPMG_BLUE = colors.HexColor("#0091DA")
KPMG_LIGHT = colors.HexColor("#F0F4F8")
GREEN = colors.HexColor("#27AE60")
YELLOW = colors.HexColor("#F39C12")
RED = colors.HexColor("#E74C3C")
GREY = colors.HexColor("#95A5A6")
WHITE = colors.white
BLACK = colors.black
LIGHT_GREEN = colors.HexColor("#E8F5E9")
LIGHT_YELLOW = colors.HexColor("#FFF8E1")
LIGHT_RED = colors.HexColor("#FFEBEE")
LIGHT_GREY = colors.HexColor("#F5F5F5")


def _get_styles():
    """Create custom paragraph styles."""
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(
        "KPMGTitle", parent=styles["Title"],
        fontName=FONT_NAME_BOLD, fontSize=22, textColor=KPMG_NAVY,
        spaceAfter=6, alignment=TA_LEFT,
    ))
    styles.add(ParagraphStyle(
        "KPMGSubtitle", parent=styles["Normal"],
        fontName=FONT_NAME, fontSize=12, textColor=KPMG_BLUE,
        spaceAfter=12, alignment=TA_LEFT,
    ))
    styles.add(ParagraphStyle(
        "SectionHeader", parent=styles["Heading1"],
        fontName=FONT_NAME_BOLD, fontSize=14, textColor=KPMG_NAVY,
        spaceBefore=16, spaceAfter=8,
    ))
    styles.add(ParagraphStyle(
        "SubHeader", parent=styles["Heading2"],
        fontName=FONT_NAME_BOLD, fontSize=11, textColor=KPMG_BLUE,
        spaceBefore=10, spaceAfter=4,
    ))
    styles["BodyText"].fontName = FONT_NAME
    styles["BodyText"].fontSize = 9
    styles["BodyText"].textColor = BLACK
    styles["BodyText"].spaceAfter = 4
    styles["BodyText"].leading = 12
    styles.add(ParagraphStyle(
        "SmallText", parent=styles["Normal"],
        fontName=FONT_NAME, fontSize=7.5, textColor=BLACK,
        leading=10,
    ))
    styles.add(ParagraphStyle(
        "CellText", parent=styles["Normal"],
        fontName=FONT_NAME, fontSize=8, textColor=BLACK,
        leading=10,
    ))
    styles.add(ParagraphStyle(
        "Footer", parent=styles["Normal"],
        fontName=FONT_NAME, fontSize=7, textColor=GREY,
        alignment=TA_CENTER,
    ))
    return styles


def _compliance_color(label):
    if label == "Compliant":
        return GREEN
    elif label in ("Semi-Compliant", "Partially Compliant"):
        return YELLOW
    elif label == "Non-Compliant":
        return RED
    return GREY


def _compliance_bg(label):
    if label == "Compliant":
        return LIGHT_GREEN
    elif label in ("Semi-Compliant", "Partially Compliant"):
        return LIGHT_YELLOW
    elif label == "Non-Compliant":
        return LIGHT_RED
    return LIGHT_GREY


def _build_pie_chart(data_dict, width=180, height=140):
    """Build a pie chart from {label: count} dict."""
    drawing = Drawing(width, height)
    pie = Pie()
    pie.x = 30
    pie.y = 10
    pie.width = 80
    pie.height = 80
    pie.data = list(data_dict.values())
    pie.labels = [f"{k} ({v})" for k, v in data_dict.items()]
    color_map = {"Compliant": GREEN, "Partially Compliant": YELLOW,
                 "Semi-Compliant": YELLOW, "Non-Compliant": RED, "Pending": GREY}
    for i, k in enumerate(data_dict.keys()):
        pie.slices[i].fillColor = color_map.get(k, GREY)
        pie.slices[i].strokeWidth = 0.5
    pie.slices.fontName = FONT_NAME
    pie.slices.fontSize = 7
    pie.sideLabels = True
    pie.sideLabelsOffset = 0.1
    drawing.add(pie)
    return drawing


def _build_score_bar(compliant, semi, non_compliant, total, width=400, height=24):
    """Build a horizontal stacked bar showing compliance distribution."""
    drawing = Drawing(width, height)
    if total == 0:
        return drawing
    bar_y = 4
    bar_h = 16
    x = 0
    for count, color in [(compliant, GREEN), (semi, YELLOW), (non_compliant, RED)]:
        if count > 0:
            w = (count / total) * width
            drawing.add(Rect(x, bar_y, w, bar_h, fillColor=color, strokeColor=None))
            if w > 20:
                drawing.add(String(x + w / 2, bar_y + 4, str(count),
                                   fontName=FONT_NAME_BOLD, fontSize=8,
                                   fillColor=WHITE, textAnchor="middle"))
            x += w
    remaining = total - compliant - semi - non_compliant
    if remaining > 0:
        w = (remaining / total) * width
        drawing.add(Rect(x, bar_y, w, bar_h, fillColor=GREY, strokeColor=None))
        x += w
    return drawing


def _header_footer(canvas, doc, entity_name, framework_name):
    """Draw header/footer on each page."""
    canvas.saveState()
    # Header line
    canvas.setStrokeColor(KPMG_NAVY)
    canvas.setLineWidth(2)
    canvas.line(15 * mm, A4[1] - 12 * mm, A4[0] - 15 * mm, A4[1] - 12 * mm)
    canvas.setFont(FONT_NAME_BOLD, 8)
    canvas.setFillColor(KPMG_NAVY)
    canvas.drawString(15 * mm, A4[1] - 10 * mm, "KPMG — Compliance Assessment Report")
    canvas.setFont(FONT_NAME, 7)
    canvas.setFillColor(GREY)
    canvas.drawRightString(A4[0] - 15 * mm, A4[1] - 10 * mm, _ar(f"{entity_name} | {framework_name}"))
    # Footer
    canvas.setStrokeColor(KPMG_NAVY)
    canvas.setLineWidth(1)
    canvas.line(15 * mm, 14 * mm, A4[0] - 15 * mm, 14 * mm)
    canvas.setFont(FONT_NAME, 7)
    canvas.setFillColor(GREY)
    canvas.drawString(15 * mm, 9 * mm, f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    canvas.drawRightString(A4[0] - 15 * mm, 9 * mm, f"Page {doc.page}")
    canvas.drawCentredString(A4[0] / 2, 9 * mm, "Confidential")
    canvas.restoreState()


async def generate_pdf_report(db: AsyncSession, instance_id: uuid.UUID) -> BytesIO:
    """Generate a dynamic PDF report for any assessment framework."""

    # ── Load Data ──
    inst = (await db.execute(
        select(AssessmentInstance).options(
            selectinload(AssessmentInstance.cycle),
            selectinload(AssessmentInstance.framework),
            selectinload(AssessmentInstance.assessed_entity),
        ).where(AssessmentInstance.id == instance_id)
    )).scalar_one_or_none()
    if not inst:
        raise ValueError("Assessment instance not found")

    responses = (await db.execute(
        select(AssessmentResponse).options(selectinload(AssessmentResponse.node))
        .where(AssessmentResponse.instance_id == instance_id)
    )).scalars().all()

    # Load products
    product_ids = list({r.ai_product_id for r in responses if r.ai_product_id})
    products = {}
    if product_ids:
        prods = (await db.execute(select(AiProduct).where(AiProduct.id.in_(product_ids)))).scalars().all()
        products = {p.id: p for p in prods}

    # Load all nodes for the framework (for hierarchy grouping)
    all_nodes = (await db.execute(
        select(FrameworkNode)
        .where(FrameworkNode.framework_id == inst.framework_id, FrameworkNode.is_active == True)
        .order_by(FrameworkNode.sort_order)
    )).scalars().all()
    node_map = {n.id: n for n in all_nodes}

    # Load evidence counts
    resp_ids = [r.id for r in responses]
    evidence_counts = {}
    if resp_ids:
        ev_rows = (await db.execute(
            select(AssessmentEvidence.response_id, func.count())
            .where(AssessmentEvidence.response_id.in_(resp_ids))
            .group_by(AssessmentEvidence.response_id)
        )).all()
        evidence_counts = {r[0]: r[1] for r in ev_rows}

    # ── Derived Data ──
    entity_name = inst.assessed_entity.name if inst.assessed_entity else "Unknown"
    fw_name = inst.framework.name if inst.framework else "Unknown"
    fw_abbr = inst.framework.abbreviation if inst.framework else ""
    cycle_name = inst.cycle.cycle_name if inst.cycle else ""
    has_products = len(products) > 0

    # Build hierarchy: group nodes by parent
    top_level_nodes = [n for n in all_nodes if n.parent_id is None]
    children_map = {}
    for n in all_nodes:
        if n.parent_id:
            children_map.setdefault(n.parent_id, []).append(n)

    # Response lookup: (node_id, product_id) -> response
    resp_map = {}
    for r in responses:
        key = (r.node_id, r.ai_product_id)
        resp_map[key] = r

    # Compliance stats
    def _count_compliance(resp_list):
        c = sum(1 for r in resp_list if r.computed_score_label == "Compliant")
        s = sum(1 for r in resp_list if r.computed_score_label in ("Semi-Compliant", "Partially Compliant"))
        n = sum(1 for r in resp_list if r.computed_score_label == "Non-Compliant")
        p = sum(1 for r in resp_list if r.status == "pending")
        return c, s, n, p

    total_c, total_s, total_n, total_p = _count_compliance(responses)
    total_answered = total_c + total_s + total_n

    # ── Build PDF ──
    buffer = BytesIO()
    styles = _get_styles()

    doc = SimpleDocTemplate(
        buffer, pagesize=A4,
        leftMargin=15 * mm, rightMargin=15 * mm,
        topMargin=18 * mm, bottomMargin=20 * mm,
    )

    story = []

    # Helper to add header/footer
    def on_page(canvas, doc):
        _header_footer(canvas, doc, entity_name, fw_name)

    # ==================== COVER / TITLE ====================
    story.append(Spacer(1, 30))
    story.append(Paragraph("Compliance Assessment Report", styles["KPMGTitle"]))
    story.append(Paragraph(_ar(f"{fw_name} ({fw_abbr})"), styles["KPMGSubtitle"]))
    story.append(HRFlowable(width="100%", thickness=2, color=KPMG_NAVY, spaceAfter=12))

    # Summary info table
    info_data = [
        ["Entity", _ar(entity_name)],
        ["Framework", _ar(f"{fw_name} ({fw_abbr})")],
        ["Assessment Cycle", _ar(cycle_name)],
        ["Status", inst.status.replace("_", " ").title()],
        ["Report Date", datetime.now().strftime("%B %d, %Y")],
    ]
    if has_products:
        info_data.append(["AI Products", str(len(products))])

    info_table = Table(info_data, colWidths=[120, 360])
    info_table.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (0, -1), FONT_NAME_BOLD),
        ("FONTNAME", (1, 0), (1, -1), FONT_NAME),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("TEXTCOLOR", (0, 0), (0, -1), KPMG_NAVY),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 2),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
    ]))
    story.append(info_table)
    story.append(Spacer(1, 16))

    # ==================== EXECUTIVE SUMMARY ====================
    story.append(Paragraph("1. Executive Summary", styles["SectionHeader"]))

    pct_compliant = round((total_c / total_answered) * 100) if total_answered else 0
    pct_semi = round((total_s / total_answered) * 100) if total_answered else 0
    pct_non = round((total_n / total_answered) * 100) if total_answered else 0

    summary_text = (
        f"This report presents the results of the <b>{_ar(fw_name)}</b> compliance assessment "
        f"for <b>{_ar(entity_name)}</b>. "
        f"Out of <b>{inst.total_assessable_nodes}</b> total assessable items, "
        f"<b>{total_answered}</b> have been evaluated. "
        f"The overall compliance rate is <b>{pct_compliant}%</b>."
    )
    story.append(Paragraph(summary_text, styles["BodyText"]))
    story.append(Spacer(1, 8))

    # Compliance summary table
    summary_data = [
        ["Status", "Count", "Percentage"],
        ["Compliant", str(total_c), f"{pct_compliant}%"],
        ["Partially Compliant", str(total_s), f"{pct_semi}%"],
        ["Non-Compliant", str(total_n), f"{pct_non}%"],
    ]
    if total_p > 0:
        summary_data.append(["Pending", str(total_p), ""])

    summary_table = Table(summary_data, colWidths=[160, 80, 80])
    summary_table.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, 0), FONT_NAME_BOLD),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("BACKGROUND", (0, 0), (-1, 0), KPMG_NAVY),
        ("TEXTCOLOR", (0, 0), (-1, 0), WHITE),
        ("BACKGROUND", (0, 1), (-1, 1), LIGHT_GREEN),
        ("BACKGROUND", (0, 2), (-1, 2), LIGHT_YELLOW),
        ("BACKGROUND", (0, 3), (-1, 3), LIGHT_RED),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#D1D5DB")),
        ("ALIGN", (1, 0), (-1, -1), "CENTER"),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    story.append(summary_table)
    story.append(Spacer(1, 8))

    # Score bar
    story.append(_build_score_bar(total_c, total_s, total_n, total_answered, width=480))
    story.append(Spacer(1, 12))

    # ==================== PER-PRODUCT SUMMARY (if applicable) ====================
    if has_products:
        story.append(Paragraph("2. Product-Level Summary", styles["SectionHeader"]))
        story.append(Paragraph(
            f"The assessment covers <b>{len(products)}</b> AI product(s). "
            "Each product is assessed independently against all requirements.",
            styles["BodyText"]
        ))
        story.append(Spacer(1, 6))

        prod_header = ["Product", "Compliant", "Partial", "Non-Compl.", "Total", "Score"]
        prod_rows = [prod_header]
        for pid, prod in products.items():
            prod_resps = [r for r in responses if r.ai_product_id == pid]
            pc, ps, pn, pp = _count_compliance(prod_resps)
            pt = pc + ps + pn
            pct = f"{round((pc / pt) * 100)}%" if pt else "0%"
            prod_rows.append([_ar(prod.name), str(pc), str(ps), str(pn), str(pt), pct])

        prod_table = Table(prod_rows, colWidths=[160, 70, 70, 70, 60, 60])
        prod_style = [
            ("FONTNAME", (0, 0), (-1, 0), FONT_NAME_BOLD),
            ("FONTSIZE", (0, 0), (-1, -1), 9),
            ("BACKGROUND", (0, 0), (-1, 0), KPMG_NAVY),
            ("TEXTCOLOR", (0, 0), (-1, 0), WHITE),
            ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#D1D5DB")),
            ("ALIGN", (1, 0), (-1, -1), "CENTER"),
            ("TOPPADDING", (0, 0), (-1, -1), 4),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ]
        # Alternate row colors
        for i in range(1, len(prod_rows)):
            if i % 2 == 0:
                prod_style.append(("BACKGROUND", (0, i), (-1, i), LIGHT_GREY))
        prod_table.setStyle(TableStyle(prod_style))
        story.append(prod_table)
        story.append(Spacer(1, 12))

    # ==================== DOMAIN/TOP-LEVEL BREAKDOWN ====================
    section_num = 3 if has_products else 2
    story.append(Paragraph(f"{section_num}. Assessment by {top_level_nodes[0].node_type if top_level_nodes else 'Domain'}", styles["SectionHeader"]))

    for top_node in top_level_nodes:
        # Get all assessable descendants
        def _get_descendants(node_id):
            result = []
            for child in children_map.get(node_id, []):
                if child.is_assessable:
                    result.append(child)
                result.extend(_get_descendants(child.id))
            return result

        desc_nodes = _get_descendants(top_node.id)
        desc_node_ids = {n.id for n in desc_nodes}

        # Get responses for this domain
        domain_resps = [r for r in responses if r.node_id in desc_node_ids]
        if not domain_resps:
            continue

        dc, ds, dn, dp = _count_compliance(domain_resps)
        dt = dc + ds + dn
        dpct = round((dc / dt) * 100) if dt else 0

        story.append(Paragraph(
            f"<b>{top_node.reference_code or ''}</b> {_ar(top_node.name)}",
            styles["SubHeader"]
        ))

        # Score bar for domain
        story.append(_build_score_bar(dc, ds, dn, dt, width=480))
        story.append(Spacer(1, 2))
        story.append(Paragraph(
            f"Compliant: {dc} | Partially Compliant: {ds} | Non-Compliant: {dn} | "
            f"Compliance Rate: <b>{dpct}%</b>",
            styles["SmallText"]
        ))
        story.append(Spacer(1, 6))

        # Build detail table for this domain
        if has_products:
            detail_header = ["Ref", "Requirement", "Product", "Status", "Justification"]
            col_widths = [45, 140, 100, 75, 120]
        else:
            detail_header = ["Ref", "Requirement", "Status", "Justification"]
            col_widths = [50, 190, 80, 160]

        detail_rows = [detail_header]
        for node in desc_nodes:
            if has_products:
                for pid, prod in products.items():
                    r = resp_map.get((node.id, pid))
                    if not r:
                        continue
                    rd = r.response_data or {}
                    just = rd.get("justification", "")
                    if len(just) > 100:
                        just = just[:97] + "..."
                    detail_rows.append([
                        Paragraph(node.reference_code or "", styles["CellText"]),
                        Paragraph(_ar(node.name or ""), styles["CellText"]),
                        Paragraph(_ar(prod.name), styles["CellText"]),
                        Paragraph(r.computed_score_label or "Pending", styles["CellText"]),
                        Paragraph(_ar(just), styles["CellText"]),
                    ])
            else:
                r = resp_map.get((node.id, None))
                if not r:
                    continue
                rd = r.response_data or {}
                just = rd.get("justification", "")
                if len(just) > 120:
                    just = just[:117] + "..."
                detail_rows.append([
                    Paragraph(node.reference_code or "", styles["CellText"]),
                    Paragraph(_ar(node.name or ""), styles["CellText"]),
                    Paragraph(r.computed_score_label or "Pending", styles["CellText"]),
                    Paragraph(_ar(just), styles["CellText"]),
                ])

        if len(detail_rows) > 1:
            detail_table = Table(detail_rows, colWidths=col_widths, repeatRows=1)
            detail_style_rules = [
                ("FONTNAME", (0, 0), (-1, 0), FONT_NAME_BOLD),
                ("FONTSIZE", (0, 0), (-1, 0), 8),
                ("BACKGROUND", (0, 0), (-1, 0), KPMG_BLUE),
                ("TEXTCOLOR", (0, 0), (-1, 0), WHITE),
                ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#E0E0E0")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
                ("LEFTPADDING", (0, 0), (-1, -1), 4),
                ("RIGHTPADDING", (0, 0), (-1, -1), 4),
            ]
            # Color status cells
            status_col = 3 if has_products else 2
            for i in range(1, len(detail_rows)):
                row_data = detail_rows[i]
                status_para = row_data[status_col]
                status_text = status_para.text if hasattr(status_para, "text") else str(status_para)
                detail_style_rules.append(
                    ("BACKGROUND", (status_col, i), (status_col, i), _compliance_bg(status_text))
                )
                if i % 2 == 0:
                    for col in range(len(detail_rows[0])):
                        if col != status_col:
                            detail_style_rules.append(
                                ("BACKGROUND", (col, i), (col, i), colors.HexColor("#FAFAFA"))
                            )

            detail_table.setStyle(TableStyle(detail_style_rules))
            story.append(detail_table)

        story.append(Spacer(1, 10))

    # ==================== GAP ANALYSIS ====================
    section_num += 1
    non_compliant_resps = [r for r in responses if r.computed_score_label == "Non-Compliant"]
    semi_compliant_resps = [r for r in responses if r.computed_score_label in ("Semi-Compliant", "Partially Compliant")]

    if non_compliant_resps or semi_compliant_resps:
        story.append(PageBreak())
        story.append(Paragraph(f"{section_num}. Gap Analysis & Recommendations", styles["SectionHeader"]))
        story.append(Paragraph(
            "The following items require attention to achieve full compliance.",
            styles["BodyText"]
        ))
        story.append(Spacer(1, 8))

        # Non-compliant items first
        if non_compliant_resps:
            story.append(Paragraph("Non-Compliant Items", styles["SubHeader"]))

            if has_products:
                gap_header = ["Ref", "Requirement", "Product", "Recommendation"]
                gap_widths = [45, 140, 100, 195]
            else:
                gap_header = ["Ref", "Requirement", "Recommendation"]
                gap_widths = [50, 190, 240]

            gap_rows = [gap_header]
            for r in sorted(non_compliant_resps,
                            key=lambda x: (x.node.reference_code or "") if x.node else ""):
                rd = r.response_data or {}
                rec = rd.get("recommendation", "")
                if len(rec) > 120:
                    rec = rec[:117] + "..."
                row = [
                    Paragraph(r.node.reference_code or "", styles["CellText"]),
                    Paragraph(_ar(r.node.name or ""), styles["CellText"]),
                ]
                if has_products:
                    prod_name = products[r.ai_product_id].name if r.ai_product_id in products else ""
                    row.append(Paragraph(_ar(prod_name), styles["CellText"]))
                row.append(Paragraph(_ar(rec), styles["CellText"]))
                gap_rows.append(row)

            gap_table = Table(gap_rows, colWidths=gap_widths, repeatRows=1)
            gap_table.setStyle(TableStyle([
                ("FONTNAME", (0, 0), (-1, 0), FONT_NAME_BOLD),
                ("FONTSIZE", (0, 0), (-1, 0), 8),
                ("BACKGROUND", (0, 0), (-1, 0), RED),
                ("TEXTCOLOR", (0, 0), (-1, 0), WHITE),
                ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#E0E0E0")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
            ]))
            story.append(gap_table)
            story.append(Spacer(1, 10))

        # Semi-compliant items
        if semi_compliant_resps:
            story.append(Paragraph("Partially Compliant Items", styles["SubHeader"]))

            if has_products:
                gap_header = ["Ref", "Requirement", "Product", "Recommendation"]
                gap_widths = [45, 140, 100, 195]
            else:
                gap_header = ["Ref", "Requirement", "Recommendation"]
                gap_widths = [50, 190, 240]

            gap_rows = [gap_header]
            for r in sorted(semi_compliant_resps,
                            key=lambda x: (x.node.reference_code or "") if x.node else ""):
                rd = r.response_data or {}
                rec = rd.get("recommendation", "")
                if len(rec) > 120:
                    rec = rec[:117] + "..."
                row = [
                    Paragraph(r.node.reference_code or "", styles["CellText"]),
                    Paragraph(_ar(r.node.name or ""), styles["CellText"]),
                ]
                if has_products:
                    prod_name = products[r.ai_product_id].name if r.ai_product_id in products else ""
                    row.append(Paragraph(_ar(prod_name), styles["CellText"]))
                row.append(Paragraph(_ar(rec), styles["CellText"]))
                gap_rows.append(row)

            gap_table = Table(gap_rows, colWidths=gap_widths, repeatRows=1)
            gap_table.setStyle(TableStyle([
                ("FONTNAME", (0, 0), (-1, 0), FONT_NAME_BOLD),
                ("FONTSIZE", (0, 0), (-1, 0), 8),
                ("BACKGROUND", (0, 0), (-1, 0), YELLOW),
                ("TEXTCOLOR", (0, 0), (-1, 0), BLACK),
                ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#E0E0E0")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
            ]))
            story.append(gap_table)

    # ── Build ──
    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    buffer.seek(0)
    return buffer
