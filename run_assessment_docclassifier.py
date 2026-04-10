"""
Automated AI Badges assessment for Document Classifier System.
"""
import json, time, requests, docx

BASE = "http://localhost:4200/api"
DOC_PATH = r"C:\Users\amroa\Downloads\MOF_DocClassifier_Full_Evidence.docx"
PRODUCT_NAME = "Document Classifier"

# Login
TOKEN = requests.post(f"{BASE}/auth/login", json={"email": "admin@kpmg.com", "password": "Admin123!"}).json()["access_token"]
H = {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"}

# Get instance
insts = requests.get(f"{BASE}/assessments", headers=H).json()
inst = next(i for i in insts if i.get("framework", {}).get("abbreviation") == "AI_BADGES")
INST_ID = inst["id"]

# Get product
products = requests.get(f"{BASE}/assessments/{INST_ID}/products", headers=H).json()
PRODUCT_ID = next(p["id"] for p in products if "Document" in p["name"] or "classifier" in p["name"].lower())
print(f"Instance: {INST_ID}\nProduct: {PRODUCT_ID} ({next(p['name'] for p in products if p['id']==PRODUCT_ID)})")

# Get assessable nodes
FW_ID = inst["framework"]["id"]
nodes = requests.get(f"{BASE}/frameworks/{FW_ID}/nodes", headers=H).json()
assessable = {n["reference_code"]: n["id"] for n in nodes if n["is_assessable"]}
print(f"Assessable nodes: {len(assessable)}")

# Parse document — handle [PARTIAL EVIDENCE] and [MINIMAL EVIDENCE] prefixes
doc = docx.Document(DOC_PATH)
current_ref = None
answers = {}
for p in doc.paragraphs:
    text = p.text.strip()
    if not text:
        continue
    style = p.style.name if p.style else ""
    if style == "Heading 2" and ":" in text:
        current_ref = text.split(":")[0].strip()
        answers[current_ref] = ""
    elif current_ref and style != "Heading 1":
        # Skip lines that are just status markers
        if text.startswith("[") and text.endswith("]"):
            continue
        answers[current_ref] = (answers.get(current_ref, "") + " " + text).strip()

print(f"Parsed answers: {len(answers)}")

# Step 1: Save answers
print("\n=== STEP 1: Saving answers ===")
saved = 0
for ref, answer_text in sorted(answers.items()):
    node_id = assessable.get(ref)
    if not node_id:
        print(f"  SKIP {ref}")
        continue
    r = requests.put(f"{BASE}/assessments/{INST_ID}/responses/{node_id}",
        json={"response_data": {"answer": answer_text}, "status": "draft", "ai_product_id": PRODUCT_ID}, headers=H)
    if r.status_code == 200:
        saved += 1
        print(f"  OK {ref}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Saved {saved} answers")

# Step 2: Upload evidence
print("\n=== STEP 2: Uploading evidence ===")
uploaded = 0
for ref in sorted(answers.keys()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    with open(DOC_PATH, "rb") as f:
        files = {"file": ("MOF_DocClassifier_Full_Evidence.docx", f, "application/vnd.openxmlformats-officedocument.wordprocessingml.document")}
        r = requests.post(f"{BASE}/assessments/{INST_ID}/responses/{node_id}/evidence?ai_product_id={PRODUCT_ID}",
            files=files, headers={"Authorization": f"Bearer {TOKEN}"})
    if r.status_code == 201:
        uploaded += 1
        print(f"  OK {ref}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Uploaded to {uploaded} nodes")

# Step 3: AI Assess
print("\n=== STEP 3: Running AI Assess ===")
suggestions = {}
for ref in sorted(answers.keys()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    r = requests.post(f"{BASE}/assessments/{INST_ID}/ai-assess/{node_id}",
        json={"ai_product_id": PRODUCT_ID}, headers=H, timeout=180)
    if r.status_code == 200:
        data = r.json()
        s = data.get("suggestion", {})
        suggestions[ref] = data
        print(f"  OK {ref}: {s.get('compliance_status','?')} ({s.get('confidence',0)}%)")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:150]}")
    time.sleep(0.5)
print(f"AI assessed {len(suggestions)} nodes")

# Step 4: Accept
print("\n=== STEP 4: Accepting suggestions ===")
accepted = 0
for ref, data in sorted(suggestions.items()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    suggestion = data.get("suggestion", {})
    suggestion["_ai_product_id"] = PRODUCT_ID
    r = requests.post(f"{BASE}/assessments/{INST_ID}/ai-assess/{node_id}/accept",
        json={"suggestion": suggestion}, headers=H)
    if r.status_code == 200:
        accepted += 1
        print(f"  OK {ref}: {suggestion.get('compliance_status','?')}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Accepted {accepted} suggestions")

# Summary
print("\n=== SUMMARY ===")
stats = requests.get(f"{BASE}/assessments/{INST_ID}/compliance-stats?ai_product_id={PRODUCT_ID}", headers=H).json()
print(json.dumps(stats, indent=2))

# Breakdown
compliant = []
semi = []
non = []
for ref, data in sorted(suggestions.items()):
    s = data.get("suggestion", {}).get("compliance_status", "?")
    if s == "Compliant": compliant.append(ref)
    elif s == "Semi-Compliant": semi.append(ref)
    elif s == "Non-Compliant": non.append(ref)
print(f"\nCompliant ({len(compliant)}): {', '.join(compliant)}")
print(f"Semi-Compliant ({len(semi)}): {', '.join(semi)}")
print(f"Non-Compliant ({len(non)}): {', '.join(non)}")
