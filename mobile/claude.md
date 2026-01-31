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

## 🎨 Modern Design System (Blueprint)

**CRITICAL: This section defines the modern design language implemented in Members screens and should be applied consistently across ALL new screens going forward.**

### Visual Principles

**State-of-the-Art Modern UI:**
- Compact, efficient use of screen space
- Gradient backgrounds for depth and visual interest
- Glassmorphic effects for premium feel
- Generous use of rounded corners (16px standard)
- Color-coded sections for visual hierarchy
- Soft shadows with color tints
- Adaptive components (use `.adaptive()` for progress indicators)

### Color System

**Primary Gradient Pattern:**
```dart
// Header/Hero sections
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.primary,
    AppColors.primary.withValues(alpha: 0.8),  // or 0.7
  ],
)
```

**Accent Colors for Sections:**
- **Contact Info**: `Colors.blue` (#2196F3)
- **Personal Info**: `Colors.purple` (#9C27B0)
- **Church Info**: `AppColors.primary` (your theme color)
- **Emergency**: `Colors.red` (#F44336)
- **Membership**: `Colors.blue`
- **Forms/Basic**: `AppColors.primary`

**Background Overlays & Tints:**
```dart
// Light tints for section backgrounds
accentColor.withValues(alpha: 0.08)  // Header backgrounds
accentColor.withValues(alpha: 0.02)  // Gradient end

// Semi-transparent for badges/pills
Colors.white.withValues(alpha: 0.2)  // On colored backgrounds
accentColor.withValues(alpha: 0.1)   // On white backgrounds

// Very subtle decorative elements
Colors.white.withValues(alpha: 0.1)  // Large decorative circles
Colors.white.withValues(alpha: 0.05) // Smaller decorative circles
```

### Shadow System

**Soft Shadows (Standard Cards):**
```dart
BoxShadow(
  color: accentColor.withValues(alpha: 0.08),  // or 0.1
  blurRadius: 20,
  offset: const Offset(0, 4),
)
```

**Strong Shadows (Prominent Elements like FABs):**
```dart
BoxShadow(
  color: accentColor.withValues(alpha: 0.3),
  blurRadius: 20,
  offset: const Offset(0, 8),
)
```

**Icon Container Shadows:**
```dart
BoxShadow(
  color: accentColor.withValues(alpha: 0.1),  // or 0.2
  blurRadius: 8,
  offset: const Offset(0, 2),
)
```

### Border Radius Standards

```dart
BorderRadius.circular(16)  // Cards, major containers, search bars
BorderRadius.circular(12)  // Buttons, medium containers
BorderRadius.circular(8)   // Small containers, icon boxes
BorderRadius.circular(20)  // Pills, badges (typically half the height)
BorderRadius.circular(AppConstants.radiusFull) // Fully rounded chips
```

**Partial Rounded Corners:**
```dart
// Section headers
BorderRadius.only(
  topLeft: Radius.circular(16),
  topRight: Radius.circular(16),
)
```

### Typography Hierarchy

**Headers:**
```dart
// Page titles (in app bar)
fontSize: 20, fontWeight: FontWeight.bold

// Section headers
fontSize: 16-18, fontWeight: FontWeight.bold

// Subsection headers
fontSize: 16, fontWeight: FontWeight.bold
```

**Labels & Values:**
```dart
// Field labels (captions)
fontSize: 11
fontWeight: FontWeight.w500
color: Colors.grey[500] or Colors.grey[600]
letterSpacing: 0.5  // For uppercase labels

// Value text
fontSize: 15
fontWeight: FontWeight.w600
color: Colors.black (default)

// Large stat values
fontSize: 28
fontWeight: FontWeight.bold
color: accentColor
```

**Descriptive Text:**
```dart
// Subtitles, descriptions
fontSize: 13
color: Colors.grey[600]
```

### Spacing Scale (AppConstants)

```dart
spacingSM: 8px   // Tight groupings, icon padding
spacingMD: 16px  // Standard spacing, card padding
spacingLG: 24px  // Large gaps, form section padding
spacingXL: 32px  // Extra large gaps, bottom padding before buttons
```

**Usage Patterns:**
- Between sections: `spacingMD` (16px)
- Between form fields: `spacingMD` (16px)
- Section content padding: `spacingLG` (24px) for forms, `spacingMD` (16px) for readonly
- Bottom spacing before action buttons: `spacingXL` (32px)
- Icon-to-text spacing: `spacingMD` (16px)
- Chip spacing: `spacingSM` (8px)

### Header Patterns

**Compact SliverAppBar (List Screens):**
```dart
SliverAppBar(
  expandedHeight: 170,  // Compact, not 200+
  floating: false,
  pinned: true,
  elevation: 0,
  // White icons
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => context.go(AppRoutes.dashboard),
  ),
  // Gradient background with decorative circles
  flexibleSpace: FlexibleSpaceBar(
    title: Text(
      'Screen Title',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(/* ... */),
      ),
      child: Stack(
        children: [
          // Decorative circles for depth
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // More circles...
        ],
      ),
    ),
  ),
)
```

**Hero Header (Detail Screens):**
```dart
SliverAppBar(
  expandedHeight: 280,  // Taller for profile content
  floating: false,
  pinned: true,
  elevation: 0,
  backgroundColor: AppColors.primary,
  // White icons
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
  flexibleSpace: FlexibleSpaceBar(
    background: Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(/* ... */),
          ),
        ),
        // Decorative circles
        // Profile content at bottom
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _buildHeroProfileCard(data),
        ),
      ],
    ),
  ),
)
```

**Compact AppBar (Form Screens):**
```dart
AppBar(
  title: Text(
    'Screen Title',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
  elevation: 0,
  backgroundColor: AppColors.primary,
  foregroundColor: Colors.white,
)
```

### Card/Section Patterns

**Modern Section Card:**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    children: [
      // Gradient header with icon
      Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: 0.08),
              accentColor.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            // Icon in white container with shadow
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(headerIcon, color: accentColor, size: 20),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Text(
              'Section Title',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      // Content
      Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        child: Column(children: [...]),
      ),
    ],
  ),
)
```

**Form Section Pattern (CRITICAL for Consistency):**

When building forms with multiple sections, **ALWAYS use a helper method like `_buildFormSection()`** to ensure consistency. Never mix Card widgets with custom section builders.

```dart
Widget _buildFormSection(
  String title,
  IconData icon,
  Color accentColor,
  List<Widget> children,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with gradient and icon
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withValues(alpha: 0.08),
                accentColor.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Content with consistent padding
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    ),
  );
}

