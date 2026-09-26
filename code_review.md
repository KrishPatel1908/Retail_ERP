# Flutter Project — Complete Code Review, QA & Security Audit

## 1. ROLE

Act as a **Senior Flutter Engineer, Software Architect, QA Engineer, Security Reviewer, Performance Engineer, and Code Reviewer**.

Your job is to perform a **complete, honest, production-level audit of this Flutter application**.

Do not assume the existing implementation is correct.

Do not give positive feedback just to make the report sound good.

If something is poorly designed, inefficient, duplicated, unsafe, difficult to maintain, incorrectly named, unnecessarily complicated, or likely to cause bugs, explicitly identify it.

Your review must be based on the **actual code in this repository**.

---

# 2. PRIMARY OBJECTIVE

Review the entire Flutter project and determine:

1. Whether the application works correctly.
2. Whether the architecture is appropriate.
3. Whether the code is efficient.
4. Whether widgets are designed correctly.
5. Whether state management is implemented correctly.
6. Whether API/network handling is reliable.
7. Whether database/storage logic is safe.
8. Whether authentication/authorization is secure.
9. Whether navigation is reliable.
10. Whether error handling is complete.
11. Whether loading/empty/error states are handled.
12. Whether the application handles edge cases.
13. Whether UI behaves correctly on different screen sizes.
14. Whether the code follows Flutter/Dart best practices.
15. Whether naming is consistent and meaningful.
16. Whether components are reusable.
17. Whether there is unnecessary duplication.
18. Whether there are memory/performance problems.
19. Whether there are security vulnerabilities.
20. Whether the application is production-ready.
21. Whether the existing tests are sufficient.
22. What can break in real-world usage.
23. What can be exploited or abused.
24. What should be refactored before release.

---

# 3. IMPORTANT REVIEW RULES

## Rule 1 — Review the entire repository

Do not review only `lib/`.

Inspect, where applicable:

* `lib/`
* `test/`
* `integration_test/`
* `android/`
* `ios/`
* `web/`
* `macos/`
* `windows/`
* `linux/`
* `assets/`
* configuration files
* environment files
* dependency files
* build configuration
* platform-specific configuration
* generated configuration where relevant
* localization files
* CI/CD configuration
* documentation
* scripts
* database-related files
* API/service configuration

Also inspect:

* `pubspec.yaml`
* `pubspec.lock`
* `.gitignore`
* `.env*`
* `analysis_options.yaml`
* `README`
* build scripts
* configuration files
* Firebase configuration if present
* API configuration if present

Do not ignore files merely because they appear unrelated.

---

# 4. FIRST STEP — UNDERSTAND THE PROJECT

Before reviewing individual files, understand the application.

Create a high-level understanding of:

* What the application does
* Main user types
* Main features
* Main workflows
* Authentication flow
* Navigation flow
* API flow
* Database/storage flow
* State management architecture
* Major business logic
* Important dependencies
* External services
* Platform requirements

Create a project architecture map.

Example:

```text
UI
 ↓
Widgets / Screens
 ↓
State Management
 ↓
Repositories / Services
 ↓
API / Database
 ↓
External Services
```

If the actual architecture differs, document the actual architecture.

Do not assume the architecture from folder names alone.

---

# 5. FILE-BY-FILE REVIEW

Review every meaningful source file.

For each important file, analyze:

### A. Purpose

* What is this file responsible for?
* Is that responsibility appropriate?
* Is the file doing too much?
* Is the file doing too little?

### B. Naming

Check:

* File name
* Class name
* Function name
* Variable name
* Constant name
* Enum name
* Provider/controller/bloc name
* Widget name
* Model name

Determine whether names:

* Clearly communicate intent
* Follow Dart conventions
* Follow Flutter conventions
* Are consistent across the project
* Avoid abbreviations
* Avoid misleading names

Flag poor naming.

---

# 6. WIDGET REVIEW

Review every major widget.

Check:

### Widget responsibility

Determine whether the widget:

* Has one clear responsibility
* Is too large
* Contains excessive business logic
* Contains API calls directly
* Contains database logic directly
* Contains navigation logic unnecessarily
* Can be reused
* Should be split into smaller widgets

### Build method

Check for:

* Excessively large `build()` methods
* Repeated widget trees
* Expensive calculations
* API/database operations inside build
* Incorrect state handling
* Unnecessary rebuilds
* Poor conditional rendering
* Nested builders
* Excessive nesting

### Widget type

Determine whether:

* `StatelessWidget` should be used
* `StatefulWidget` is necessary
* `const` can be used
* A custom widget should be extracted

### Keys

Check whether keys are required for:

* Lists
* Reorderable widgets
* Stateful list items
* Dynamic collections
* Animated widgets

Flag missing or inappropriate keys.

---

# 7. CONST REVIEW

Search throughout the project for opportunities to use:

```dart
const
```

Check:

* Constructors
* Widgets
* Static values
* Immutable objects
* Decorations
* Text styles
* Padding
* SizedBox
* Icons
* Colors
* Lists where applicable

Identify unnecessary runtime object creation.

Report:

```text
File:
Current:
Recommended:
Reason:
Impact:
```

---

# 8. STATE MANAGEMENT REVIEW

Identify the state-management solution used.

Examples:

* Provider
* Riverpod
* Bloc
* Cubit
* GetX
* Redux
* MobX
* ValueNotifier
* ChangeNotifier
* setState
* Custom solution

Review:

* State ownership
* State lifecycle
* Dependency injection
* Rebuild behavior
* Async state
* Error state
* Loading state
* Empty state
* State persistence
* State synchronization
* Race conditions
* Duplicate state
* Global state abuse
* Local state abuse

Check for:

* State stored at the wrong level
* Unnecessary global state
* State duplicated in multiple locations
* Controllers/providers that are too large
* Incorrect disposal
* Listeners that are never removed
* Memory leaks
* Async state inconsistencies

---

# 9. ASYNC / FUTURE / STREAM REVIEW

Search for:

* `Future`
* `async`
* `await`
* `Stream`
* `FutureBuilder`
* `StreamBuilder`
* async callbacks
* timers
* subscriptions

Check:

* Missing `await`
* Incorrect async sequencing
* Race conditions
* Unhandled exceptions
* Calling `setState` after dispose
* Calling context after async gaps
* Unnecessary repeated API calls
* Duplicate requests
* Stream subscriptions not disposed
* Timers not cancelled
* Futures started repeatedly during rebuilds

Pay special attention to:

```dart
if (!mounted) return;
```

and whether it is required after asynchronous operations.

---

# 10. API / NETWORK REVIEW

Review every API call.

Check:

* Base URL management
* Environment configuration
* HTTP client configuration
* Headers
* Authentication tokens
* Token refresh
* Request timeout
* Response timeout
* Retry strategy
* Error handling
* Status code handling
* JSON parsing
* Null handling
* Serialization
* Deserialization
* Request cancellation
* Duplicate requests
* Pagination
* Caching
* Offline behavior
* Network failure handling

Check every HTTP status category:

```text
2xx
3xx
4xx
5xx
timeout
connection failure
malformed response
empty response
unexpected response
```

Do not assume only `200` matters.

---

# 11. API SECURITY REVIEW

Look for:

* API keys hardcoded in source
* Secret keys committed to repository
* Tokens logged
* Sensitive data printed
* Insecure HTTP
* Weak authentication handling
* Tokens stored insecurely
* Missing certificate/security considerations where appropriate
* Authorization assumptions made only on the client
* Sensitive request parameters exposed
* User-controlled data trusted without validation

Important:

Never assume client-side validation provides security.

Explain which validations must also happen on the backend.

---

# 12. AUTHENTICATION REVIEW

Review:

* Login
* Signup
* Logout
* Session persistence
* Token storage
* Token expiration
* Refresh token
* Password reset
* OTP
* Email verification
* Social login
* Biometric authentication if present

Test:

* Invalid credentials
* Empty credentials
* Expired token
* Revoked token
* Logout and back navigation
* Session restoration
* Multiple login attempts
* Network failure during login
* API failure after login
* App restart
* Token refresh failure

Check whether authenticated routes can accidentally be accessed after logout.

---

# 13. NAVIGATION REVIEW

Map the entire navigation tree.

Check:

* Routes
* Named routes
* GoRouter/AutoRoute/etc. if used
* Deep links
* Back navigation
* Authentication guards
* Unauthorized access
* Duplicate routes
* Nested navigation
* Dialog navigation
* Bottom navigation
* Drawer navigation
* Browser back button for web
* Android back button
* iOS navigation behavior

Test:

```text
Login
→ Home
→ Details
→ Edit
→ Save
→ Back
→ Home
```

Also test:

```text
Login
→ Home
→ Logout
→ Back
```

The user must not regain access to authenticated screens.

---

# 14. DATABASE / LOCAL STORAGE REVIEW

If the project uses:

* SQLite
* Hive
* Isar
* SharedPreferences
* Secure Storage
* Firebase
* Supabase
* local files
* custom storage

Review:

* Data models
* Schema
* Migration
* Indexing
* Serialization
* Null handling
* Corrupted data
* Cache invalidation
* Data consistency
* Transactions
* Concurrent updates
* Sensitive information storage
* Data deletion
* Logout cleanup

Check whether sensitive information is stored using appropriate secure storage.

---

# 15. BUSINESS LOGIC REVIEW

This is one of the most important parts.

Do not only review syntax.

Understand the business rules.

Look for:

* Incorrect calculations
* Wrong conditions
* Off-by-one errors
* Incorrect filtering
* Incorrect sorting
* Incorrect totals
* Incorrect status transitions
* Duplicate records
* Missing validation
* Incorrect permissions
* Invalid state transitions
* Race conditions
* Incorrect assumptions

For each important feature, identify:

```text
Input
 ↓
Validation
 ↓
Business Logic
 ↓
API/Database
 ↓
State Update
 ↓
UI
```

Verify every stage.

---

# 16. NULL SAFETY REVIEW

Search for unsafe assumptions.

Review:

```dart
!
```

and:

```dart
as
```

and:

```dart
first
last
single
```

and:

```dart
[index]
```

Check:

* Empty lists
* Missing JSON fields
* Null API responses
* Optional fields
* Missing user data
* Missing images
* Missing configuration

Flag every potentially unsafe assumption.

---

# 17. ERROR HANDLING REVIEW

Every user-facing operation should have appropriate error handling.

Check:

* API errors
* Database errors
* Parsing errors
* Permission errors
* Authentication errors
* Network errors
* File errors
* Location errors
* Camera errors
* Notification errors

Check whether errors:

* Crash the app
* Are silently ignored
* Are logged correctly
* Are shown to users appropriately
* Provide recovery actions

Avoid generic handling such as:

```dart
catch (_) {}
```

unless there is a strong reason.

---

# 18. LOADING / EMPTY / ERROR STATES

For every screen that loads data, verify all states:

```text
Initial
Loading
Success
Empty
Error
Retry
Refreshing
Partial failure
Offline
```

Do not review only the success state.

Examples:

### List screen

Test:

* 0 items
* 1 item
* 10 items
* 1000 items
* Very long item names
* Missing image
* Missing fields
* API failure
* Slow API
* Pagination failure

---

# 19. FORM VALIDATION REVIEW

Review every form.

Check:

* Required fields
* Min/max length
* Email validation
* Phone validation
* Password rules
* Numeric input
* Decimal input
* Negative numbers
* Special characters
* Whitespace
* Leading/trailing spaces
* Duplicate values
* Date validation
* Future dates
* Past dates
* Cross-field validation

Test:

```text
Empty
Whitespace
Very short
Very long
Unicode
Emoji
Special characters
SQL-like strings
HTML-like strings
Unexpected formats
```

Do not trust frontend validation for security.

---

# 20. UI / UX REVIEW

Review every screen visually and functionally.

Check:

* Alignment
* Spacing
* Typography hierarchy
* Button consistency
* Input consistency
* Card consistency
* Icon consistency
* Navigation consistency
* Loading indicators
* Error messages
* Empty states
* Dialogs
* Bottom sheets
* Snackbars
* Accessibility
* Touch targets

Check whether the UI communicates:

```text
What is happening?
What can I do?
What happened?
What should I do next?
```

---

# 21. RESPONSIVE DESIGN REVIEW

Test different screen sizes.

Minimum recommended testing:

### Phones

* Small phone
* Standard phone
* Large phone

### Tablets

* Portrait
* Landscape

### Desktop

* Small desktop
* Large desktop

### Web

* Narrow browser
* Wide browser

Check for:

* Overflow
* `RenderFlex overflowed`
* Fixed widths
* Fixed heights
* Keyboard issues
* Bottom navigation issues
* Dialog overflow
* Text overflow
* Image distortion
* Incorrect aspect ratios

---

# 22. ORIENTATION REVIEW

Test:

```text
Portrait
Landscape
Portrait → Landscape
Landscape → Portrait
```

Check whether state is preserved correctly.

---

# 23. KEYBOARD REVIEW

For every form test:

* Keyboard opening
* Keyboard closing
* Focus changes
* Next field
* Done action
* Keyboard type
* Password keyboard
* Numeric keyboard
* Scroll when keyboard opens
* Bottom button visibility
* Keyboard dismissal

Test especially on small devices.

---

# 24. ACCESSIBILITY REVIEW

Check:

* Semantic labels
* Screen reader support
* Text contrast
* Touch target sizes
* Focus order
* Dynamic text scaling
* Large accessibility fonts
* Icon-only buttons
* Images with meaningful labels
* Form labels
* Error announcements

Test large text settings.

---

# 25. PERFORMANCE REVIEW

Look for:

* Excessive rebuilds
* Heavy computation in `build()`
* Large lists without optimization
* Missing lazy builders
* Large images
* Unnecessary image decoding
* Memory-heavy objects
* Repeated API calls
* Unnecessary database queries
* Excessive animations
* Expensive `setState`
* Large widget trees
* Synchronous heavy work on UI thread

Review:

```dart
ListView
GridView
ListView.builder
GridView.builder
FutureBuilder
StreamBuilder
AnimatedBuilder
Consumer
BlocBuilder
Selector
```

depending on what the project uses.

---

