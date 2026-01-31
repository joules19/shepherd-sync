# Add Member Screen Implementation

## Overview

Created a simplified "Add Member" screen for admins following the invite-first approach. This screen collects minimal information needed to create a member record and send an invite.

---

## User Flow

```
Admin taps "Add Member" FAB
  ↓
AddMemberScreen (simplified form)
  - First Name *
  - Last Name *
  - Phone (optional but one required)
  - Email (optional but one required)
  - Date of Birth (optional)
  - Gender (optional)
  - Profile Photo (optional)
  ↓
Admin taps "Create & Send Invite"
  ↓
Member created with status: PENDING
  ↓
Bottom sheet appears: "Send Invite"
  - Send via SMS (if phone provided)
  - Send via Email (if email provided)
  - Copy Invite Link (always available)
  ↓
Admin selects method → Invite sent
  ↓
Member receives invite
  ↓
Member completes full profile during signup
```

---

## Files Created

### 1. `add_member_screen.dart`

**Location:** `mobile/lib/features/members/presentation/screens/add_member_screen.dart`

**Key Features:**
- ✅ Clean, minimal design following modern design system
- ✅ Profile photo picker (optional, with cropping)
- ✅ Custom form widgets (CustomTextField, CustomPhoneField, CustomDropdown)
- ✅ Form validation (at least phone or email required)
- ✅ Date picker for DOB with proper formatting
- ✅ Loading state during submission
- ✅ Beautiful invite method bottom sheet
- ✅ Success/error handling with SnackBars

**Form Fields:**
- First Name * (required)
- Last Name * (required)
- Phone (optional but recommended)
- Email (optional but recommended)
- Date of Birth (optional)
- Gender (optional dropdown: Male, Female, Other)
- Profile Photo (optional with circular cropping)

**Validation Rules:**
- First name and last name are required
- At least ONE of phone or email must be provided
- Email format validation if provided
- DOB uses date picker (no typing allowed)

**Bottom Sheet Options:**
1. **Send via SMS** - Shows if phone provided
   - Green icon/color
   - Shows phone number as subtitle

2. **Send via Email** - Shows if email provided
   - Blue icon/color
   - Shows email as subtitle

3. **Copy Invite Link** - Always available
   - Primary purple color
   - Manual sharing option

**Design Patterns Used:**
- Info banner explaining invite-first approach
- Centered profile photo picker
- Consistent spacing (spacingMD, spacingLG, spacingXL)
- Custom widgets for form consistency
- Primary color button with loading state
- Bottom sheet with draggable handle
- Success SnackBar with rounded corners

---

## Files Modified

### 1. `members_list_screen.dart`

**Changes:**
- Imported `AddMemberScreen`
- Removed unused `MemberFormScreen` import
- Updated `_navigateToAddMember()` to use `AddMemberScreen()`

**Navigation:**
```dart
void _navigateToAddMember() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddMemberScreen()),
  ).then((result) {
    if (result == true) {
      ref.read(membersProvider.notifier).fetchMembers(refresh: true);
    }
  });
}
```

---

## What Still Uses MemberFormScreen?

`member_form_screen.dart` is **NOT deleted** - it's still used for:
1. **Edit Member Profile** - When admin edits existing member's full profile
2. **Member Self-Service** - When member completes profile during invite signup
3. **Full Profile Management** - Contains all fields (address, occupation, emergency contact, etc.)

**Future Refactoring Suggestion:**
Consider renaming `member_form_screen.dart` to `member_profile_form_screen.dart` or `edit_member_profile_screen.dart` to clarify its purpose.

---

## API Integration (TODO)

The screen has placeholders for two API calls:

### 1. Create Member

**Endpoint:** `POST /members`

**Request:**
```dart
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",        // Optional
  "phone": "1234567890",              // Optional
  "phoneCountryCode": "+1",           // Optional
  "gender": "MALE",                   // Optional
  "dateOfBirth": "1990-01-15",        // Optional (ISO 8601)
  "photo": "https://cloudinary.../profile.jpg"  // Optional
}
```

**Response:**
```dart
{
  "id": "member-uuid",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "phone": "1234567890",
  "phoneCountryCode": "+1",
  "inviteStatus": "PENDING",
  "createdAt": "2026-01-29T...",
  ...
}
```

**Implementation Location:**
- Line 286-330 in `add_member_screen.dart`
- Replace mock member creation with actual API call
- Upload profile image to Cloudinary first if selected
- Use returned member ID for invite

### 2. Send Invite

**Endpoint:** `POST /members/:id/send-invite`

**Request:**
```dart
{
  "method": "SMS" | "EMAIL" | "MANUAL"
}
```

**Response:**
```dart
{
  "success": true,
  "message": "Invite sent via SMS",
  "inviteToken": "abc123...",
  "inviteCode": "ABC123",
  "inviteUrl": "https://shepherdsync.app/invite/abc123...",
  "expiresAt": "2026-02-05T...",
  "sentVia": "SMS"
}
```

**Implementation Location:**
- Line 241-262 in `add_member_screen.dart`
- Method: `_sendInvite(String method, String memberId)`
- Show invite code if method is MANUAL (copy to clipboard)

---

## UX Benefits