// Usage - ALL sections should use this pattern
_buildFormSection(
  'Basic Information',
  Icons.badge_rounded,
  AppColors.primary,
  [/* form fields */],
),

_buildFormSection(
  'Membership Details',
  Icons.card_membership_rounded,
  Colors.blue,
  [/* form fields */],
),

_buildFormSection(
  'Church Information',
  Icons.church_rounded,
  AppColors.primary,
  [/* form fields */],
),

_buildFormSection(
  'Address',
  Icons.location_on_rounded,
  Colors.green,
  [/* form fields */],
),

_buildFormSection(
  'Emergency Contact',
  Icons.emergency_rounded,
  Colors.orange,
  [/* form fields */],
),
```

**Form Section Accent Colors (MUST match between detail and form screens):**
- Basic Information (form) = Contact Information (detail): `Colors.blue`
- Membership Details (form) = Personal Information (detail): `Colors.purple`
- Church Information (both): `AppColors.primary`
- Address (both): `Colors.green`
- Emergency Contact (both): `Colors.red`

**Color Mapping Reference:**
```dart
// Form Screen → Detail Screen
_buildFormSection('Basic Information', ..., Colors.blue)       // → Contact Information
_buildFormSection('Membership Details', ..., Colors.purple)    // → Personal Information
_buildFormSection('Church Information', ..., AppColors.primary) // → Church Information
_buildFormSection('Address', ..., Colors.green)                // → Address
_buildFormSection('Emergency Contact', ..., Colors.red)        // → Emergency Contact
```

**CRITICAL: Never use plain Card widgets in forms - always use the section pattern for consistency.**

### Custom Form Widgets

**CRITICAL: Use consistent custom widgets for all form inputs.**

**Available Custom Widgets:**
- **Text inputs:** Use `CustomTextField` (already created)
- **Dropdowns:** Use `CustomDropdown` (NEVER use `DropdownButtonFormField` directly)
- **Phone numbers:** Use `CustomPhoneField` (with country code picker)
- **Profile pictures:** Use `ProfilePicturePicker` (with image cropping)
- All widgets share identical styling for consistency

**Why CustomDropdown?**
- Matches CustomTextField styling exactly (same borders, shadows, focus states)
- Consistent label positioning and typography
- Same animated focus shadow effect
- Maintains design system integrity

**CustomDropdown Usage:**
```dart
import '../../../../core/widgets/custom_dropdown.dart';

