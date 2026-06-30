---
name: projects
description: List all projects in the workspace with git status
---

# Projects

When the user asks about projects or types `/projects`, use the `exec` tool to run:

```bash
echo "=== Projects ==="
for dir in ~/workspace/projects/*/; do
  name=$(basename "$dir")
  if [ -d "$dir/.git" ]; then
    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    status=$(git -C "$dir" status --short 2>/dev/null | wc -l)
    echo "  $name (git: $branch, $status uncommitted)"
  else
    echo "  $name (no git)"
  fi
done
echo ""
echo "Total projects: $(ls -d ~/workspace/projects/*/ 2>/dev/null | wc -l)"
```
