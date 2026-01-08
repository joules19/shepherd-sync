# Claude Instructions for Shepherd Sync Mobile (Flutter)

**Last Updated:** 2026-01-08
**Project:** Shepherd Sync - Mobile Frontend (Flutter)

---

## 📱 Project Overview

**Shepherd Sync Mobile** is a premium Flutter application for church management. This is the member-facing mobile app that complements the NestJS backend API.

**Key Principles:**
- **Beautiful, Top-Class Design** - Think Apple-quality UI/UX
- **Production-Ready** - Code quality matching enterprise SaaS standards
- **Offline-First** - Especially for ushers doing attendance
- **Role-Based UI** - Different experiences for Admin, Pastor, Usher, Member, Parent
- **Performance** - Smooth 60fps animations, optimized images, fast load times

---

## 🎨 Design Philosophy

### Visual Excellence
- **Modern Material Design 3** with custom church-themed color schemes
- **Smooth animations** - Hero transitions, fade-ins, shimmer loading states
- **Glassmorphism** for cards and overlays where appropriate
- **Custom illustrations** for empty states and onboarding
- **Beautiful typography** - SF Pro / Roboto with proper hierarchy
- **Consistent spacing** - 8px grid system throughout

### User Experience
- **Intuitive navigation** - Bottom nav for primary actions, drawer for settings
- **Contextual actions** - FABs, swipe gestures, pull-to-refresh
- **Helpful micro-interactions** - Button states, haptic feedback, success animations
- **Clear feedback** - Loading states, error handling, success confirmations
- **Accessibility** - Screen reader support, high contrast mode, scalable fonts

---

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/
│   ├── constants/          # App-wide constants (colors, strings, routes)
│   ├── theme/              # Theme data (light/dark modes)
│   ├── utils/              # Helpers (date formatters, validators)
│   ├── errors/             # Error handling
│   └── network/            # API client, interceptors
├── features/
│   ├── auth/
│   │   ├── data/           # API clients, models, repositories
│   │   ├── domain/         # Entities, use cases
│   │   └── presentation/   # Screens, widgets, state management
│   ├── events/
│   ├── giving/
│   ├── attendance/
│   ├── media/
│   ├── profile/
│   └── dashboard/
└── main.dart
```

### State Management: **Riverpod 2.x**
- **Why:** Type-safe, compile-time safety, testable, no BuildContext
- **Providers:** StateNotifierProvider for complex state, FutureProvider for API calls
- **Freezed:** For immutable state classes

### Networking: **Dio + Retrofit**
- **Dio:** HTTP client with interceptors for auth, logging, error handling
- **Retrofit:** Type-safe API client generation
- **JWT:** Stored in FlutterSecureStorage, auto-refresh logic

### Local Storage:
- **Hive:** Fast key-value storage for user preferences, offline cache
- **SQLite (Drift):** For complex offline data (attendance records for ushers)
- **FlutterSecureStorage:** For tokens and sensitive data

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.x        # State management
  freezed_annotation: ^2.x      # Immutable models
  json_annotation: ^4.x         # JSON serialization
  dio: ^5.x                     # HTTP client
  retrofit: ^4.x                # API client generator
  hive: ^2.x                    # Local storage
  hive_flutter: ^1.x
  drift: ^2.x                   # SQLite ORM for offline
  flutter_secure_storage: ^9.x  # Secure token storage
  go_router: ^13.x              # Navigation
  cached_network_image: ^3.x    # Image caching
  shimmer: ^3.x                 # Loading states
  flutter_svg: ^2.x             # SVG support
  qr_flutter: ^4.x              # QR code generation
  mobile_scanner: ^4.x          # QR code scanning
  image_picker: ^1.x            # Camera/gallery access
  permission_handler: ^11.x     # Permissions
  intl: ^0.19.x                 # Internationalization
  connectivity_plus: ^5.x       # Network status
  share_plus: ^7.x              # Sharing functionality
  url_launcher: ^6.x            # External links
  flutter_local_notifications: ^17.x  # Push notifications
  firebase_messaging: ^14.x     # FCM

dev_dependencies:
  flutter_test:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  retrofit_generator: ^8.x
  hive_generator: ^2.x
  drift_dev: ^2.x
  flutter_launcher_icons: ^0.13.x
  flutter_native_splash: ^2.x
```

