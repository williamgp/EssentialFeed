# SKILL: Organizing Modular iOS Codebases with Horizontal and Vertical Slicing

## What this skill is

Ability to structure an iOS codebase so features and layers remain decoupled, testable, reusable, and composable across one or more applications.

Use this skill when:

- Designing a new app architecture.
- Refactoring a monolith into modules.
- Splitting code across frameworks, packages, or projects.
- Deciding whether code belongs in a feature, a shared layer, or the app composition root.

---

## What I expect from the AI

When I ask about module boundaries, feature organization, package structure, or where code should live, you should:

- Prefer designs that preserve **decoupling** and **replaceability**.
- Distinguish clearly between:
  - vertical slicing by feature,
  - horizontal slicing by layer,
  - and combinations of both.
- Recommend the **simplest structure that provides meaningful benefit**, not the most elaborate modular setup possible.
- Avoid introducing extra frameworks, packages, or repositories unless there is a real payoff in reuse, team independence, build speed, or deployment needs.

When proposing structures, explain:

- what depends on what,
- why the dependency direction is safe,
- what belongs in Main/Composition,
- and what remains feature- or platform-specific.

---

## Core principles to apply

### 1. Monolith is simplest, but scales poorly

A single project with one application target is easy to start with, but as the team and codebase grow it increases build times, test times, and merge conflicts. It also provides no strong physical separation, so modularity depends mostly on team discipline.

### 2. Vertical slicing = organize by feature

Vertical slices are feature-centered modules such as:

- Feed
- Login
- Payment
- Account

This works well for feature teams because each feature can be developed in relative isolation. However, code inside a feature can still become coupled if the feature itself is not internally layered.

### 3. Horizontal slicing = organize by layer

Horizontal slicing separates the system into architectural layers or rings, following the Dependency Inversion Principle:

- High-level modules should not depend on lower-level modules.

Typical layers may include:

- Domain / Core business rules
- Use cases / application-specific business rules
- Presentation
- Infrastructure / adapters
- UI / platform code
- Main / composition root

Inner or higher-level layers must not depend on lower or outer layers, while outer/lower layers know only the layer directly above them.

### 4. Best default for larger apps: combine both

A strong modular architecture combines:

- vertical slicing by feature, and
- horizontal slicing within each feature.

That means:

- features do not know about each other,
- each feature can contain its own layered structure,
- and the app can compose features differently across platforms or products.

Example:

- iOS app might compose Login + Feed + Account.
- watchOS app might compose only Login + Feed.

### 5. Stronger modularity has a maintenance cost

It is possible to split a feature into many smaller modules, such as:

- FeedFeature
- FeedPresentation
- FeedAPI
- FeedCache
- FeediOSUI

This gives stronger physical boundaries and better reuse/testing flexibility, but it also increases project maintenance, dependency management, and build configuration complexity.

Default recommendation:

- start with meaningful separation,
- avoid fragmentation without payoff,
- split further only when pressure from scale, reuse, or team boundaries justifies it.

### 6. Repositories are a separate decision

Modules can live:

- in one repository (monorepo), or
- in multiple repositories with package/dependency tooling.

Separate repositories add versioning, release coordination, and integration overhead, so they should be used only when the benefits clearly outweigh the ceremony.

Tools that may appear in those setups include:

- Swift Package Manager
- git submodules
- Carthage
- CocoaPods

---

## Practical guidance for real iOS projects

When designing module boundaries for an iOS app, prefer this decision order:

1. Identify features that should be independently understandable or reusable.
2. Within each feature, separate platform-independent code from platform-specific code.
3. Put app composition decisions in Main/Composition Root, not inside reusable feature modules.
4. Extract more frameworks/packages only when build speed, reuse, or ownership boundaries justify it.

A good early split is often:

- Feature/Core
- Feature/Presentation
- Feature/iOSUI
- Feature/API or Feature/Cache when infra is meaningfully distinct

---

## How NOT to use this skill

- Don't split everything into dozens of modules just because modularity sounds good.
- Don't keep low-level infrastructure directly imported into high-level UI or app-specific clients when a boundary/module should mediate that dependency.
- Don't create separate repositories prematurely; repo boundaries are expensive to maintain.
- Don't assume one "perfect" folder or naming scheme exists; names and physical structure depend on team and project needs.

---

## Heuristics I want the AI to follow

When suggesting a modular architecture, optimize for:

1. clear dependency direction,
2. independent testing,
3. low coupling,
4. reuse across apps when valuable,
5. low maintenance overhead,
6. incremental adoption instead of big-bang restructuring.

If there are multiple valid choices, prefer the one with:

- fewer moving parts,
- stronger boundaries where they matter,
- and easier composition in Main.

---

## References

- Lesson: Organizing Modular Codebases with Horizontal and Vertical Slicing.
- Clean Architecture by Robert C. Martin:
  https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- Mentoring Session #006 - Architecture and Software Design:
  linked in the lesson references.
