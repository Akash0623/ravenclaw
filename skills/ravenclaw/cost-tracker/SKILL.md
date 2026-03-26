---
name: cost-tracker
description: Track and report API usage costs
trigger: "how much am I spending" OR "cost report" OR "api costs" OR "usage report"
---

# Cost Tracker

When asked about costs or API usage:

1. Check model usage stats if available
2. Calculate estimated costs based on token counts:
   - Claude Sonnet: $3/M input, $15/M output
   - DeepSeek Chat: $0.14/M input, $0.28/M output
3. Show breakdown by model and by day/week/month
4. Compare against budget limits from monitoring config
5. Suggest optimizations if spending is high (e.g., route more queries to cheaper model)

Present as a clean table with totals.
