# Testing Boundaries

Evidence levels:

1. source/static inspection;
2. automated browser audit;
3. manual keyboard/pointer/zoom testing;
4. assistive-technology testing with named browser/AT combinations;
5. user testing.

Never upgrade one evidence level into another.

A clean automated scan does not establish full accessibility conformance.

If assistive technology is unavailable:

```text
A11Y-AT-001 — NOT_VERIFIED
Assistive-technology behavior was not tested.
```

When runtime tests occur, record browser, viewport, zoom, input method and
AT/version when relevant.
