"""
Automated AI Badges assessment runner.
1. Parse evidence document into per-node answers
2. Save answers to each node's response
3. Upload evidence document to each node
4. Run AI Assess on each node
5. Accept AI suggestions
"""
import json, sys, time, os, requests
import docx

BASE = "http://localhost:4200/api"
DOC_PATH = r"C:\Users\amroa\Downloads\MOF_Chatbot_Full_Evidence.docx"

# Login
r = requests.post(f"{BASE}/auth/login", json={"email": "admin@kpmg.com", "password": "Admin123!"})
TOKEN = r.json()["access_token"]
H = {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"}

# Get instance
insts = requests.get(f"{BASE}/assessments", headers=H).json()
inst = next(i for i in insts if i.get("framework", {}).get("abbreviation") == "AI_BADGES")
INST_ID = inst["id"]
print(f"Instance: {INST_ID}")

# Get product (Citizen Services Chatbot)
products = requests.get(f"{BASE}/assessments/{INST_ID}/products", headers=H).json()
PRODUCT_ID = next(p["id"] for p in products if "Citizen" in p["name"])
print(f"Product: {PRODUCT_ID}")

# Get nodes for framework
FW_ID = inst["framework"]["id"]
nodes = requests.get(f"{BASE}/frameworks/{FW_ID}/nodes", headers=H).json()
assessable = {n["reference_code"]: n["id"] for n in nodes if n["is_assessable"]}
print(f"Assessable nodes: {len(assessable)}")

# Parse document
doc = docx.Document(DOC_PATH)
current_ref = None
answers = {}
for p in doc.paragraphs:
    text = p.text.strip()
    if not text:
        continue
    style = p.style.name if p.style else ""
    if style == "Heading 2" and ":" in text:
        ref_part = text.split(":")[0].strip()
        current_ref = ref_part
        answers[current_ref] = ""
    elif current_ref and style != "Heading 1":
        answers[current_ref] = (answers.get(current_ref, "") + " " + text).strip()

print(f"Parsed answers: {len(answers)}")

# Step 1: Save answers
print("\n=== STEP 1: Saving answers ===")
saved = 0
for ref, answer_text in sorted(answers.items()):
    node_id = assessable.get(ref)
    if not node_id:
        print(f"  SKIP {ref} - no matching node")
        continue
    payload = {
        "response_data": {"answer": answer_text},
        "status": "draft",
        "ai_product_id": PRODUCT_ID,
    }
    r = requests.put(f"{BASE}/assessments/{INST_ID}/responses/{node_id}", json=payload, headers=H)
    if r.status_code == 200:
        saved += 1
        print(f"  OK {ref}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Saved {saved} answers")

# Step 2: Upload evidence document to each node
print("\n=== STEP 2: Uploading evidence ===")
uploaded = 0
for ref in sorted(answers.keys()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    with open(DOC_PATH, "rb") as f:
        files = {"file": ("MOF_Chatbot_Full_Evidence.docx", f, "application/vnd.openxmlformats-officedocument.wordprocessingml.document")}
        auth_h = {"Authorization": f"Bearer {TOKEN}"}
        r = requests.post(f"{BASE}/assessments/{INST_ID}/responses/{node_id}/evidence?ai_product_id={PRODUCT_ID}", files=files, headers=auth_h)
    if r.status_code == 201:
        uploaded += 1
        print(f"  OK {ref}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Uploaded to {uploaded} nodes")

# Step 3: Run AI Assess on all nodes
print("\n=== STEP 3: Running AI Assess ===")
suggestions = {}
for ref in sorted(answers.keys()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    payload = {"ai_product_id": PRODUCT_ID}
    r = requests.post(f"{BASE}/assessments/{INST_ID}/ai-assess/{node_id}", json=payload, headers=H, timeout=180)
    if r.status_code == 200:
        data = r.json()
        suggestion = data.get("suggestion", {})
        status = suggestion.get("compliance_status", "?")
        confidence = suggestion.get("confidence", 0)
        suggestions[ref] = data
        print(f"  OK {ref}: {status} ({confidence}% confidence)")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:150]}")
    time.sleep(0.5)  # Rate limit
print(f"AI assessed {len(suggestions)} nodes")

# Step 4: Accept all suggestions
print("\n=== STEP 4: Accepting suggestions ===")
accepted = 0
for ref, data in sorted(suggestions.items()):
    node_id = assessable.get(ref)
    if not node_id:
        continue
    suggestion = data.get("suggestion", {})
    suggestion["_ai_product_id"] = PRODUCT_ID
    r = requests.post(f"{BASE}/assessments/{INST_ID}/ai-assess/{node_id}/accept", json={"suggestion": suggestion}, headers=H)
    if r.status_code == 200:
        accepted += 1
        print(f"  OK {ref}: {suggestion.get('compliance_status', '?')}")
    else:
        print(f"  FAIL {ref}: {r.status_code} {r.text[:100]}")
print(f"Accepted {accepted} suggestions")

# Summary
print("\n=== SUMMARY ===")
stats = requests.get(f"{BASE}/assessments/{INST_ID}/compliance-stats?ai_product_id={PRODUCT_ID}", headers=H).json()
print(json.dumps(stats, indent=2))