// Basic usage
CustomDropdown<String>(
  label: 'Gender',
  hint: 'Select gender',
  value: _selectedGender,
  items: const [
    DropdownMenuItem(value: 'MALE', child: Text('Male')),
    DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
    DropdownMenuItem(value: 'OTHER', child: Text('Other')),
  ],
  onChanged: (value) {
    setState(() => _selectedGender = value);
  },
)

// With validation
CustomDropdown<String>(
  label: 'Membership Status',
  hint: 'Select membership status',
  value: _selectedMembershipStatus,
  items: const [
    DropdownMenuItem(value: 'VISITOR', child: Text('Visitor')),
    DropdownMenuItem(value: 'ACTIVE_MEMBER', child: Text('Active Member')),
    DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
  ],
  onChanged: (value) {
    setState(() => _selectedMembershipStatus = value);
  },
  validator: (value) {
    if (value == null) return 'Please select a status';
    return null;
  },
)

// With prefix icon
CustomDropdown<String>(
  label: 'Marital Status',
  hint: 'Select marital status',
  value: _selectedMaritalStatus,
  prefixIcon: Icon(Icons.favorite_rounded),
  items: const [
    DropdownMenuItem(value: 'SINGLE', child: Text('Single')),
    DropdownMenuItem(value: 'MARRIED', child: Text('Married')),
    DropdownMenuItem(value: 'DIVORCED', child: Text('Divorced')),
    DropdownMenuItem(value: 'WIDOWED', child: Text('Widowed')),
  ],
  onChanged: (value) {
    setState(() => _selectedMaritalStatus = value);
  },
)
```

**CustomTextField Usage:**
```dart
import '../../../../core/widgets/custom_text_field.dart';

CustomTextField(
  controller: _firstNameController,
  label: 'First Name',
  hint: 'Enter first name',
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    return null;
  },
)
```

**CustomPhoneField Usage:**
```dart
import '../../../../core/widgets/custom_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

CustomPhoneField(
  label: 'Phone',
  hint: 'Enter phone number',
  initialCountryCode: 'US', // or extracted from phoneCountryCode
  initialValue: _phoneNumber,
  onChanged: (PhoneNumber phone) {
    setState(() {
      _phoneCountryCode = '+${phone.countryCode}';
      _phoneNumber = phone.number;
    });
  },
  validator: (PhoneNumber? phone) {
    if (phone == null) return 'Phone is required';
    return null;
  },
)
```

**ProfilePicturePicker Usage:**
```dart
import 'dart:io';
import '../../../../core/widgets/profile_picture_picker.dart';