# 26. LIST PERFORMANCE

For every large collection:

Check whether it uses appropriate lazy rendering.

Look for:

* `ListView(children: [...])` with huge lists
* Nested scrolling
* Nested ListViews
* `shrinkWrap: true`
* unnecessary `NeverScrollableScrollPhysics`
* excessive rebuilds
* missing pagination

Do not automatically mark `shrinkWrap` as wrong.

Determine whether it is actually necessary and what performance impact it creates.

---

# 27. IMAGE PERFORMANCE

Check:

* Image dimensions
* Image caching
* Network image handling
* Placeholder
* Error image
* Compression
* Resolution
* Memory usage

Avoid loading a huge image when displaying a tiny thumbnail.

---

# 28. MEMORY LEAK REVIEW

Search for:

* Controllers
* FocusNodes
* AnimationControllers
* ScrollControllers
* StreamSubscriptions
* Timers
* Listeners
* Observers

Verify they are disposed appropriately.

Examples:

```dart
controller.dispose();
focusNode.dispose();
subscription.cancel();
timer.cancel();
```

where applicable.

---

# 29. DEPENDENCY REVIEW

Inspect `pubspec.yaml`.

For every dependency determine:

* Why is it required?
* Is it actually used?
* Is it duplicated by another package?
* Is it outdated?
* Is there a lighter alternative?
* Does it introduce security risk?
* Does it significantly increase application size?
* Is it compatible with the current Flutter/Dart version?

Flag unnecessary packages.

Do not recommend replacing packages merely for the sake of modernization.

---

# 30. DART CODE QUALITY

Review:

* Effective Dart conventions
* Null safety
* Type safety
* `final`
* `const`
* late variables
* unnecessary casts
* unnecessary nullable types
* dead code
* unreachable code
* duplicate code
* magic numbers
* magic strings
* unnecessary comments
* misleading comments
* long functions
* long classes
* deep nesting

Check whether abstraction improves maintainability or merely adds complexity.

---

# 31. ARCHITECTURE REVIEW

Determine whether the architecture is:

* Clean
* Feature-first
* Layered
* MVC
* MVVM
* Repository pattern
* BLoC architecture
* Riverpod architecture
* Custom

Then evaluate whether it is actually implemented correctly.

Do not judge architecture only by folder names.

Check dependency direction.

For example:

```text
UI
 ↓
State
 ↓
Repository
 ↓
Data Source
```

Identify violations such as:

```text
Widget
 ↓
Direct Database
```

or:

```text
Widget
 ↓
Raw HTTP request
```

when the project architecture expects separation.

---

# 32. CODE DUPLICATION

Find duplicated:

* Widgets
* API calls
* Validation
* Formatting
* Navigation
* Error handling
* Models
* Business logic
* UI components

For each duplication determine:

```text
Keep duplicated
OR
Extract reusable function
OR
Extract widget
OR
Extract service
OR
Extract utility
```

Do not create abstractions just to remove a few repeated lines.

---

# 33. MAGIC VALUES

Find hardcoded:

* URLs
* durations
* limits
* dimensions
* API paths
* strings
* status values
* IDs
* pagination sizes
* retry counts

Determine which should become:

* constants
* configuration
* enums
* environment variables
* centralized definitions

---

# 34. SECURITY REVIEW

Perform a security-oriented audit.

Look for:

* Hardcoded secrets
* API keys
* Tokens
* Passwords
* Sensitive logs
* Insecure storage
* Insecure network communication
* Weak validation
* Client-side authorization
* Debug information exposed in production
* Excessive error details
* Sensitive data in analytics
* Sensitive data in crash logs

Check `.gitignore` and environment handling.

---

# 35. LOGGING REVIEW

Search for:

```dart
print()
debugPrint()
logger
log()
```

Determine:

* What is logged?
* Is sensitive data logged?
* Are logs appropriate for production?
* Is logging excessive?
* Are errors logged with useful context?

Passwords, tokens, secrets, and sensitive personal information must not be logged.

---

# 36. RELEASE BUILD REVIEW

Review differences between:

```text
Debug
Profile
Release
```

Check:

* Debug flags
* Test URLs
* Mock data
* Debug logging
* Development keys
* Production configuration
* Environment variables
* Analytics
* Crash reporting

Verify that release builds cannot accidentally use development configuration.

---

# 37. TESTING STRATEGY

Determine the current test coverage.

Inspect:

```text
test/
integration_test/
```

and identify missing tests.

Testing should exist at multiple levels.

---

# 38. UNIT TESTING

Write or recommend tests for:

### Business logic

* Calculations
* Validation
* Formatting
* Filtering
* Sorting
* State transitions
* Utility functions

Test:

```text
Normal input
Empty input
Null input
Boundary input
Invalid input
Large input
Unexpected input
```

---

# 39. WIDGET TESTING