### For Admin:
✅ **Faster workflow** - Only 2-4 fields instead of 15+
✅ **Less data entry** - Member provides their own info
✅ **Clear purpose** - "Create & Send Invite" makes intent obvious
✅ **Flexible delivery** - Choose SMS, Email, or Manual sharing
✅ **Immediate action** - Send invite right after creation

### For Member:
✅ **Better data quality** - They provide accurate information
✅ **Privacy** - Admin doesn't need to know emergency contacts, address, etc.
✅ **Ownership** - They control their own profile
✅ **Modern flow** - Familiar invite-based signup (like Slack, Discord)

### For System:
✅ **Single source of truth** - No duplicate accounts
✅ **Email/phone verification** - Built into invite flow
✅ **Role-based access** - Admin creates, member completes
✅ **OAuth support** - Member can use Google/Apple Sign-In

---

## Design Patterns Followed

### 1. Form Layout
- Info banner explaining the approach
- Centered profile photo
- Consistent field spacing (spacingMD)
- Required fields marked with `*`
- Submit button with loading state
- Bottom spacing (spacingXL) before button

### 2. Custom Widgets
- `CustomTextField` for text inputs
- `CustomPhoneField` for phone with country code
- `CustomDropdown` for gender selection
- `ProfilePicturePicker` for photo upload
- All widgets share consistent styling

### 3. Bottom Sheet Pattern
- Draggable handle (40x4, grey[300])
- Title + subtitle explaining action
- Icon + label + subtitle for each option
- Color-coded options (green=SMS, blue=Email, purple=Link)
- SafeArea for proper padding

### 4. Loading States
- Disabled button during submission
- Circular progress indicator in button
- No double-submit protection

### 5. Error Handling
- Form validation with error messages
- Custom validation for phone/email requirement
- SnackBar with rounded corners for errors
- Error color from AppColors

### 6. Success Feedback
- Success SnackBar with green background
- Automatic navigation back to list
- List refresh on successful creation

---

## Testing Checklist

### Functional Testing
- [ ] Can create member with only required fields (name + phone)
- [ ] Can create member with only required fields (name + email)
- [ ] Cannot submit with neither phone nor email
- [ ] Profile photo picker works (camera/gallery)
- [ ] Profile photo cropping works (1:1 aspect)
- [ ] Date picker shows and formats correctly
- [ ] Gender dropdown shows all options
- [ ] Form validation catches empty required fields
- [ ] Form validation catches invalid email format
- [ ] Loading state shows during submission
- [ ] Success message appears after creation
- [ ] Invite method sheet appears after creation
- [ ] SMS option only shows if phone provided
- [ ] Email option only shows if email provided
- [ ] Manual option always shows
- [ ] Tapping invite option sends invite
- [ ] Navigates back to list after invite sent
- [ ] Member list refreshes after creation

### UI/UX Testing
- [ ] Follows modern design system (gradients, shadows, rounded corners)
- [ ] Info banner is visible and helpful
- [ ] Profile photo picker is centered and clear
- [ ] All fields use custom widgets (consistent styling)
- [ ] Spacing is consistent throughout
- [ ] Button is disabled during loading
- [ ] Bottom sheet has draggable handle
- [ ] Bottom sheet options are clear and actionable
- [ ] SnackBars appear and dismiss correctly
- [ ] App bar title is visible
- [ ] Back button works

### Edge Cases
- [ ] Very long names (50+ characters)
- [ ] International phone numbers
- [ ] Email with special characters
- [ ] DOB in past (1900-2026)
- [ ] DOB in future (should not allow)
- [ ] Rapid button tapping (no double submit)
- [ ] Network error during submission
- [ ] Back button during loading
- [ ] Photo upload failure

---

## Next Steps

1. **Integrate API Calls**
   - Replace mock member creation with actual POST /members
   - Implement profile photo upload to Cloudinary
   - Connect send invite to POST /members/:id/send-invite
   - Handle API errors gracefully

2. **Add Manual Code Display**
   - When MANUAL method selected, show invite code
   - Add copy to clipboard functionality
   - Show invite URL for sharing

3. **Enhance Invite Sheet**
   - Add WhatsApp option if phone provided
   - Add custom message field (optional)
   - Show invite preview before sending

4. **Add Member List Integration**
   - Refresh member list after creation
   - Show new member with PENDING status
   - Add badge/indicator for invited members

5. **Consider Renaming**
   - Rename `member_form_screen.dart` to `edit_member_profile_screen.dart`
   - Update all references
   - Update documentation

---

## Code Quality

✅ **Follows CLAUDE.md patterns**
✅ **Uses custom widgets for consistency**
✅ **Modern design system (gradients, shadows, rounded corners)**
✅ **Proper form validation**
✅ **Loading and error states**
✅ **Clean code structure**
✅ **No linting warnings**
✅ **Responsive layout**
✅ **Accessible (form labels, semantic widgets)**

---

## Screenshots Locations

(To be added after implementation)

- Add Member Screen - Empty state
- Add Member Screen - Filled form
- Add Member Screen - Date picker
- Add Member Screen - Gender dropdown
- Add Member Screen - Loading state
- Invite Method Bottom Sheet - All options
- Invite Method Bottom Sheet - Phone only
- Invite Method Bottom Sheet - Email only
- Success SnackBar

---

**Implementation Complete!** ✅

The simplified Add Member screen is ready for testing and API integration.