// In state
File? _profileImage;
String? _profileImageUrl;

// In build method
ProfilePicturePicker(
  imageUrl: _profileImageUrl, // Existing photo URL
  imageFile: _profileImage,   // New photo file
  onImageSelected: (file) {
    setState(() {
      _profileImage = file;
    });
  },
  size: 120, // Diameter in pixels
  showEditIcon: true,
  backgroundColor: AppColors.primary, // Optional
  iconColor: Colors.white, // Optional
)
```

**Form Input Consistency Rules:**
1. ❌ NEVER use `TextField` or `TextFormField` directly → ✅ Use `CustomTextField`
2. ❌ NEVER use `DropdownButtonFormField` directly → ✅ Use `CustomDropdown`
3. ❌ NEVER use raw phone input → ✅ Use `CustomPhoneField` with country code
4. ❌ NEVER use basic image picker → ✅ Use `ProfilePicturePicker` with cropping
5. ✅ All widgets share the same label style, borders, shadows, and focus effects
6. ✅ Spacing between form fields: `AppConstants.spacingMD` (16px)
7. ✅ Labels are always above the input (not floating)
8. ✅ Focus state adds a subtle shadow (primary color, 10% alpha)
9. ✅ Profile pictures use circular cropping (1:1 aspect ratio)
10. ✅ Phone numbers store both countryCode and number separately

**Info Row Pattern:**
```dart
Widget _buildModernInfoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon in light gray container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.grey[600]),
        ),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              // Value
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

### Stat Card Pattern

```dart
Widget _buildModernStatCard(
  String label,
  String value,
  IconData icon,
  Gradient gradient,
  Color iconColor,
) {
  return Container(
    padding: const EdgeInsets.all(AppConstants.spacingMD),
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: iconColor.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon in white container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: AppConstants.spacingSM),
        // Label
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.grey[600],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        // Value
        Text(
          value,
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: iconColor,
          ),
        ),
      ],
    ),
  );
}
```

### Search Bar Pattern

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.1),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Search...',
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(
        Icons.search_rounded,
        color: AppColors.primary,
      ),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
              onPressed: () {
                _searchController.clear();
                // Clear search
              },
            )
          : null,
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMD,
        vertical: AppConstants.spacingMD,
      ),
    ),
  ),
)
```

### FAB Pattern

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: LinearGradient(
      colors: [
        AppColors.primary,
        AppColors.primary.withValues(alpha: 0.8),
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: FloatingActionButton.extended(
    onPressed: _onTap,
    backgroundColor: Colors.transparent,
    elevation: 0,
    icon: const Icon(Icons.add_rounded, color: Colors.white),
    label: const Text(
      'Add Item',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
```

### Icon Standards

**Use Rounded Icons:**
- `Icons.arrow_back` → `Icons.arrow_back` (already rounded)
- `Icons.filter_list` → `Icons.filter_list_rounded`
- `Icons.search` → `Icons.search_rounded`
- `Icons.add` → `Icons.add_rounded`
- `Icons.edit` → `Icons.edit_rounded`
- `Icons.delete` → `Icons.delete_rounded`
- `Icons.person` → `Icons.person_rounded`
- `Icons.email` → `Icons.email_rounded`
- `Icons.phone` → `Icons.phone_rounded`
- And so on...

### Empty States

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Icon in colored circle
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.people_outline_rounded,
          size: 64,
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
      const SizedBox(height: AppConstants.spacingLG),
      Text(
        'No Items Found',
        style: AppTextStyles.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: AppConstants.spacingSM),
      Text(
        'Add your first item to get started',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.grey[600],
        ),
      ),
    ],
  ),
)
```

### Loading States

**ALWAYS use adaptive progress indicators:**
```dart
// Good ✅
CircularProgressIndicator.adaptive()