Test:

* Widget rendering
* User interaction
* Buttons
* Forms
* Validation
* Navigation
* Loading states
* Error states
* Empty states
* Dialogs
* Bottom sheets
* Conditional UI

Example flow:

```text
Find widget
→ Tap button
→ Enter value
→ Submit
→ Verify result
```

---

# 40. INTEGRATION TESTING

Test complete user journeys.

Examples:

### Authentication

```text
Open app
→ Login
→ Invalid credentials
→ Error shown
→ Correct credentials
→ Home
→ Logout
```

### CRUD

```text
Create
→ Read
→ Update
→ Delete
→ Verify
```

### Search

```text
Open search
→ Enter query
→ Results
→ No results
→ Clear query
→ Results restored
```

### Network

```text
Online
→ API request
→ Success

Offline
→ API request
→ Error
→ Retry
→ Online
→ Success
```

---

# 41. END-TO-END TESTING

Simulate real users.

Create complete journeys for every major feature.

For each feature identify:

```text
Happy path
Alternative path
Failure path
Edge path
Recovery path
```

---

# 42. CHAOS / FAILURE TESTING

Intentionally make things fail.

Test:

* No internet
* Slow internet
* Intermittent internet
* API timeout
* API 400
* API 401
* API 403
* API 404
* API 409
* API 422
* API 429
* API 500
* API 502
* API malformed response

Check whether the application:

* Crashes
* Hangs
* Shows infinite loader
* Shows useful error
* Allows retry
* Recovers correctly

---

# 43. RAPID USER BEHAVIOR TESTING

Do not only test careful users.

Test users who:

* Tap buttons repeatedly
* Tap very quickly
* Navigate back immediately
* Submit forms multiple times
* Rotate the screen during requests
* Close dialogs unexpectedly
* Open and close screens repeatedly
* Switch tabs rapidly
* Scroll extremely quickly
* Press back repeatedly

Look for race conditions and duplicate actions.

---

# 44. EDGE CASE TEST MATRIX

Test every important feature against:

| Category      | Examples                |
| ------------- | ----------------------- |
| Empty         | Empty list, empty field |
| Null          | Missing value           |
| Minimum       | 0, 1                    |
| Maximum       | Maximum supported value |
| Huge          | Very large input        |
| Unicode       | ગુજરાતી, 中文, العربية    |
| Emoji         | 😀🔥                    |
| Special chars | `@#$%^&*`               |
| Whitespace    | `"   "`                 |
| Duplicate     | Same item twice         |
| Network       | Offline                 |
| Timeout       | Very slow API           |
| Permission    | Permission denied       |
| Session       | Expired login           |
| Device        | Small screen            |
| Orientation   | Landscape               |
| Accessibility | Large text              |
| Repetition    | Rapid taps              |

---

# 45. DATE AND TIME TESTING

If dates/times exist, test:

* Different time zones
* Midnight
* End of month
* Beginning of month
* Leap years
* Leap day
* Daylight-saving environments where relevant
* Future dates
* Past dates
* Same-day dates
* Invalid dates
* Date formatting
* Server vs local timezone

Never assume local device time equals server time.

---

# 46. PAGINATION REVIEW

If pagination exists, test:

```text
0 results
1 page
Exactly 1 page
Multiple pages
Last page
Empty last page
Repeated request
Fast scrolling
Slow scrolling
Network failure during pagination
Refresh during pagination
```

Check duplicate records.

---

# 47. SEARCH REVIEW

Test:

```text
Empty search
1 character
Normal query
Uppercase
Lowercase
Spaces
Leading spaces
Trailing spaces
Special characters
Unicode
Very long query
No results
Many results
Rapid typing
Clear search
Network failure
```

Check debounce implementation if appropriate.

---

# 48. CRUD REVIEW

For every CRUD feature:

### Create

* Valid input
* Invalid input
* Duplicate
* Network failure
* Double submission

### Read

* Empty
* Large dataset
* Missing record
* Permission denied

### Update

* Valid update
* Invalid update
* Concurrent update
* Cancel update

### Delete

* Cancel
* Confirm
* Repeated delete
* Already deleted item
* Network failure

---

# 49. FILE / MEDIA FEATURES

If the app supports:

* Camera
* Gallery
* File picker
* Upload
* Download

Test:

* Permission denied
* Permission permanently denied
* Cancel
* Invalid file
* Huge file
* Unsupported format
* Corrupted file
* Network interruption
* Duplicate upload
* Upload retry

---

# 50. NOTIFICATION REVIEW

If notifications exist, test:

* Permission denied
* Permission granted
* Notification received
* App foreground
* App background
* App terminated
* Notification tap
* Deep link
* Invalid notification payload

---

# 51. OFFLINE / ONLINE REVIEW

Test:

```text
Start online
→ Use feature
→ Go offline
→ Use feature
→ Recover network
→ Retry
```