---

## 🎯 Feature Modules (Priority Order)

### Phase 1: Authentication & Core (Week 1)
1. **Auth Module**
   - Splash screen with animated logo
   - Onboarding screens (3-4 beautiful slides)
   - Login screen (email/password + Google/Apple)
   - Registration flow
   - Forgot password
   - JWT token management with auto-refresh

2. **Dashboard Module**
   - Role-based dashboard cards
   - Quick actions (Give, Events, Attendance)
   - Statistics widgets
   - Announcements carousel

### Phase 2: Primary Features (Week 2-3)
3. **Events Module**
   - Event listing (grid/list view toggle)
   - Event details with hero image
   - Registration flow
   - QR ticket display
   - Calendar integration
   - Payment integration (Stripe)

4. **Giving Module**
   - Beautiful giving form with category selection
   - Stripe payment integration
   - Payment method management
   - Transaction history
   - Receipts (download/share PDF)
   - Recurring donations setup

5. **Attendance Module** (Usher-focused)
   - QR code scanner with camera view
   - Manual check-in search
   - Offline queue with sync indicator
   - Attendance statistics
   - Service type selection

### Phase 3: Engagement (Week 4)
6. **Media Gallery Module**
   - Grid gallery with lazy loading
   - Lightbox viewer with gestures
   - Video player integration
   - Category filtering
   - Download/share functionality
   - Role-based upload (Admin/Pastor only)

7. **Profile & Settings**
   - Profile editing
   - Children management (Parents)
   - Notification preferences
   - Theme toggle (dark/light)
   - Language selection
   - Logout with confirmation

8. **Communications Module**
   - Announcements feed
   - Push notification handling
   - In-app notification center
   - Read/unread states

---

## 🎨 UI/UX Guidelines

### Color Palette (Customizable per Church)
```dart
// Primary Theme (Default - Church Purple/Gold)
const primaryColor = Color(0xFF713784);      // Deep purple
const secondaryColor = Color(0xFFFFD700);    // Gold accent
const backgroundColor = Color(0xFFF8F9FA);   // Light gray
const surfaceColor = Color(0xFFFFFFFF);      // White
const errorColor = Color(0xFFDC3545);        // Red

// Dark Mode
const darkBackground = Color(0xFF121212);
const darkSurface = Color(0xFF1E1E1E);
```

### Typography
```dart
// Headings
headline1: 32px, Bold, Letter spacing -0.5
headline2: 24px, SemiBold
headline3: 20px, SemiBold

// Body
bodyLarge: 16px, Regular, Line height 1.5
bodyMedium: 14px, Regular
caption: 12px, Regular, Opacity 0.6
```

### Component Standards
- **Cards:** Rounded corners (16px), subtle shadow, padding 16px
- **Buttons:**
  - Primary: Filled with gradient, rounded 12px, height 48px
  - Secondary: Outlined, rounded 12px
  - Text: No background, just text with ripple
- **Input Fields:** Outlined style, rounded 12px, floating labels
- **Bottom Sheets:** Rounded top corners (20px), drag handle
- **Dialogs:** Rounded 20px, max width 90% screen

### Animations
- **Page transitions:** Slide + fade (300ms)
- **Hero animations:** For images (event cards → detail page)
- **Shimmer loading:** For skeleton screens
- **Success animations:** Lottie checkmark (1s)
- **Pull to refresh:** Custom church-themed indicator

---

## 🔐 Security Best Practices

1. **Token Management**
   - Store JWT in FlutterSecureStorage (never SharedPreferences)
   - Auto-refresh tokens before expiry
   - Clear tokens on logout

2. **API Security**
   - SSL pinning for production
   - Certificate validation
   - Timeout configurations (connect: 30s, receive: 60s)

3. **Data Protection**
   - Encrypt offline database (Drift with encryption)
   - Biometric authentication option
   - Session timeout after 30 minutes inactive

---

## 📝 Code Style & Patterns

### Naming Conventions
- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/Functions:** `camelCase`
- **Constants:** `SCREAMING_SNAKE_CASE` or `kCamelCase`
- **Private members:** `_leadingUnderscore`

