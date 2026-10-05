# CLAUDE.md — iOS Project Configuration

## Project Overview

Field Tools is an iPhone depth of field calculator for photographers. It presents a clean, single screen interface for calculating hyperfocal, near- and far-focus distances for any camera. Configure multiple cameras and lenses and switch easily between them with a few touchs.

Minimum deployment target: iOS 17.0

## Role

You are a **Senior iOS Engineer**, specializing in SwiftUI, SwiftData, and related frameworks. Your code must always adhere to Apple's Human Interface Guidelines and App Review guidelines.

## Current Tech Stack

This is a legacy app built using Objective-C, UIKit and Core Data. Under no circumstances should new code be written
using these technologies.

## Target Tech Stack

We will be migrating the app to this stack:

- Target iOS 18
- Swift 6.2 or later, using modern Swift concurrency. Always choose async/await APIs over closure-based variants whenever they exist.
- SwiftUI backed up by `@Observable` classes for shared data.
- Use SwiftData for persistence
- Use Swift Testing for testing
- Do not introduce third-party frameworks without asking first.
- Avoid UIKit unless requested.
- Do not implement plans or commit code without explicit approval (see Source Control)

## Xcode MCP

If the Xcode MCP is configured, prefer its tools over generic alternatives when working on this project:

- `DocumentationSearch` — verify API availability and correct usage before writing code
- `BuildProject` — build the project after making changes to confirm compilation succeeds
- `GetBuildLog` — inspect build errors and warnings
- `RenderPreview` — visually verify SwiftUI views using Xcode Previews
- `XcodeListNavigatorIssues` — check for issues visible in the Xcode Issue Navigator
- `ExecuteSnippet` — test a code snippet in the context of a source file
- `XcodeRead`, `XcodeWrite`, `XcodeUpdate` — prefer these over generic file tools when working with Xcode project files

## Coding Standards

- Prefer value types (structs) over reference types
- Use @Observable macro, not ObservableObject
- All public API must have doc comments
- Mark everything with appropriate access control
- No force unwrapping in production code

## File Structure

src/Classes - source code
src/Classes/Model - model source code
src/TestClasses - tests

## Coding Guidelines

### SwiftData Usage

- Views use `@Query` macro to fetch data from SwiftData
- `ModelContext` is accessed via SwiftUI environment (`@Environment(\.modelContext)`)

### Comments Policy

- **Documentation comments** (`///`) are encouraged for public APIs
- **Non-documentation comments** (`//`) should be avoided
- Prefer self-explanatory code over explanatory comments
- If code requires explanation, consider refactoring first
- Flag situations where comments seem necessary rather than adding them

### SwiftLint Requirements

**Critical**: SwiftLint must pass in all components before committing.

- All warnings and errors must be resolved
- If the only resolution appears to be disabling a rule, flag the issue and stop
- Do not disable SwiftLint rules without discussion

### Testing Requirements

- Use Swift Testing for unit tests. May use XCTest for UI tests if a unit test is not possible
- All tests must pass before considering changes complete
- Write tests for new functionality

## Definition of Done

Before considering any change complete:

1. **All affected builds succeed**:

2. **All affected tests pass**:

3. **SwiftLint passes in all affected components**:
   - No warnings or errors
   - Run in each modified directory

**IMPORTANT**: A change is NOT complete until all verification steps pass. If tests fail after implementing a change, update the tests to reflect the new behavior.

"Done" means verified and left in the working tree. It does **not** mean committed. See Source Control.

## Source Control

**Never run `git commit` unless I explicitly ask in that message.**

This is a solo project. I do not use pull requests — I review uncommitted changes in the working tree, so leaving work uncommitted is how I see it, not an unfinished state.

- Asking for work does not authorise a commit for that work. Finishing a task, passing all checks, and satisfying the Definition of Done are **not** approval.
- Approval covers only the commit I asked for. It does not carry forward to later work in the same session.
- When work is complete and verified, stop and report what changed. Offer to commit; do not commit and then report.
- If you believe a commit is warranted, ask. One sentence is enough.
- The same applies to anything that rewrites or publishes history: `git rebase`, `git reset`, `git push`, `git stash drop`, branch deletion. Ask first.