Determine whether the application should:

* Fail gracefully
* Cache data
* Queue operations
* Retry
* Show offline status

Document current behavior and recommended behavior.

---

# 52. APP LIFECYCLE REVIEW

Test:

```text
Launch
→ Background
→ Resume
```

Also:

```text
Launch
→ Kill app
→ Relaunch
```

and:

```text
Open screen
→ Background app
→ Resume
```

Check:

* State restoration
* API calls
* authentication
* controllers
* timers
* streams
* navigation state

---

# 53. DEEP LINK REVIEW

If supported, test:

```text
App closed
→ Open deep link
```

```text
App background
→ Open deep link
```

```text
App already open
→ Open deep link
```

Test invalid and unauthorized deep links.

---

# 54. INTERNATIONALIZATION

If multiple languages exist, test:

* Long translated strings
* Short strings
* RTL languages
* Date formats
* Number formats
* Currency
* Missing translations
* Dynamic text

Look for hardcoded user-facing strings.

---

# 55. CODE SMELLS

Identify:

* God classes
* God widgets
* Long methods
* Long parameter lists
* Deep nesting
* Duplicate code
* Boolean parameter abuse
* Excessive inheritance
* Tight coupling
* Global state abuse
* Circular dependencies
* Dead code
* Commented-out code
* Temporary hacks
* TODO/FIXME issues
* Magic values
* Poor abstractions

---

# 56. NAMING AUDIT

Create a dedicated naming audit.

Review:

```text
Files
Classes
Widgets
Methods
Variables
Constants
Enums
Providers
Controllers
Repositories
Services
Models
DTOs
Extensions
```

For every questionable name explain:

```text
Current name:
Problem:
Suggested name:
Reason:
```

Do not rename something simply because another name sounds nicer.

Rename only when it improves clarity or consistency.

---

# 57. FOLDER STRUCTURE REVIEW

Evaluate whether the folder structure is scalable.

Check for:

* Feature separation
* Shared components
* Core utilities
* Services
* Models
* Repositories
* State
* Screens
* Widgets

Identify files placed in inappropriate folders.

Recommend a structure only if the current structure causes maintainability problems.

---

# 58. DEPENDENCY DIRECTION

Check for architectural dependency violations.

Examples:

```text
Presentation → Data
```

may be acceptable depending on architecture.

But identify problematic coupling such as:

```text
Widget → Database implementation
Widget → HTTP implementation
Widget → Secret/configuration
```

when those responsibilities should be abstracted.

---

# 59. DATABASE/API MODEL REVIEW

Review models for:

* Naming
* Serialization
* Nullability
* Default values
* Equality
* Copy methods
* JSON conversion
* API compatibility
* Backward compatibility

Check whether API models and UI/domain models should be separated.

---

# 60. ERROR MESSAGE REVIEW

Review all user-facing errors.

Bad:

```text
Something went wrong
```

when more useful information can safely be provided.

But do not expose internal implementation details.

Good errors should tell the user:

```text
What happened
+
What they can do next
```

---

# 61. UX FAILURE RECOVERY

For every error, determine whether the user can recover.

Examples:

```text
API failed
→ Retry

Validation failed
→ Fix field

Session expired
→ Login again

Permission denied
→ Explain permission

Upload failed
→ Retry upload
```

---

# 62. PERFORMANCE MEASUREMENT

Do not make performance claims without evidence where possible.

Recommend using:

* Flutter DevTools
* Performance Overlay
* Memory profiler
* CPU profiler
* Network inspection
* Widget rebuild tracking

Identify areas that should be measured rather than merely guessed.

---

# 63. STATIC ANALYSIS

Run or recommend:

```bash
flutter analyze
```

and inspect all warnings/errors.

Also check formatting:

```bash
dart format .
```

Run:

```bash
flutter test
```

if tests exist.

If integration tests exist:

```bash
flutter test integration_test
```

Do not claim these commands passed unless you actually executed them.

---

# 64. BUILD VERIFICATION