### Widget Structure
```dart
class EventCard extends ConsumerWidget {
  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  final Event event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build widget tree
  }
}
```

### State Management Pattern (Riverpod)
```dart
// State class (with Freezed)
@freezed
class EventsState with _$EventsState {
  const factory EventsState({
    @Default([]) List<Event> events,
    @Default(false) bool isLoading,
    String? error,
  }) = _EventsState;
}

// Notifier
class EventsNotifier extends StateNotifier<EventsState> {
  EventsNotifier(this._repository) : super(const EventsState());

  final EventsRepository _repository;

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getEvents();

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error.message),
      (events) => state = state.copyWith(isLoading: false, events: events),
    );
  }
}

// Provider
final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  return EventsNotifier(ref.watch(eventsRepositoryProvider));
});
```

### Error Handling
```dart
// Use Either<Failure, Success> pattern
typedef ApiResult<T> = Either<Failure, T>;

class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);
}

// Repository methods
Future<ApiResult<List<Event>>> getEvents() async {
  try {
    final response = await _apiClient.getEvents();
    return Right(response.data);
  } on DioException catch (e) {
    return Left(Failure(_handleDioError(e), e.response?.statusCode));
  }
}
```

---

## 🧪 Testing Strategy

### Unit Tests
- All business logic (use cases, repositories)
- Utility functions
- State notifiers

### Widget Tests
- All custom widgets
- Screen layouts
- User interactions

### Integration Tests
- Full user flows (login → dashboard → event registration)
- Offline sync scenarios
- Payment flows

### Coverage Target: **80%+**

---

## 🚀 Performance Optimization

1. **Images**
   - Use `CachedNetworkImage` for all network images
   - Implement proper placeholder and error widgets
   - Use `fadeInDuration` for smooth loading

2. **Lists**
   - Use `ListView.builder` for long lists
   - Implement pagination (load more on scroll)
   - Cache list items with `AutomaticKeepAliveClientMixin` when appropriate

3. **State**
   - Use `const` constructors everywhere possible
   - Avoid unnecessary rebuilds with `select()` in Riverpod
   - Implement proper `==` and `hashCode` (Freezed handles this)

4. **Build**
   - Enable code obfuscation for release
   - Split debug symbols
   - Use `--split-per-abi` for smaller APKs

---

## 📱 Platform-Specific Considerations

### iOS
- Handle safe areas properly
- Use Cupertino widgets where appropriate
- Implement haptic feedback
- Configure Info.plist permissions

### Android
- Handle back button navigation
- Implement Material Design 3
- Configure AndroidManifest permissions
- Support Android 12+ splash screen API

---

## 🔄 Offline Support Strategy

### For Ushers (Critical)
1. **Attendance Records**
   - Queue check-ins locally when offline
   - Show sync status indicator
   - Auto-sync when connection restored
   - Conflict resolution (server wins)

2. **Member Data**
   - Cache member list for search
   - Update cache periodically (daily)
   - Show "last updated" timestamp

### For All Users
- Cache dashboard data (refresh on pull)
- Cache event listings
- Cache user profile
- Show offline banner when disconnected

---

## 🎯 Definition of Done

A feature is complete when:
- ✅ All screens implemented with pixel-perfect design
- ✅ Smooth animations and transitions
- ✅ Loading and error states handled
- ✅ Unit tests written (80%+ coverage)
- ✅ Widget tests for key interactions
- ✅ Offline scenarios tested (where applicable)
- ✅ Dark mode support verified
- ✅ Accessibility (screen reader) tested
- ✅ Code reviewed and approved
- ✅ No linting warnings
- ✅ Performance profiled (no jank)

---

## 🐛 Common Pitfalls to Avoid

1. **Don't** use `setState` in StatefulWidgets - use Riverpod
2. **Don't** put business logic in widgets - use use cases
3. **Don't** make API calls directly in widgets - use repositories
4. **Don't** hardcode strings - use localization
5. **Don't** ignore loading and error states
6. **Don't** skip const constructors
7. **Don't** nest widgets too deeply - extract to separate widgets
8. **Don't** commit API keys - use `.env` files

---

## 📚 Resources

