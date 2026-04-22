# SKILL: Safe UITableView Work Cancellation & Layout-Aware Testing

## What this skill is

Ability to safely start and cancel per-cell work (e.g. image loading) based on `UITableViewDelegate` events, and to write integration tests that reliably trigger those events by enforcing layout and run loop behavior.[page:4]

Use this skill when:
- You start expensive operations in `cellForRowAt` (network, disk, image decode).
- You cancel work when cells go off-screen or are reused.
- You need tests that verify cancellation and avoid crashes/leaks.[page:4]

---

## What I expect from the AI

When I mention:
- "cancel work on didEndDisplaying"
- "avoid index out of range on reloadData"
- "enforce layout in tests"

You should:
- Avoid accessing `tableModel[indexPath.row]` inside `didEndDisplaying` or other delegate methods that may be called after the model changes.[page:4]
- Propose using a separate lookup structure, e.g. `[IndexPath: Item]`, to track active work and cancel via that structure instead of indexing the current model.[page:4]
- In tests, explicitly:
  - Force layout with `tableView.layoutIfNeeded()`.
  - Run the run loop with `RunLoop.current.run(until: Date())` (and if needed once more for iOS 14+ style behavior) to let UIKit deliver delegate events and clean up views.[page:4]
- Avoid `RunLoop.current.run()` with no end date, which can hang tests.[page:4]

When generating code:
- Prefer clear separation between:
  - "start work" (in `cellForRowAt`, or a dedicated cell controller).
  - "cancel work" (in `didEndDisplaying` / `prepareForReuse`).
- Keep `UITableView` logic minimal; heavy logic belongs in cell controllers or presenters.[page:4]

---

## Core patterns I know and want to apply

### 1) Safe cancellation by lookup table

**Problem**: `didEndDisplaying` may be called after `tableModel` changed, so indexing `tableModel[indexPath.row]` can crash (out of bounds).[page:4]

**Pattern**: track active items in a dictionary keyed by `IndexPath`:

```swift
private var loadingItems = [IndexPath: Item]()

func tableView(_ tableView: UITableView,
               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let model = tableModel[indexPath.row]
    loadingItems[indexPath] = model
    model.startLoadingExpensiveOperation()
    cell.textLabel?.text = model.text
    return cell
}

func tableView(_ tableView: UITableView,
               didEndDisplaying cell: UITableViewCell,
               forRowAt indexPath: IndexPath) {
    let model = loadingItems[indexPath]
    model?.cancelLoadingExpensiveOperation()
    loadingItems[indexPath] = nil
}
```

This decouples cancellation from the current model size while ensuring the right model gets the cancel message.[page:4]

### 2) Enforcing UIKit layout in tests

UIKit defers layout for performance. To trigger delegate events like `didEndDisplaying` in tests:

```swift
tableView.layoutIfNeeded()
RunLoop.current.run(until: Date())
```

- `layoutIfNeeded()` forces a layout pass so cells are created/removed.[page:4]
- `RunLoop.current.run(until: Date())` gives UIKit a chance to send delegate callbacks and release objects, preventing test leaks.[page:4]

On newer iOS versions (14+), running the run loop again after assertions may be necessary in some scenarios; follow the pattern from the course commit when in doubt.[page:4]

### 3) Run loop usage

- DO: `RunLoop.current.run(until: Date())` (or `Date() + small delta`) to run a finite amount of time.[page:4]
- DON'T: `RunLoop.current.run()` in tests - it spins a nested run loop indefinitely unless explicitly stopped and can cause tests to hang.[page:4]

---

## How NOT to use this skill

- Don't use `tableModel[indexPath.row]` in delegate callbacks that might be called after `reloadData` changes the model length.[page:4]
- Don't rely on "it works now because backend never deletes items"; treat model shrinkage as expected and design for it.[page:4]
- Don't leave tests without a run-loop "tick" when you rely on UIKit delegate callbacks; that leads to flaky tests and false positives on leaks.[page:4]

---

## References

- UITableView.reloadData:
  https://developer.apple.com/documentation/uikit/uitableview/1614862-reloaddata[page:4]
- UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:):
  https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614870-tableview[page:4]
- UIView.layoutIfNeeded:
  https://developer.apple.com/documentation/uikit/uiview/1622507-layoutifneeded[page:4]
- RunLoop:
  https://developer.apple.com/documentation/foundation/runloop[page:4]
- Lecture PR:
  https://github.com/essentialdevelopercom/essential-feed-case-study/pull/45[page:4]
- iOS 14+ run loop tweak:
  https://github.com/essentialdevelopercom/essential-feed-case-study/commit/a0b35260a530f34268ce0c3a72e19fae9ad71e26[page:4]
