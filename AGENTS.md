# Expense Tracker — Agent Operating Instructions

This file contains the mandatory engineering instructions for AI coding agents working inside the Expense Tracker repository.

The goal is not to generate the largest amount of code.

The goal is to make the smallest correct, understandable, maintainable change that follows the approved project architecture and documentation.

---

# 1. Source of Truth & Decision Priority

When working on this repository, use the following priority:

1. The user's explicit current task.
2. The latest approved Expense Tracker project documentation and decisions.
3. This `AGENTS.md`.
4. The existing implementation.
5. Common conventions and agent assumptions.

If the current task appears to conflict with an approved architectural, UX/UI, product, or engineering decision:

- Do not silently override the existing decision.
- Explain the conflict.
- Ask for or propose an explicit decision before implementing the conflicting change.

Do not invent missing product or architecture requirements simply to complete a task.

When an important decision has not yet been approved, keep the implementation minimal and report the unresolved decision.

---

# 2. Repository Context

Expense Tracker is a full-stack application contained in one Git repository.

Repository root:

```text
expense-tracker/
├── AGENTS.md
├── docs/
├── mobile/
└── ...
````

`mobile/` is part of the root repository.

It is not a separate Git repository.

Future backend and database implementation belong to the same overall project and should be added only when their implementation stages begin.

Do not create empty top-level folders merely to make the repository look complete.

---

# 3. Approved Technology Stack

## Mobile

* Flutter
* Dart

Supported platforms:

* Android
* iOS

Out of scope:

* Web
* Windows
* Linux
* macOS

Do not recreate Flutter platform folders for unsupported platforms unless explicitly requested.

## Backend

* C#
* ASP.NET Core Web API

## Data Access

* ADO.NET

ADO.NET is an intentional project choice.

Do not introduce Entity Framework / EF Core unless an explicit architectural decision changes the current data-access strategy.

## Database

* SQL Server

## System Communication

The approved system direction is:

```text
Flutter Mobile App
        ↓
   HTTP / HTTPS
        ↓
 ASP.NET Core Web API
        ↓
 Business / Application Logic
        ↓
      ADO.NET
        ↓
    SQL Server
```

Flutter must never connect directly to SQL Server.

Database credentials, SQL connections, and data-access implementation belong on the backend side.

---

# 4. Flutter Architecture

The approved Flutter architecture is:

**Feature-First Structure with Responsibility Separation**

This project does NOT currently use full Clean Architecture.

Do not introduce:

* Domain layers
* Use-case layers
* Repository abstractions
* Data/domain duplication
* Large architectural frameworks

unless a demonstrated project need and explicit architectural decision justify them.

The intended structure grows gradually:

```text
mobile/lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── routes/
│   └── theme/
│
├── core/
│   ├── network/
│   └── constants/
│
└── features/
    └── expenses/
        ├── models/
        ├── services/
        ├── state/
        ├── screens/
        └── widgets/
```

This tree represents intended responsibility boundaries.

It does NOT mean every folder must exist immediately.

## Critical Rule

Do not create a folder, class, abstraction, service, model, controller, helper, or configuration file only because the architecture diagram contains it.

Create it when the implementation gives it a real responsibility.

Avoid speculative infrastructure.

---

# 5. `main.dart`

`main.dart` is the Flutter application entry point.

Keep it minimal.

Its responsibility should generally be:

```text
Application startup
        ↓
runApp(...)
        ↓