- **Design Inspiration:** Dribbble, Mobbin, Flutter Showcase
- **Backend API Docs:** `/Users/user/Documents/shepherd-sync/README.md`
- **API Swagger:** `http://localhost:3000/api` (when backend running)
- **Product Docs:** `/Users/user/Documents/shepherd-sync/docs/Shepherd_Sync_README.md`

---

## 🔌 API Integration Reference

**CRITICAL:** When implementing mobile API integration, ALWAYS reference the actual backend code to avoid mistakes. Here's where to find each module:

### Backend Code Locations

```
/Users/user/Documents/shepherd-sync/backend/src/modules/
```

### Authentication & Users
- **Location:** `backend/src/modules/users/`
- **Controller:** `users.controller.ts` - Check exact endpoint paths, method signatures
- **Service:** `users.service.ts` - See business logic and return types
- **DTOs:** `dto/` folder - Use these for request/response models
- **Key Endpoints:**
  - `POST /auth/login` → Returns JWT token + user object
  - `POST /auth/register` → User registration
  - `POST /auth/forgot-password` → Send reset email
  - `POST /auth/reset-password` → Reset with token
  - `GET /users/me` → Get current user profile
  - `PATCH /users/me` → Update profile

### Organizations
- **Location:** `backend/src/modules/organizations/`
- **Controller:** `organizations.controller.ts`
- **Service:** `organizations.service.ts`
- **Key Endpoints:**
  - `GET /organizations/:id` → Get organization details
  - `PATCH /organizations/:id` → Update settings
  - `GET /organizations/:id/stats` → Dashboard statistics

### Members
- **Location:** `backend/src/modules/members/`
- **Controller:** `members.controller.ts`
- **Service:** `members.service.ts`
- **Key Endpoints:**
  - `GET /members` → List members (with pagination & filters)
  - `POST /members` → Create member
  - `GET /members/:id` → Get member details
  - `PATCH /members/:id` → Update member
  - `DELETE /members/:id` → Soft delete member
  - `POST /members/import` → Bulk import
  - `GET /members/export` → CSV export
  - `GET /members/stats` → Statistics

### Events
- **Location:** `backend/src/modules/events/`
- **Controller:** `events.controller.ts`
- **Service:** `events.service.ts`
- **DTOs:** `dto/create-event.dto.ts`, `dto/register-event.dto.ts`
- **Key Endpoints:**
  - `GET /events` → List events (with filters)
  - `POST /events` → Create event
  - `GET /events/:id` → Event details
  - `GET /events/:id/qr-code` → Get QR code for event
  - `POST /events/:id/register` → Register for event (payment optional!)
  - `DELETE /events/:id/register` → Cancel registration
  - `GET /events/stats` → Event statistics

### Giving/Donations
- **Location:** `backend/src/modules/giving/`
- **Controller:** `donations.controller.ts`
- **Service:** `donations.service.ts`
- **Stripe Service:** `stripe.service.ts` - Payment integration details
- **Key Endpoints:**
  - `POST /donations` → One-time donation
  - `POST /donations/recurring` → Setup recurring donation
  - `GET /donations` → Donation history
  - `GET /donations/my-donations` → Current user's donations
  - `GET /donations/stats` → Giving reports
  - `DELETE /donations/:id/recurring` → Cancel recurring
  - `POST /donations/webhook` → Stripe webhooks (internal)

### Attendance (Coming Soon)
- **Location:** `backend/src/modules/attendance/` (to be created)
- **Key Features:** QR check-in, manual check-in, offline sync

---

## 🎯 Integration Workflow

### Step 1: Read Backend Code First
```bash
# Example: Implementing Events Registration

1. Open: backend/src/modules/events/dto/register-event.dto.ts
   → See exact fields: childId, guestName, guestEmail, stripePaymentMethodId

2. Open: backend/src/modules/events/events.controller.ts
   → Find: @Post(':id/register')
   → Check: Decorators, guards, response type

3. Open: backend/src/modules/events/events.service.ts
   → Read: register() method
   → Note: Payment is OPTIONAL (church-friendly!)
   → See: Validation rules, error cases
```

### Step 2: Create Mobile Models
```dart
// Based on backend DTO
class RegisterEventRequest {
  final String? childId;
  final String? guestName;
  final String? guestEmail;
  final String? guestPhone;
  final String? stripePaymentMethodId;  // Optional!

  // Match backend exactly
}
```