Where possible verify:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk
flutter build appbundle
```

For web:

```bash
flutter build web
```

For iOS/macOS, verify according to the available development environment.

If a command cannot be executed, explicitly say so.

---

# 65. TEST ON REAL DEVICES

Recommend testing at least:

### Android

* Low-end device
* Mid-range device
* Modern device

### iOS

* Small screen
* Standard screen
* Large screen

Also test:

* Different OS versions
* Different screen densities
* Different network conditions

---

# 66. SECURITY ABUSE CASES

Try to determine whether users can:

* Access another user's data
* Modify unauthorized records
* Delete unauthorized records
* Bypass frontend validation
* Access authenticated screens after logout
* Manipulate IDs
* Replay requests
* Submit duplicate requests
* Upload malicious/unsupported files
* Access hidden UI through direct routes

Clearly distinguish:

```text
Client-side issue
Backend issue
Both
```

---

# 67. LOOPHOLE HUNT

Explicitly search for loopholes.

Ask:

> "How could a malicious, careless, impatient, offline, or unusual user break this feature?"

For every major feature, attempt:

```text
Skip step
Repeat step
Reverse step
Cancel step
Submit twice
Change input midway
Go back midway
Close app midway
Lose network midway
Lose authentication midway
Open direct route
Use invalid ID
Use deleted ID
Use another user's ID
```

Document every weakness.

---

# 68. DATA CONSISTENCY

Check whether UI, local storage, and backend can become inconsistent.

Example:

```text
UI says success
but
API failed
```

or:

```text
Local database updated
but
server update failed
```

or:

```text
Server updated
but
UI still shows old data
```

Identify synchronization problems.

---

# 69. RACE CONDITIONS

Look specifically for:

```text
Request A starts
Request B starts
Request B finishes
Request A finishes
```

Could stale Request A overwrite newer data?

Check:

* Search
* Pagination
* Refresh
* CRUD
* Authentication
* Token refresh
* Uploads
* Auto-save

---

# 70. DUPLICATE ACTIONS

Test:

```text
Tap Submit twice
Tap Delete twice
Tap Save rapidly
Refresh repeatedly
Open same screen repeatedly
```

Determine whether duplicate requests/actions can occur.

---

# 71. STATE AFTER NAVIGATION

For every screen:

```text
Open
→ Change data
→ Navigate away
→ Return
```

Check whether:

* State is preserved correctly
* State is unexpectedly reset
* Stale data is displayed
* API unnecessarily runs again

---

# 72. PRODUCTION READINESS CHECK

Give a final verdict:

### Production Ready

or

### Production Ready With Minor Fixes

or

### Needs Important Fixes

or

### Not Production Ready

Explain why.

---

# 73. SEVERITY CLASSIFICATION

Every issue must receive a severity.

Use:

### 🔴 CRITICAL

Application crash, data loss, security vulnerability, unauthorized access, severe production blocker.

### 🟠 HIGH

Major feature broken, serious business logic issue, severe performance issue, significant security problem.

### 🟡 MEDIUM

Important bug, maintainability issue, inconsistent behavior, moderate UX issue.

### 🟢 LOW

Minor cleanup, naming issue, small optimization, style issue.

---

# 74. ISSUE FORMAT

Every issue should follow this format:

```text
[SEVERITY] Issue Title

File:
Class/Function:
Line:
Category:

Problem:
Explain exactly what is wrong.

Why it matters:
Explain the real-world consequence.

How to reproduce:
Step-by-step reproduction.

Recommended fix:
Explain the correct approach.