Root application widget
```

Do not place Feature-specific logic, networking, expense operations, or complex application configuration directly in `main.dart`.

---

# 6. `app/`

`lib/app/` contains application-wide configuration.

Typical responsibilities include:

* Root application widget.
* `MaterialApp`.
* Application-wide theme configuration.
* Application-wide navigation configuration when such configuration becomes necessary.

Feature-specific Expense Management logic does not belong here.

Do not create `routes/` or `theme/` merely because they appear in the intended architecture.

Create them when implementation responsibilities become real.

---

# 7. `core/`

`core/` exists only for genuinely shared technical infrastructure.

Examples may include:

* Shared network client configuration.
* Base URL configuration.
* Shared request headers.
* Timeouts.
* Truly application-wide constants.

`core/` must not become a miscellaneous dumping ground.

Expense-specific behavior belongs inside the Expense Feature.

---

# 8. Expense Feature

The current main Flutter Feature is:

```text
features/expenses/
```

The approved responsibility areas are:

```text
features/expenses/
├── models/
├── services/
├── state/
├── screens/
└── widgets/
```

Again, create these folders only when needed.

---

# 9. Screen Responsibilities

Expense screens belong under:

```text
features/expenses/screens/
```

Screens are responsible for:

* Rendering UI.
* Receiving user input.
* Showing current UI state.
* Forwarding user actions to the appropriate application logic.
* Triggering approved navigation actions.

Screens must NOT:

* Execute raw HTTP requests.
* Access SQL Server.
* Contain ADO.NET logic.
* Own application-wide state.
* Perform backend data-access logic.
* Become large mixed-responsibility files.

---

# 10. Widget Responsibilities

Expense-specific reusable UI belongs under:

```text
features/expenses/widgets/
```

Extract a Widget when:

* It has a clear UI responsibility.
* It has meaningful reuse.
* Separating it genuinely improves readability.

Do not split every small UI fragment into another file merely to produce more files.

Prefer understandable composition over artificial fragmentation.

---

# 11. Approved Screens

The currently approved screen-level destinations are:

```text
SCR-01   Home
SCR-01.1 Add Expense
```

Do not invent additional Expense Tracker screens during implementation.

## Home

Home is the primary Expense Management screen.

Its approved responsibilities include:

* Application title.
* Add Expense action.
* Spending Chart.
* Expense List.
* Expense Items.

An Expense Item displays relevant Expense information such as:

* Title.
* Amount.
* Category representation.
* Date.

Home must reflect changes to current expenses.

The Spending Chart and Expense List must represent the same current Expense state.

## Add Expense

Add Expense collects the information required to create an Expense.

Its approved UI includes:

* Title input.
* Character-count presentation.
* Amount input.
* Date selection.
* Category selection.
* Cancel.
* Save Expense.

Detailed validation rules belong to the dedicated Form Handling & Client Validation documentation and should not be invented prematurely.

---

# 12. Overlays & Feedback

The following are NOT independent screens or routes:

```text
Date Picker
Category Menu
Undo Snackbar
```

Date Picker and Category Menu are temporary UI overlays associated with Add Expense.

The Undo Snackbar is temporary UI feedback associated with Home.

Do not create navigation routes for these UI elements.

---

# 13. Navigation Decision

The currently approved navigation scope is deliberately simple.

Approved flows:

```text
Home
  ↓ Tap +
Add Expense
```

```text
Add Expense
  ↓ Cancel
Home
```

Cancel returns to Home without saving.

After a successful Save Expense operation:

```text
Add Expense
  ↓ Successful Save
Updated Home
```

No external routing package is approved.

Do not add:

* `go_router`
* `auto_route`
* another routing dependency

unless application complexity demonstrates a real need and the dependency is explicitly approved.

Do not introduce a larger named-route architecture merely for the current two-screen flow.

Prefer Flutter's built-in navigation capabilities for the current scope when navigation implementation is required.

## Important Unresolved Navigation Behavior

The approved UX/UI currently defines explicit Cancel and Save behavior.

It does not yet separately define:

* Device/system Back behavior from Add Expense.
* Unsaved-changes confirmation behavior.

Do not invent a special rule for these cases.

If implementation reaches this decision before documentation resolves it, report it.

---

# 14. State Management Decision

The current approved State Management strategy uses Flutter built-in capabilities.

No external State Management package is approved.

Do NOT add:

* Provider
* Riverpod
* BLoC
* Cubit
* GetX
* Redux
* MobX
* another State Management dependency

without an explicit engineering decision.

## Screen-Local State

Use Flutter local-state mechanisms such as:

```text
StatefulWidget
setState(...)
```

for state owned by one screen.

Examples include temporary Add Expense interaction state such as:

* Current form input.
* Selected date.
* Selected category.
* Temporary UI changes owned only by Add Expense.

## Feature-Shared State

State representing Expense Management as a Feature belongs under:

```text
features/expenses/state/
```

When shared Feature state becomes necessary, use a feature-scoped Flutter `ChangeNotifier` controller.

The controller may coordinate:

* Current Expense collection.
* Expense additions.
* Expense deletion.
* Undo behavior.
* Loading state.
* Success state.
* Error state.
* Future asynchronous service operations.

Do not make the controller a global catch-all application object.

---

# 15. State Ownership Rules

The current Expense collection is the client-side Feature source of truth.

The Expense List and Spending Chart must derive from the same current Expense data.

Correct concept:

```text
Current Expenses
      ↓
 ┌────┴────┐
 ↓         ↓
