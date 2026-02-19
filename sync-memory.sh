#!/bin/bash
# Regenerate memory-index.json from workspace memory files
# Run this anytime memory files are updated

WORKSPACE="$HOME/.openclaw/workspace"
OUTPUT="$(dirname "$0")/memory-index.json"

python3 << 'PYEOF'
import json, os, glob
from datetime import datetime

workspace = os.path.expanduser("~/.openclaw/workspace")
memories = []

# MEMORY.md
with open(os.path.join(workspace, "MEMORY.md")) as f:
    content = f.read()
memories.append({
    "id": "memory-main",
    "filename": "MEMORY.md",
    "title": "Long-Term Memory",
    "icon": "🧠",
    "category": "core",
    "date": None,
    "content": content,
    "size": len(content),
    "lines": content.count('\n') + 1
})

for fp in sorted(glob.glob(os.path.join(workspace, "memory/**/*.md"), recursive=True)):
    with open(fp) as f:
        content = f.read()
    fname = os.path.basename(fp)
    title = fname.replace('.md', '')
    for line in content.split('\n'):
        if line.startswith('# '):
            title = line[2:].strip()
            break
    if '/journal/' in fp:
        category, icon = 'journal', '📓'
    elif fname.startswith('2026-'):
        category, icon = 'daily', '📝'
    elif 'estimate' in fname or 'bid' in fname:
        category, icon = 'business', '💰'
    elif 'heartbeat' in fname or 'reminder' in fname:
        category, icon = 'system', '⚙️'
    else:
        category, icon = 'reference', '📄'
    date = None
    parts = fname.split('-')
    if len(parts) >= 3 and parts[0].isdigit():
        try: date = f"{parts[0]}-{parts[1]}-{parts[2][:2]}"
        except: pass
    memories.append({
        "id": f"mem-{fname.replace('.md','').replace(' ','-')}",
        "filename": fname, "path": fp, "title": title, "icon": icon,
        "category": category, "date": date, "content": content,
        "size": len(content), "lines": content.count('\n') + 1
    })

output = {
    "lastUpdated": datetime.now().astimezone().isoformat(),
    "totalFiles": len(memories),
    "totalSize": sum(m["size"] for m in memories),
    "memories": memories
}

out_path = os.path.join(os.path.dirname(os.path.abspath("__file__")), "MISSION_CONTROL_DIR", "memory-index.json")
# Write to script's directory
import sys
script_dir = os.path.dirname(os.path.abspath(sys.argv[0])) if len(sys.argv) > 0 else "."
with open(os.path.expanduser("~/Projects/mission-control/memory-index.json"), "w") as f:
    json.dump(output, f, indent=2)
import re
secret_patterns = [
    r'ghp_[A-Za-z0-9]{36,}', r'gho_[A-Za-z0-9]{36,}',
    r'github_pat_[A-Za-z0-9_]{80,}', r'sk-[A-Za-z0-9]{20,}',
    r'xoxb-[A-Za-z0-9\-]+', r'Bearer [A-Za-z0-9\-_.]{20,}',
]
for m in memories:
    for pat in secret_patterns:
        m['content'] = re.sub(pat, '[REDACTED]', m['content'])

print(f"✓ Indexed {len(memories)} files ({sum(m['size'] for m in memories)} bytes)")
PYEOF
