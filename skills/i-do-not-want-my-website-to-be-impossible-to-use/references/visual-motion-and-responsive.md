# Visual, Motion & Responsive

Review:
- text/non-text contrast;
- zoom/reflow;
- text-spacing resilience;
- touch-target usability;
- orientation;
- reduced-motion preference;
- flashing/rapid animation;
- color-only information;
- hover-only behavior.

## Checks
- `A11Y-CONTRAST-001` MEDIUM: important text/control contrast is insufficient
  against its actual background.
- `A11Y-COLOR-001` MEDIUM: color alone communicates required state.
- `A11Y-REFLOW-001` HIGH/MEDIUM: critical content/action becomes unusable when
  zoomed or narrow.
- `A11Y-MOTION-001` HIGH/MEDIUM: nonessential motion ignores reduction settings
  or creates meaningful safety/usability risk.
- `A11Y-TOUCH-001` LOW/MEDIUM: controls are impractically small/crowded.

Measure contrast when tools are available; do not guess ratios from color names.