List      Chart
```

Do NOT maintain one independently mutable collection for the list and another independently mutable collection for the chart.

Adding, deleting, or restoring an Expense should update the authoritative Expense state first.

The dependent UI then reflects the changed state.

---

# 16. State Responsibility Boundaries

The Expense Feature controller coordinates Feature state.

It must NOT:

* Build Widgets.
* Display Snackbars.
* Hold `BuildContext`.
* Perform navigation.
* Contain screen-layout logic.
* Execute raw HTTP requests when a Feature service is responsible for networking.

The UI decides when and how UI feedback such as Snackbar presentation appears.

Navigation remains a navigation responsibility.

Networking remains a service responsibility.

---

# 17. Future State → Service Flow

The intended responsibility flow is:

```text
Screens / Widgets
        ↓
User Action
        ↓
Expense Feature Controller
        ↓
Expense Service
        ↓
Backend API
```

Then:

```text
Backend Result
      ↓
Expense Service
      ↓
Expense Feature Controller
      ↓
State Change
      ↓
UI Refresh
```

Before API integration exists, the Feature controller may coordinate temporary in-memory Expense data.

Do not create fake networking architecture simply because the real backend is not connected yet.

---

# 18. Add Expense State Flow

Conceptually:

```text
User enters form data
        ↓
Local Add Expense State
        ↓
Client Validation
        ↓
Valid Save Request
        ↓
Expense Feature Controller
        ↓
Save Operation
        ↓
Current Expense State Updated
        ↓
Home List + Chart Update
        ↓
Return to Home
```

Validation details belong to their dedicated documentation.

Do not mix form validation, navigation, Feature state, and backend networking into a single Screen method.

---

# 19. Delete & Undo

Conceptually:

```text
User swipes Expense
        ↓
Delete action reaches Feature state
        ↓
Expense removed from current state
        ↓
Home updates
        ↓
Snackbar shown by Home UI
        ↓
User presses UNDO
        ↓
Feature state restores Expense
        ↓