// Bad ❌
CircularProgressIndicator()
```

This ensures iOS gets Cupertino spinner, Android gets Material spinner.

### Shimmer Loading States

**CRITICAL: Use shimmer skeleton loading for content areas, not just spinners.**

**Why Shimmer:**
- Premium, polished feel
- Users see the UI structure while loading
- Reduces perceived loading time
- Modern pattern used by Facebook, LinkedIn, etc.

**Package:** `shimmer: ^3.x`

**When to Use Shimmer:**
- List views (skeleton of list items)
- Card grids (skeleton cards)
- Detail screens (skeleton content)
- Dashboard widgets (skeleton stats/charts)

**When to Use Progress Indicator Instead:**
- Full-screen initial loads
- Pull-to-refresh actions
- Small button loading states
- "Load more" pagination

#### Shimmer Widget Patterns

**List Item Skeleton:**
```dart
import 'package:shimmer/shimmer.dart';

Widget _buildShimmerListItem() {
  return Container(
    margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
    padding: const EdgeInsets.all(AppConstants.spacingMD),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Avatar shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMD),

        // Text content shimmer
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Usage in list
Widget _buildShimmerList() {
  return ListView.builder(
    padding: const EdgeInsets.all(AppConstants.spacingMD),
    itemCount: 6, // Show 6 skeleton items
    itemBuilder: (context, index) => _buildShimmerListItem(),
  );
}
```

**Stat Card Skeleton:**
```dart
Widget _buildShimmerStatCard() {
  return Container(
    padding: const EdgeInsets.all(AppConstants.spacingMD),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingSM),

        // Label shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 60,
            height: 11,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Value shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    ),
  );
}
```

**Section Card Skeleton:**
```dart
Widget _buildShimmerSection() {
  return Container(
    margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header shimmer
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content rows shimmer
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          child: Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 11,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
```

**Dashboard Card Skeleton:**
```dart
Widget _buildShimmerDashboardCard() {
  return Container(
    padding: const EdgeInsets.all(AppConstants.spacingLG),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingLG),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    ),
  );
}
```

**Shimmer Best Practices:**
- **Base color:** `Colors.grey[300]` - The static background
- **Highlight color:** `Colors.grey[100]` - The shimmer sweep
- **Border radius:** Match the actual component (4px for text, 8px for icons, etc.)
- **Skeleton count:** Show 3-6 skeleton items to fill viewport
- **Dimensions:** Match actual content sizes as closely as possible
- **Container color:** Always set to white (or card background)
- **Duration:** Default shimmer duration is fine (1.5s), don't customize unless needed

**Implementation Pattern:**
```dart
// In your build method
if (state.isLoading && state.items.isEmpty) {
  return _buildShimmerList();
}

if (state.items.isEmpty) {
  return _buildEmptyState();
}

