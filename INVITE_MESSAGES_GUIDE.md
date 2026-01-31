# 📨 Invite Messages Guide

## Overview

All invite messages include **BOTH** the deep link AND the 6-digit manual code as a fallback.

---

## 📧 Email Template

**Includes:**
- ✅ Big "Accept Invite" button with deep link
- ✅ Manual 6-digit code in highlighted box
- ✅ Link fallback (copy/paste)
- ✅ Expiration date warning
- ✅ Church branding (logo + colors)

**Location:** `/backend/email-templates/member-invite.html`

**Example:**
```
Subject: You're Invited to Grace Community Church!

[Beautiful gradient header with church logo]

Hi John,

You've been invited to join Grace Community Church on Shepherd Sync!

[Big "Accept Invite & Get Started" button]

Or enter this code in the app:
┌─────────────┐
│  ABC123     │  (highlighted in dashed box)
└─────────────┘

Button not working? Copy this link:
https://shepherdsync.app/invite/abc123xyz

⏰ Important: This invite expires on February 15, 2024.
```

---

## 📱 SMS Template

**Includes:**
- ✅ Personalized greeting
- ✅ Deep link (tappable on mobile)
- ✅ 6-digit code
- ✅ Expiration date
- ✅ Church signature

**Location:** `/backend/sms-templates/member-invite.txt`

**Example:**
```
Hi John! 👋

You've been invited to join Grace Community Church on Shepherd Sync.

Tap to get started:
https://shepherdsync.app/invite/abc123xyz

Or enter code in app: ABC123

This invite expires on Feb 15, 2024.

- Grace Community Church
```

**Character Count:** ~180-220 chars (2 SMS segments)

---

## 💬 WhatsApp Template

**Includes:**
- ✅ Formatted text (bold, italics)
- ✅ Emojis for visual appeal
- ✅ Deep link
- ✅ 6-digit code (in monospace)
- ✅ Benefits list
- ✅ Two-way messaging support

**Location:** `/backend/whatsapp-templates/member-invite.txt`

**Example:**
```
Hi John! 👋

🏛 You've been invited to join *Grace Community Church* on Shepherd Sync!

Complete your profile to:
✅ Access events
✅ Give online
✅ Stay connected

*Get Started:*
https://shepherdsync.app/invite/abc123xyz

*Or enter code in app:*
`ABC123`

⏰ _Expires: February 15, 2024_

Questions? Reply to this message!

- Grace Community Church
```

---

## 🔗 Manual (Copy Link)

**Includes:**
- ✅ Full deep link
- ✅ 6-digit code
- ✅ Instructions

**Example Response:**
```json
{
  "success": true,
  "message": "Invite link generated",
  "inviteUrl": "https://shepherdsync.app/invite/abc123xyz",
  "inviteCode": "ABC123",
  "instructions": "Share this link with John Doe, or they can enter code ABC123 in the app"
}
```

**Admin UI shows:**
```
✅ Invite Ready!

Share this link:
https://shepherdsync.app/invite/abc123xyz
[Copy Link Button]

Or give them this code:
ABC123
[Copy Code Button]

Valid until: February 15, 2024
```

---

## 🎯 Why Both Link AND Code?

### Scenarios Where Link Might Fail:
1. **Email clients** may block or mangle links
2. **Corporate firewalls** may block unknown domains
3. **User accidentally closes** the invite screen
4. **Deep link not configured** on user's device
5. **App not installed** yet (goes to store first)

### Code Provides Fallback:
1. ✅ User can install app first
2. ✅ Then open app manually
3. ✅ Tap "I have an invite code"
4. ✅ Enter 6-digit code
5. ✅ Same invite flow as deep link

---

## 📊 Message Delivery Flow

```
Admin sends invite
       ↓
Backend generates:
  - inviteToken (32 chars)
  - inviteCode (6 digits)
  - inviteUrl (deep link)
       ↓
Message sent with BOTH:
  - Link (primary method)
  - Code (fallback)
       ↓
Member receives:
  Option A: Tap link → Opens app → Signup
  Option B: Use code → Open app → Enter code → Signup
```

---

## 🔧 Implementation

