# SKILL: iOS Snapshot Testing & Dark Mode Validation

## What this skill is

Ability to validate iOS UI using **snapshot tests** (image-based comparisons) instead of or in addition to UI tests, including supporting light/dark mode and rendering views without running the full app.

Use this skill when:

- You need confidence that key screens did not change visually (layout, fonts, colors, localizations, dark mode).
- You want visual artifacts for PR review or automated screenshots (for example, App Store).

Avoid using this skill as the primary testing strategy for business logic or behavior.

## What I expect from the AI

When I say "add snapshot tests" or "snapshot this screen," you should:

- Prefer **native UIKit APIs** (`UIGraphicsImageRenderer`, `UITraitCollection`) over third-party libraries unless I explicitly ask for a library.
- Generate test helpers that:
  - Render a `UIViewController` or `UIView` into an image deterministically.
  - Save or compare PNG data to a reference snapshot stored under a `__Snapshots__` or similar folder in the test target.
  - Support multiple device configurations and traits (for example, iPhone 15 Pro light/dark, different content sizes) via helper enums or factory methods.
- Keep snapshot tests focused and minimal: only for important, stable UI components (for example, feed screens, error states) rather than every view.
- Combine snapshot tests with existing **unit** and **integration** tests, not instead of them.

When generating code, please:

- Show how to record snapshots vs. assert snapshots (for example, a `record` vs `assert` mode).
- Make it easy to run these tests on CI with a fixed simulator configuration (document the required simulator model and OS).

## Core concepts I know and want to apply

### Snapshot testing

- A snapshot test renders a view (or view controller) into an image, stores that image as a reference, and later compares new renders against it. The test passes if the images match and fails if they differ.
- This is great for:
  - Catching unintended visual regressions (layout shifts, color changes, font tweaks).
  - Validating UI in different localizations or configurations (for example, long text, RTL).
  - Providing visual diffs in PRs and generating screenshots programmatically.

### Strengths vs weaknesses

- **Strengths**:
  - Faster than full UI tests (no app launch or UI automation).
  - Easily reviewable: diffs are visual and can be committed to Git.
  - Can be added to CI for visual regression checks.
- **Weaknesses**:
  - **Reliability**: tied to specific simulator/device details (size, scale, color gamut, font rendering); OS/simulator changes may require snapshot updates.
  - **Performance**: slower than unit tests due to rendering and file I/O; not suitable as a tight inner-loop development tool.
  - **Precision**: failures say "image changed" but not which behavior broke; you have to inspect diffs manually.
- Strategy implication:
  - Base of the pyramid: reliable, fast, precise **unit tests** for behavior.
  - Middle: **integration tests** for collaborations.
  - Top: a **few** snapshot tests where visual correctness really matters.

### Dark mode support

- The same snapshot helpers should support rendering with different `UITraitCollection` configurations (light/dark mode).
- Useful pattern: snapshot each key screen in:
  - Light mode
  - Dark mode
  - Sometimes different Dynamic Type sizes (if important).
- Design guidance comes from Apple's Human Interface Guidelines for Dark Mode.

## Implementation preferences

When you scaffold snapshot testing helpers for me:

- Use `UIGraphicsImageRenderer` to render the view hierarchy into an image.
- Wrap device and trait presets in a simple type, for example:
  - `enum SnapshotConfiguration { case iPhone15Pro(style: UIUserInterfaceStyle) /* ... */ }`
  - Helper that applies `UITraitCollection` (including `userInterfaceStyle`) and frame size before rendering.
- Provide:
  - `record(snapshot:named:file:line:)` to save a new snapshot.
  - `assert(snapshot:named:file:line:)` to compare to an existing snapshot and fail with a readable message.
- Store snapshots in a stable folder inside the test bundle (for example, `__Snapshots__`), and assume tests run on a single agreed-upon simulator/config.

## How NOT to use this skill

- Do not use snapshot tests to validate business logic, branching behavior, or domain rules; those belong in unit/integration tests.
- Do not try to make snapshot tests the main safety net; they should be a thin visual layer on top of a solid testing pyramid.
- Do not over-snapshot rapidly changing UI; that creates churn and noisy PRs.

## References for deeper context

- Course PR diff for this episode (example implementation):
  - [https://github.com/essentialdevelopercom/essential-feed-case-study/pull/38](https://github.com/essentialdevelopercom/essential-feed-case-study/pull/38)
- Apple docs:
  - Dark Mode HIG: [https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode)
  - `UIGraphicsImageRenderer`: [https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer](https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer)
  - `UITraitCollection`: [https://developer.apple.com/documentation/uikit/uitraitcollection](https://developer.apple.com/documentation/uikit/uitraitcollection)