return _buildItemsList(state.items);
```

**Shimmer Implementation Status:**
- ✅ Members List Screen - Implemented (list items + stat cards)
- ⏳ Dashboard Screen - TODO: Add shimmer when converting mock data to async API calls
  - Quick action grid shimmer
  - Stats overview shimmer
  - Announcements carousel shimmer
  - Upcoming events shimmer
- ⏳ Other screens - Add as async data loading is implemented

**Reference Implementation:**
- See `lib/features/members/presentation/screens/members_list_screen.dart:530-610` for complete shimmer examples

### Bottom Sheet Patterns

**CRITICAL: ALWAYS use bottom sheets with draggable handles instead of AlertDialog for modals, confirmations, and actions.**

**Why Bottom Sheets:**
- More mobile-friendly and thumb-reachable
- Modern iOS/Android pattern
- Draggable for easy dismissal
- Better UX on phones
- Consistent with Material Design 3

**❌ NEVER USE:**
```dart
// Bad - Don't use AlertDialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [/*...*/],
  ),
);
```

**✅ ALWAYS USE Bottom Sheets:**

#### Confirmation Sheet Pattern

```dart
Future<bool?> _showConfirmationSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  Color? confirmColor,
  IconData? icon,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),

              // Icon (optional)
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (confirmColor ?? Colors.red).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: confirmColor ?? Colors.red,
                  ),
                ),

              if (icon != null) const SizedBox(height: AppConstants.spacingLG),

              // Title
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingSM),

              // Message
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingLG),

              // Action buttons - STACKED VERTICALLY for better UX hierarchy
              Column(
                children: [
                  // Primary action at bottom (easier to reach with thumb)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor ?? Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMD,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMD),

                  // Secondary action (Cancel) - less prominent
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMD,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Usage
final confirmed = await _showConfirmationSheet(
  context,
  title: 'Delete Member',
  message: 'Are you sure you want to delete this member? This action can be undone later.',
  confirmText: 'Delete',
  confirmColor: Colors.red,
  icon: Icons.delete_rounded,
);

if (confirmed == true) {
  // Perform action
}
```

#### Action Sheet Pattern (Multiple Options)

```dart
void _showActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable handle
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingMD,
              ),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLG,
              ),
              child: Text(
                'Choose Action',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),

            // Options
            _buildActionItem(
              icon: Icons.edit_rounded,
              label: 'Edit',
              onTap: () {
                Navigator.pop(context);
                // Handle edit
              },
            ),
            _buildActionItem(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            _buildActionItem(
              icon: Icons.delete_rounded,
              label: 'Delete',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                // Show delete confirmation sheet
              },
            ),

            const SizedBox(height: AppConstants.spacingSM),
          ],
        ),
      ),
    ),
  );
}

