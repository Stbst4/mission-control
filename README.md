# 🦞 Mission Control

Task board for Brant's Asphalt — tracks all active tasks between Shane and Clawd.

## Live Board
**[https://stbst4.github.io/mission-control](https://stbst4.github.io/mission-control)**

## How It Works
- `tasks.json` — source of truth for all tasks
- `index.html` — static dashboard (no build step, no dependencies)
- Clawd updates `tasks.json` in real-time as tasks are created, updated, or completed
- GitHub Pages serves the board automatically

## Task Schema
```json
{
  "id": "task-001",
  "title": "Task name",
  "description": "What needs to happen",
  "assignee": "shane | clawd",
  "status": "todo | in-progress | blocked | done",
  "priority": "high | medium | low",
  "category": "sales | automation | operations | dev | admin",
  "created": "YYYY-MM-DD",
  "updated": "YYYY-MM-DD",
  "dueDate": "YYYY-MM-DD (optional)",
  "blockedBy": "task-id (optional)"
}
```