### Step 3: Implement API Client
```dart
// Reference backend controller path
@Post('/events/{id}/register')
Future<EventRegistration> registerForEvent(
  @Path('id') String eventId,
  @Body() RegisterEventRequest request,
);
```

### Step 4: Handle Responses
```dart
// Check backend service return type
// events.service.ts line 468-498 returns EventRegistration with relations
```

---

## 🚨 Common Integration Mistakes to Avoid

### ❌ DON'T: Guess API endpoints
```dart
// BAD - Guessing the path
dio.post('/event/$id/register');
```

### ✅ DO: Check backend controller
```dart
// GOOD - Verified from events.controller.ts line 89
dio.post('/events/$id/register');  // Note: plural "events"
```

### ❌ DON'T: Assume field names
```dart
// BAD - Wrong field name
{"payment_method": paymentMethodId}
```

### ✅ DO: Copy from backend DTO
```dart
// GOOD - From register-event.dto.ts
{"stripePaymentMethodId": paymentMethodId}
```

### ❌ DON'T: Skip optional fields
```dart
// BAD - Making payment required when it's not
if (paymentMethodId == null) throw Error();
```

### ✅ DO: Match backend logic
```dart
// GOOD - Payment optional (events.service.ts line 440-472)
// Backend allows registration without payment for church-friendly model
stripePaymentMethodId: paymentMethodId,  // Can be null
```

---

## 📖 Quick Reference Commands

### Look up endpoint before implementing:
```bash
# Find auth endpoints
grep -r "@Post\|@Get\|@Patch\|@Delete" backend/src/modules/users/users.controller.ts

# See DTO structure
cat backend/src/modules/events/dto/create-event.dto.ts

# Check service logic
cat backend/src/modules/giving/donations.service.ts
```

### When in doubt:
1. Read the backend controller for endpoint path
2. Read the backend service for business logic
3. Read the DTO for exact field names and types
4. Check the Swagger docs: `http://localhost:3000/api`

---

**GOLDEN RULE:** If you're implementing an API integration and haven't read the backend code, STOP and read it first. 5 minutes of reading saves hours of debugging. 🎯

---

## 📊 Work Tracking Workflow

### Daily Development Workflow

Shepherd Sync Mobile uses a **simple two-file tracking system** for solo development:

1. **TODO.md** - Master task list (what needs to be done)
2. **JOURNAL.md** - Daily development log (what was done)

### Morning Routine (5 minutes)

```markdown
1. Open TODO.md
2. Review current sprint section
3. Pick 2-3 tasks for today
4. Start working
```

### During Development

- Code normally following patterns in this document
- Use TodoWrite tool for internal progress tracking
- Commit frequently with semantic commit messages
- Reference TODO items in commits when relevant

**Semantic Commit Format:**
```bash
feat(auth): add beautiful login screen with animations
fix(network): resolve token refresh infinite loop
docs: update API integration reference in claude.md
test(auth): add unit tests for auth repository
refactor(widgets): extract CustomButton to separate file
style(theme): update primary color to match branding
```

### ⚠️ CRITICAL: End of Work Session (5-10 minutes)

**YOU MUST UPDATE BOTH FILES AFTER EVERY WORK SESSION:**

#### 1. Update JOURNAL.md

```markdown
## 2026-01-08 (Wednesday) - [Session Title]

**Time:** X hours

**Completed:**
- ✅ Task 1 with detailed description
- ✅ Task 2 with file references (lib/features/auth/login_screen.dart:45)
- ✅ Task 3 with technical details

**Code Quality:**
- ✅ Flutter analyze: 0 errors
- ✅ All tests passing
- ✅ Follows Clean Architecture

**Next:**
- Task for next session
- Another task

**Blockers:**
- None (or list blockers)

**Notes:**
- Key decisions made
- Performance observations
- Lessons learned
```

#### 2. Update TODO.md

Mark completed tasks with `[x]`:

```markdown
### Authentication Module ⏳ IN PROGRESS
- [x] Build Login Screen ✅ DONE
  - [x] Email/password form with validation
  - [x] Beautiful animations
  - [x] Error handling
- [ ] Build Register Screen (NEXT)
  - [ ] Multi-step form
```