Home List + Chart update
```

The Snackbar is presentation.

The actual Expense deletion/restoration belongs to Expense Feature state.

---

# 20. Theming Decision

Expense Tracker supports:

* Light Theme.
* Dark Theme.

Theme behavior follows the operating-system appearance automatically.

Use:

```dart
ThemeMode.system
```

when the application root reaches theme implementation.

The application currently does NOT provide its own manual Light/Dark toggle.

Do not invent one.

Theme selection is presentation configuration.

It is not Expense Feature state.

---

# 21. Theme Ownership

Application-wide theme configuration belongs under:

```text
lib/app/theme/
```

when implementation creates a genuine need for dedicated theme files.

The root application applies Light and Dark themes to `MaterialApp`.

Expense Screens and Widgets consume the active application theme.

Prefer:

```dart
Theme.of(context)
```

and semantic Flutter theme properties instead of scattering separate Light/Dark color literals throughout Screens.

---

# 22. Visual Source of Truth

Approved UX/UI and Figma screen references are the visual source of truth.

Do not redesign the application while implementing it.

Do not invent permanent visual design tokens that are not confirmed by the approved design.

The current project documentation does NOT yet provide a complete standalone numerical Design Token sheet containing every exact:

* HEX color.
* Font family.
* Font size.
* Spacing value.
* Border radius.
* Elevation.

Therefore:

Do not guess permanent application-wide tokens merely to make the Theme implementation look complete.

When implementation reaches a visual value that should become reusable:

1. Confirm it from the approved design.
2. Centralize it if genuinely reusable.
3. Keep project documentation synchronized.

---

# 23. Typography

Shared typography should be represented through Flutter's application `TextTheme` where appropriate.

Avoid repeating equivalent `TextStyle` definitions across Screens.

No custom Font package or custom Font asset is currently approved.

Do not add one silently.

---

# 24. Component Theming

When the same visual rule genuinely repeats across the application, prefer Flutter's component theming.

Potential examples include:

* AppBar.
* Text fields.
* Buttons.
* Snackbar.
* Date Picker.
* Other Material controls.

Do not configure every possible Material component in advance.

Configure components when the approved design and implementation establish an actual repeated rule.

---

# 25. Feature-Specific Visual Values

Not every visual value belongs in the global app Theme.

For example:

* Expense category colors.
* Spending Chart category colors.
* Expense-specific visual semantics.

may remain inside the Expense Feature if they are Feature-specific.

Do not move something into global Theme merely because it is a color.

---

# 26. Usability Guardrails

Preserve the approved UX/UI behavior while implementing Flutter.

Where the approved design permits, primary interactive controls should provide a touch target of at least:

```text
48 × 48 logical pixels
```

User-facing feedback must remain readable in both Light and Dark modes.

Do not expose:

* Raw exceptions.
* Stack traces.
* SQL errors.
* Internal technical details.

to end users.

---

# 27. API Integration Rules

Screens and Widgets must never contain raw HTTP implementation.

Expense-specific API communication belongs under:

```text
features/expenses/services/
```

Shared HTTP infrastructure may belong under:

```text
core/network/
```

only when it becomes genuinely shared.

Do not create networking abstractions before API integration begins.

Do not invent:

* Backend URLs.
* Authentication schemes.
* API contracts.
* JSON field names.
* Retry strategies.

when they have not yet been approved.

---

# 28. Models

Expense-related Dart data representations belong under:

```text
features/expenses/models/
```

Create models when actual data boundaries require them.

Do not create DTO/model/domain/entity variants of the same data without a demonstrated need.

Avoid unnecessary mapping layers.

---

# 29. Dependencies

Do not add Flutter or Dart packages automatically.

Before introducing any dependency:

1. Check whether Flutter/Dart built-in functionality is sufficient.
2. Identify the real problem the dependency solves.
3. Explain why the dependency is needed.
4. Prefer mature, actively maintained packages.
5. Add it only when the current task actually requires it.

Do not add packages merely because they are popular.

Dependencies increase:

* Maintenance cost.
* Upgrade risk.
* API surface.
* Build complexity.
* Long-term project coupling.

Use built-in functionality when it reasonably solves the problem.

---

# 30. Coding Style

Write clear, idiomatic Dart.

Prefer:

* Small focused classes.
* Focused Widgets.
* Clear responsibility boundaries.
* Descriptive names.
* `const` constructors where appropriate.
* Simple control flow.
* Straightforward implementations.
* Explicit behavior over hidden magic.

Use normal Dart naming conventions:

```text
Files / folders: snake_case
Classes / enums: PascalCase
Variables / methods: camelCase
```

Avoid:

* Premature abstraction.
* Clever code that reduces readability.
* Deep inheritance hierarchies.
* Unnecessary design patterns.
* Duplicate logic.
* Dead code.
* Speculative infrastructure.
* Giant mixed-responsibility files.

Do not rewrite unrelated code while completing a task.

---

# 31. Scope Discipline

For every task:

Implement only what the task requires.

Do not use a small request as an excuse to:

* Refactor unrelated files.
* Add extra Features.
* Introduce architecture layers.
* Add dependencies.
* Rename unrelated code.
* Create speculative abstractions.
* Build future backend infrastructure.
* Implement undocumented UI.

Prefer the smallest clean diff that fully satisfies the requested task.

---

# 32. Current Flutter Implementation Stage

The current initial implementation stage is intentionally small.

Current target:

```text
mobile/lib/
├── main.dart
├── app/
│   └── app.dart
└── features/
    └── expenses/
        └── screens/
            └── home_screen.dart