Priority:
Critical / High / Medium / Low
```

Do not report vague issues.

---

# 75. POSITIVE FINDINGS

Do include things that are genuinely well implemented.

Examples:

* Good architecture
* Good state management
* Strong validation
* Good reusable widgets
* Good error handling
* Good performance practices
* Good security practices

But do not inflate positive feedback.

The goal is an **honest engineering review**, not praise.

---

# 76. FINAL REPORT STRUCTURE

At the end, produce the following report:

# Flutter Project Audit

## 1. Executive Summary

Give a concise overall assessment.

---

## 2. Project Architecture

Explain:

* Current architecture
* Strengths
* Weaknesses
* Recommended architecture changes

---

## 3. Overall Score

Score each category from 1–10:

| Category             | Score |
| -------------------- | ----: |
| Architecture         |   /10 |
| Code Quality         |   /10 |
| Flutter Practices    |   /10 |
| State Management     |   /10 |
| UI/UX                |   /10 |
| Performance          |   /10 |
| Security             |   /10 |
| Error Handling       |   /10 |
| Testing              |   /10 |
| Maintainability      |   /10 |
| Scalability          |   /10 |
| Production Readiness |   /10 |

Explain every score.

---

## 4. Critical Issues

List all 🔴 issues first.

---

## 5. High Priority Issues

List all 🟠 issues.

---

## 6. Medium Priority Issues

List all 🟡 issues.

---

## 7. Low Priority Issues

List all 🟢 issues.

---

## 8. File-by-File Findings

Provide important findings grouped by file.

---

## 9. Naming Audit

List questionable names and recommendations.

---

## 10. Widget Audit

Identify:

* Large widgets
* Reusable widgets
* Unnecessary widgets
* Bad widget responsibilities
* Rebuild problems

---

## 11. State Management Audit

Explain:

* State ownership
* Rebuilds
* lifecycle
* async state
* potential leaks

---

## 12. API Audit

Explain:

* API architecture
* Error handling
* Authentication
* Network failures
* Security
* Retry/caching

---

## 13. Database / Storage Audit

Explain:

* Data consistency
* Storage safety
* Schema
* Caching
* Sensitive data

---

## 14. Security Audit

List every security concern.

---

## 15. Performance Audit

List:

* Rebuild problems
* Memory problems
* Network inefficiencies
* Database inefficiencies
* Image problems
* List problems

---

## 16. Testing Audit

Show:

```text
Existing tests
Missing tests
Recommended tests
```

---

## 17. Complete Test Plan

Create a test matrix:

| Feature | Test                | Expected Result  | Status |
| ------- | ------------------- | ---------------- | ------ |
| Login   | Valid credentials   | Login succeeds   |        |
| Login   | Invalid credentials | Error shown      |        |
| Login   | Empty fields        | Validation shown |        |
| ...     | ...                 | ...              |        |

Include as many meaningful test cases as necessary.

---

# 77. TESTING DIRECTIONS

Do not test only the happy path.

Every feature should be tested from these directions:

```text
1. Normal user
2. New user
3. Returning user
4. Invalid input
5. Empty input
6. Extreme input
7. Slow user
8. Fast/impatient user
9. Offline user
10. Unauthenticated user
11. Expired-session user
12. Unauthorized user
13. Duplicate action
14. Back-navigation
15. App restart
16. App background/resume
17. Screen rotation
18. Small screen
19. Large screen
20. Accessibility mode
21. API failure
22. Database failure
23. Permission denial
24. Malformed data
25. Unexpected server response
26. Concurrent requests
27. Direct/deep navigation
28. Data consistency
29. Security abuse
30. Recovery after failure
```

---

# 78. DO NOT MAKE THESE REVIEW MISTAKES

Do NOT:

* Assume code works because it compiles.
* Assume UI is correct because it looks correct.
* Assume backend validation exists.
* Assume API always returns valid data.
* Assume network is reliable.
* Assume users behave correctly.
* Assume lists are small.
* Assume fields are never null.
* Assume users never press buttons twice.
* Assume navigation always follows the intended path.
* Recommend unnecessary architecture rewrites.
* Create abstractions without justification.
* Mark every `setState()` as bad.
* Mark every `shrinkWrap: true` as bad.
* Mark every non-const widget as a bug.
* Mark every duplicated line as requiring abstraction.
* Claim tests passed unless actually executed.
* Claim security without examining implementation.

---

# 79. HONESTY REQUIREMENT

When uncertain, explicitly state:

```text
Cannot verify from static code alone.
```

or:

```text
Requires runtime/device testing.
```

or:

```text
Requires backend verification.
```

Separate:

```text
Confirmed issue
Likely issue
Potential issue
Needs runtime verification
```

Do not present assumptions as facts.

---

# 80. FINAL PRIORITY PLAN

Finish the report with:

## Fix Immediately

List the most dangerous issues.

## Fix Before Production

List important reliability/security/performance issues.

## Fix Soon

List maintainability and UX improvements.

## Optional Improvements

List nice-to-have improvements.

---

# 81. FINAL ENGINEERING VERDICT

Answer these questions directly:

1. Would you approve this code for production?
2. What are the biggest risks?
3. What are the biggest architectural problems?
4. What are the biggest performance problems?
5. What are the biggest security concerns?
6. What features are most likely to break?
7. What tests are currently missing?
8. What should be fixed first?
9. What should NOT be changed because it is already good?
10. What is the minimum work required before production release?

End with:

```text
FINAL VERDICT:
[Production Ready / Needs Fixes / Not Production Ready]

Confidence:
High / Medium / Low

Reason:
...
```

---

# 82. IMPORTANT — DO NOT MODIFY CODE DURING THE FIRST AUDIT

During the first review:

**DO NOT automatically modify project files.**

First produce the audit.

The audit must be read and approved before making refactoring changes.

If fixes are requested later, make them in a separate phase.

---

# 83. SECOND-PHASE FIXING

After the audit is approved, fixes should be performed in this order:

```text
1. Critical security issues
2. Data-loss issues
3. Crash issues
4. Authentication/authorization issues
5. Business logic bugs
6. Data consistency issues
7. Major performance issues
8. API/network reliability
9. State management issues
10. UI/UX bugs
11. Code duplication
12. Naming
13. Minor cleanup
```

After each major fix:

```text
flutter analyze
flutter test
```

and relevant integration/build tests should be rerun.

---

# 84. GOLDEN RULE

The purpose of this review is not to say:

> "The project looks good."

The purpose is to discover:

> **"What can go wrong, why can it go wrong, how can we reproduce it, how serious is it, and how should we fix it?"**

Think like:

```text
Senior Flutter Engineer
+
QA Engineer
+
Security Engineer
+
Performance Engineer
+
Real User
+
Malicious User
```

Review the application from all six perspectives.

Be specific.

Be critical.

Be practical.

Be honest.

Do not hide problems.