### Backend - Email (✅ COMPLETED)
```typescript
// In members.service.ts
case 'EMAIL':
  if (member.email) {
    await this.emailService.sendMemberInviteEmail({
      to: member.email,
      memberFirstName: memberName,
      churchName,
      inviteUrl,
      inviteCode,
      expirationDate: formattedExpirationDate,
      churchLogoUrl: member.organization.logoUrl,
    });
  }
  break;

// In email.service.ts
async sendMemberInviteEmail(data: {
  to: string;
  memberFirstName: string;
  churchName: string;
  inviteUrl: string;
  inviteCode: string;
  expirationDate: string;
  churchLogoUrl?: string;
}) {
  return await this.client.sendEmailWithTemplate({
    From: this.configService.get('POSTMARK_FROM_EMAIL'),
    To: data.to,
    TemplateAlias: 'member-invite',
    TemplateModel: {
      CHURCH_NAME: data.churchName,
      MEMBER_FIRST_NAME: data.memberFirstName,
      INVITE_URL: data.inviteUrl,
      INVITE_CODE: data.inviteCode,
      EXPIRATION_DATE: data.expirationDate,
      CHURCH_LOGO_URL: data.churchLogoUrl,
    },
  });
}
```

**Setup Required:**
See `/backend/POSTMARK_SETUP.md` for complete Postmark configuration instructions.

### Backend - SMS (TODO)
```typescript
// TODO: Integrate Twilio
await sms.send(`
  ${message}
  ${inviteUrl}
  Or use code: ${inviteCode}
`);
```

### Backend - WhatsApp (TODO)
```typescript
// TODO: Integrate WhatsApp Business API
await whatsapp.send(`
  ${message}
  ${inviteUrl}
  Or code: ${inviteCode}
`);
```

### Mobile - Manual Code Entry (TODO)

Create screen: `ManualInviteCodeScreen`

```dart
// On login screen, add button:
TextButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ManualInviteCodeScreen(),
    ),
  ),
  child: Text('I have an invite code'),
)

// ManualInviteCodeScreen
class ManualInviteCodeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Invite Code')),
      body: Column(
        children: [
          Text('Enter the 6-digit code from your invite'),
          PinCodeTextField(
            length: 6,
            onCompleted: (code) => _validateCode(code),
          ),
        ],
      ),
    );
  }

  Future<void> _validateCode(String code) async {
    // Call: GET /auth/validate-invite-code?code=ABC123
    // If valid, navigate to InviteSignupScreen with token
  }
}
```

### Backend - Validate by Code (TODO)

Add new endpoint:

```typescript
// auth.controller.ts
@Get('validate-invite-code')
async validateInviteByCode(@Query('code') code: string) {
  const inviteToken = await this.prisma.inviteToken.findUnique({
    where: { inviteCode: code },
    include: { member: { include: { organization: true } } },
  });

  if (!inviteToken || !inviteToken.isValid || new Date() > inviteToken.expiresAt) {
    throw new BadRequestException('Invalid or expired code');
  }

  return {
    valid: true,
    token: inviteToken.token, // Return the full token
    member: {
      firstName: inviteToken.member.firstName,
      // ...
    },
  };
}
```

---

## 📝 Testing

### Test Email (with code)
```bash
curl -X POST http://localhost:3000/api/v1/members/{id}/send-invite \
  -H "Content-Type: application/json" \
  -d '{"method": "EMAIL"}'

# Check logs - should show:
# [EMAIL] Code: ABC123
```

### Test SMS (with code)
```bash
curl -X POST http://localhost:3000/api/v1/members/{id}/send-invite \
  -H "Content-Type: application/json" \
  -d '{"method": "SMS"}'

# Check logs - should show:
# [SMS] Code: ABC123
```

### Test Manual Code Entry
```bash
# 1. Get invite code from any method
# 2. Open app
# 3. Tap "I have an invite code"
# 4. Enter: ABC123
# 5. Should validate and go to signup
```

---

## ✅ Summary

**Every invite delivery method includes:**
1. ✅ Deep link (primary)
2. ✅ 6-digit code (fallback)
3. ✅ Expiration date
4. ✅ Church branding
5. ✅ Clear instructions

**This ensures:**
- 📱 High success rate
- 🔄 Multiple fallback options
- 👴 Works for less tech-savvy members
- 🌐 Works even with network issues
- ✨ Professional user experience

---

## 📋 Implementation Status

### ✅ Completed
- [x] Email service integration (Postmark)
- [x] Email template with link + code
- [x] SMS template design
- [x] WhatsApp template design
- [x] Deep link configuration (mobile)
- [x] Invite signup screen (mobile)
- [x] Send invite endpoints (backend)

### ⏳ Pending
- [ ] Manual code entry screen (mobile)
- [ ] Validate-by-code endpoint (backend)
- [ ] SMS service integration (Twilio)
- [ ] WhatsApp Business API integration
- [ ] Postmark template setup in account

### 📖 Setup Guides
- Email: See `/backend/POSTMARK_SETUP.md`
- SMS: Coming soon (Twilio)
- WhatsApp: Coming soon (WhatsApp Business API)