```

At this stage:

* Keep `main.dart` minimal.
* Create only files required by the current implementation task.
* Do not create all future architecture folders at once.
* Do not implement State Management before the task needs it.
* Do not implement API integration before the task needs it.
* Do not add navigation architecture beyond the current scope.
* Do not build a large Theme system before real Theme responsibilities exist.

Grow the project incrementally.

---

# 33. Testing & Verification

A dedicated project Testing Strategy document exists but is not yet fully defined.

Do not invent a large testing architecture solely because a testing folder exists.

For Flutter implementation work, use appropriate basic verification.

Common checks include:

```bash
dart format .
```

```bash
flutter analyze
```

```bash
flutter test
```

Run only the checks appropriate to the change and available project state.

Fix issues caused by the current task.

Do not modify unrelated code merely to silence unrelated existing warnings.

When verification cannot be run, clearly report why.

Never claim a check passed if it was not actually executed.

---

# 34. Git Repository Rules

The Git repository root is:

```text
expense-tracker/
```

`mobile/` is not a separate repository.

Before important Git operations, inspect the current state when appropriate.

Understand the distinction:

```text
Working Directory
        ↓
Staging Area
        ↓
Local Commit History
        ↓
GitHub / Remote
```

Do not treat these as the same thing.

---

# 35. Git Staging

Do not automatically use:

```bash
git add .
```

Stage only the files intentionally included in the current logical change.

Before committing, verify that staged changes contain only task-related files.

Useful inspection commands may include:

```bash
git status
```

```bash
git diff
```

```bash
git diff --staged
```

Do not stage unrelated changes simply because Git reports them.

---

# 36. Commits

Do not create commits automatically.

Commit only when explicitly requested.

A commit should represent one logical change.

Prefer clear English commit messages such as:

```text
Add Flutter application shell
Add expense model
Implement expenses API service
Add expense state controller
Configure application themes
```

Avoid vague messages such as:

```text
update
changes
stuff
fix
final
```

---

# 37. Push & History Safety

Do not automatically push to GitHub.

Never use without explicit justification and approval:

```text
git push --force
git push --force-with-lease
git reset --hard
git clean -fd
git restore .
git checkout -- .
```

History-destructive or file-destructive commands require:

1. Inspection of current repository state.
2. Explanation of what could be lost.
3. Consideration of a safer alternative.
4. Explicit user approval when risk exists.

---

# 38. Secrets & Sensitive Configuration

Never commit:

* Passwords.
* API keys.
* Access tokens.
* Refresh tokens.
* Private keys.
* Real database credentials.
* Production secrets.
* Sensitive local configuration.

Do not embed secrets directly into Flutter source code.

If a secret has already been committed or pushed, simply deleting the line from a later commit is not sufficient to invalidate the exposed credential.

---

# 39. Agent Workflow

For every coding task:

1. Read this `AGENTS.md`.
2. Inspect the existing files relevant to the task.
3. Understand the approved architecture and current scope.
4. Identify whether the task requires a new engineering decision.
5. Keep the implementation narrow.
6. Make the smallest clean change.
7. Do not change unrelated files.
8. Run appropriate verification.
9. Review the resulting diff.
10. Report exactly what changed.

---

# 40. Agent Completion Report

After modifying the project, report:

## Files Created

List each created file.

## Files Modified

List each modified file.

## What Changed

Explain the implementation in clear terms.

## Why

Explain why the change was necessary and how it follows the approved project structure.

## Verification

Report the commands actually run and their actual results.

## Decisions / Open Questions

Report anything that still requires an explicit project decision.

Do not hide assumptions.

---

# 41. Final Engineering Principle

Expense Tracker should grow according to real implementation needs.

Do not optimize for:

* Number of files.
* Number of layers.
* Number of abstractions.
* Number of packages.
* Architectural appearance.

Optimize for:

* Correctness.
* Simplicity.
* Clear responsibility boundaries.
* Maintainability.
* Understandable code.
* Safe incremental development.

When a simple solution satisfies the approved requirements cleanly, prefer it.

```