Update status markers:
- `✅ COMPLETED` - Entire section done
- `⏳ IN PROGRESS` - Currently working on
- `❌ BLOCKED` - Blocked by something

Update "Current Sprint" section:
```markdown
### Completed This Sprint
- [x] Login Screen
- [x] Auth State Management
- [x] Custom Widgets

### In Progress
- [ ] Register Screen
- [ ] Dashboard
```

### Weekly Review (15 minutes)

Every Friday or end of sprint:

1. Review JOURNAL.md weekly summary section
2. Calculate total hours and tasks completed
3. Update milestones in TODO.md
4. Plan next week's focus areas
5. Document lessons learned

### Progress Tracking Commands

```bash
# See what you've done this week
git log --since="1 week ago" --oneline

# Count completed tasks
cat TODO.md | grep "\[x\]" | wc -l

# View recent work
tail -100 JOURNAL.md

# Check Flutter code health
flutter analyze
```

### When to Update Tracking

**✅ Always update after:**
- Completing a screen or major component
- Completing a feature module (auth, events, etc.)
- Hitting a blocker or making an important decision
- End of each work session (MANDATORY!)
- Discovering new tasks that need to be done

**❌ Don't track:**
- Small refactors (< 15 min)
- Documentation typos
- Dependency updates
- Code formatting

### Task States in TODO.md

- `[ ]` - Not started
- `[x]` - Completed
- `⏳ IN PROGRESS` - Currently working
- `✅ COMPLETED` - Entire section done
- `❌ BLOCKED` - Blocked by dependency
- `💡` - Nice to have / Future enhancement

### Integration with Development

```bash
# Link commits to TODO tasks
git commit -m "feat(auth): implement beautiful login screen

- Created LoginScreen with fade-in animations
- Added email/password validation
- Integrated with AuthStateProvider
- Error handling with SnackBar

Related: TODO.md Phase 1 - Authentication Module"
```

### Example Daily Flow

```
9:00 AM  - Review TODO.md, pick: "Build Login Screen"
9:05 AM  - Start coding login_screen.dart
10:30 AM - Commit: "feat(auth): add login screen UI"
12:00 PM - Commit: "feat(auth): add login validation"
12:30 PM - Lunch
1:30 PM  - Commit: "feat(auth): integrate login with state"
3:00 PM  - Run flutter analyze, fix warnings
4:00 PM  - Commit: "feat(auth): complete login screen"
4:30 PM  - Update JOURNAL.md with detailed progress ⚠️ CRITICAL
4:35 PM  - Check off "Build Login Screen [x]" in TODO.md ⚠️ CRITICAL
4:40 PM  - Review both files to ensure they're up to date
```

### Benefits

✅ **5-10 minutes daily overhead**
✅ **Clear progress visibility**
✅ **Historical reference for decisions**
✅ **Easy to resume after breaks**
✅ **Generates natural documentation**
✅ **User can see exactly what was accomplished**
✅ **Prevents losing track of completed work**
✅ **Makes it easy to pick up where you left off**

### ⚠️ CRITICAL REMINDER

**DO NOT END A WORK SESSION WITHOUT:**
1. Updating JOURNAL.md with what was completed
2. Checking off completed tasks in TODO.md
3. Updating the "Current Sprint" section in TODO.md
4. Adding any newly discovered tasks to TODO.md

**Why this matters:**
- The user relies on these files to track progress
- TodoWrite tool is internal - user cannot see it
- JOURNAL.md and TODO.md are the source of truth
- Forgetting to update creates confusion about what's done

---

## 💡 When Working with Claude

1. **Always read this file first** before implementing features
2. **Follow the architecture** - don't deviate without discussion
3. **Write production-quality code** - this is a top-class SaaS product
4. **Think like a senior architect** - consider scalability, maintainability, testability
5. **Make it beautiful** - UI/UX is a competitive advantage
6. **Test everything** - bugs in production hurt reputation
7. **Document complex logic** - future developers (and Claude) will thank you
8. **⚠️ UPDATE TODO.md AND JOURNAL.md** - After every work session (NON-NEGOTIABLE)

---

**Remember: We're building a premium product that churches will trust with their most important data. Quality is non-negotiable.** 🎯
