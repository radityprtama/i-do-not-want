# Product & Policy Inventory

Establish business/product facts first:

- operator/legal entity: known/unknown;
- product/service description;
- account creation;
- personal-data categories;
- analytics/advertising;
- cookies/client storage;
- payments/billing model;
- subscriptions/auto-renewal/trials;
- cancellation/refund implementation;
- user-generated content;
- minors/age targeting: known/unknown;
- third-party processors;
- external embeds;
- marketing claims/testimonials/reviews;
- customer/partner/press logos;
- third-party assets/fonts/media;
- public policies and effective dates;
- explicitly known target markets/jurisdictions.

## Checks
- `LEGAL-POLICY-001` HIGH/MEDIUM: published policy materially contradicts
  observable product behavior.
- `LEGAL-POLICY-002` MEDIUM: policy contains unresolved template placeholders
  or another company's details.
- `LEGAL-POLICY-003` NOT_VERIFIED: required business facts are unavailable.

Do not infer jurisdiction from developer identity, server region, language,
currency or domain.