Widget _buildActionItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color? color,
}) {
  final itemColor = color ?? Colors.grey[800];
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      child: Row(
        children: [
          Icon(icon, color: itemColor, size: 24),
          const SizedBox(width: AppConstants.spacingMD),
          Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              color: itemColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
```

#### Filter/Options Sheet Pattern

```dart
// Already implemented in members_filter_sheet.dart
// Key features:
// - Draggable handle at top
// - Title with "Clear All" action
// - Sectioned content with chips
// - Primary action button at bottom
// - SafeArea for proper padding
```

**Bottom Sheet Best Practices:**
- Always include draggable handle (40x4 Container with grey[300])
- **CRITICAL: Stack buttons vertically, NOT horizontally**
  - Primary action button at bottom (easiest thumb reach)
  - Secondary/cancel button above it
  - Full width buttons with `SizedBox(width: double.infinity)`
  - Spacing of spacingMD (16px) between buttons
- Use `isScrollControlled: true` for sheets with dynamic/long content
- Use `backgroundColor: Colors.transparent` to show rounded corners
- Wrap content in SafeArea to handle notches
- Set `mainAxisSize: MainAxisSize.min` for auto-sizing
- Use 20px top corner radius
- Pad content with spacingLG (24px)
- Buttons should be 12px border radius
- Icon badges should use 10% alpha of accent color
- Dangerous actions (delete) should use red color
- Primary button uses elevated style, secondary uses outlined style
- Button text: 16px, w600 for primary, w500 for secondary

### Reference Implementation

**See these files for complete examples:**
- `lib/features/members/presentation/screens/members_list_screen.dart` - List screen with SliverAppBar, search, stats
- `lib/features/members/presentation/screens/member_detail_screen.dart` - Detail screen with hero header
- `lib/features/members/presentation/screens/member_form_screen.dart` - Form screen with sectioned layout
- `lib/features/members/presentation/widgets/members_filter_sheet.dart` - Bottom sheet with filter chips

**Apply this design system to ALL new screens for consistency.**

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

## 🔗 Deep Links & Invite System

### Invite-First Member Onboarding

**Flow:**
1. Admin creates member with minimal details (name + phone/email)
2. System sends invite link via SMS/Email/WhatsApp
3. Member taps link → App opens (or redirects to App Store)
4. Member completes profile & creates account
5. Status changes from PENDING → ACTIVE

**Advantages:**
- ✅ Admin controls access (no open registration)
- ✅ Email/phone verification built-in
- ✅ Prevents duplicate accounts
- ✅ Single source of truth
- ✅ Modern OAuth support (Google/Apple)

### Deep Link Configuration

**Android (AndroidManifest.xml):**
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="shepherdsync.app"
        android:pathPrefix="/invite" />
</intent-filter>
```

**iOS (Info.plist):**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>shepherdsync</string>
        </array>
    </dict>
</array>
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:shepherdsync.app</string>
</array>
```

### Deep Link Handler

```dart
import 'package:app_links/app_links.dart';
import 'deep_link_handler.dart';

// In main.dart or root widget
@override
void initState() {
  super.initState();
  DeepLinkHandler().init(context);
}

// Handler automatically listens for:
// - https://shepherdsync.app/invite/{token}
// - shepherdsync://invite/{token}
```

### Invite System Backend Endpoints

**Send Invite:**
```dart
POST /members/:id/send-invite
Body: {
  "method": "SMS", // or EMAIL, WHATSAPP, MANUAL
  "customMessage": "Optional custom message"
}

Response: {
  "inviteToken": "abc123...",
  "inviteCode": "ABC123", // 6-digit human-readable
  "inviteUrl": "https://shepherdsync.app/invite/abc123...",
  "expiresAt": "2024-02-15T00:00:00Z"
}
```

**Validate Invite:**
```dart
GET /auth/validate-invite?token=abc123

Response: {
  "valid": true,
  "member": {
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "organizationName": "Grace Church"
  },
  "expiresAt": "2024-02-15T00:00:00Z"
}
```

**Complete Invite:**
```dart
POST /auth/complete-invite
Body: {
  "token": "abc123...",
  "password": "SecurePass123!", // OR
  "googleIdToken": "google-token", // OR
  "appleAuthCode": "apple-code",
  "profilePhotoBase64": "data:image/jpeg;base64,..." // Optional
}

Response: {
  "accessToken": "jwt...",
  "refreshToken": "jwt...",
  "user": {...},
  "organization": {...}
}
```

### Member Model with Invite Fields

```dart
@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
    String? phoneCountryCode, // ✅ NEW
    String? phone,
    String? photo,
    String? userId,
    String? inviteStatus, // ✅ NEW: PENDING, INVITED, ACTIVE, EXPIRED
    DateTime? invitedAt,  // ✅ NEW
    DateTime? activatedAt, // ✅ NEW
    // ... other fields
  }) = _MemberModel;
}
```

### Invite Signup Screen Pattern

**Key Features:**
- Profile photo picker (with cropping)
- Pre-filled member details (read-only)
- Password creation with validation
- Google/Apple Sign-In buttons
- Modern card-based layout
- Loading state while validating invite

**Implementation:**
```dart
// See: lib/features/auth/presentation/screens/invite_signup_screen.dart
InviteSignupScreen(inviteToken: 'abc123...')
```

### Send Invite UI Pattern

**In Member Detail Screen:**
- Show "Send Invite" button if `member.userId == null`
- Display invite status badge (PENDING/INVITED/ACTIVE)
- Bottom sheet with delivery options (SMS/Email/Copy Link)
- Beautiful option cards with icons

**Implementation:**
```dart
// Send invite button in app bar
if (member.userId == null && member.inviteStatus != 'ACTIVE')
  IconButton(
    icon: const Icon(Icons.send_rounded),
    onPressed: () => _showSendInviteSheet(context, member),
  ),
```

### Testing Deep Links

**Android (via ADB):**
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://shepherdsync.app/invite/abc123" \
  com.yourcompany.shepherdsync
```

**iOS (via Terminal):**
```bash
xcrun simctl openurl booted "https://shepherdsync.app/invite/abc123"
```

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
