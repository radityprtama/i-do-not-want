# Commerce, Subscriptions & Refunds

Applicable only when the product accepts payment or sells plans/credits/goods/
services.

Identify:
- one-time vs recurring;
- billing interval;
- trial;
- automatic renewal;
- usage billing;
- digital vs physical offering;
- cancellation path;
- refund implementation;
- taxes/fees presentation;
- payment processor.

## Checks
- `LEGAL-COMMERCE-001` HIGH: recurring charge/renewal is materially obscured.
- `LEGAL-COMMERCE-002` HIGH/MEDIUM: displayed price/interval contradicts the
  actual checkout.
- `LEGAL-COMMERCE-003` MEDIUM: cancellation is promised but missing/broken.
- `LEGAL-REFUND-001` MEDIUM: refund disclosure is missing/contradictory when
  relevant to the business model and applicable rules.
- `LEGAL-TRIAL-001` MEDIUM: trial conversion timing/price is unclear.

Never invent a 7/14/30-day refund period.
