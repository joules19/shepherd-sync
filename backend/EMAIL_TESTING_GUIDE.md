# Email Invite Testing Guide

## Quick Start - Test Email Sending

### 1. Configure Postmark

Add to your `.env` file:

```bash
POSTMARK_API_KEY=your-postmark-server-api-token
POSTMARK_FROM_EMAIL=noreply@shepherdsync.com
```

### 2. Create Postmark Template

1. Log in to [Postmark](https://postmarkapp.com)
2. Go to **Templates** → **New Template**
3. Set **Template Alias**: `member-invite` (must be exact)
4. Copy HTML from `/backend/email-templates/member-invite.html`
5. Set **Subject**: `You're Invited to {{CHURCH_NAME}}!`
6. Save template

### 3. Test Email Flow

#### Step 1: Start Backend

```bash
cd /Users/user/Documents/shepherd-sync/backend
npm run start:dev
```

#### Step 2: Create Test Member

```bash
curl -X POST http://localhost:3000/api/v1/members \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "your-test-email@example.com",
    "phone": "+1234567890"
  }'
```

Save the returned member ID (e.g., `"id": "abc123..."`)

#### Step 3: Send Email Invite

```bash
curl -X POST http://localhost:3000/api/v1/members/{MEMBER_ID}/send-invite \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "method": "EMAIL"
  }'
```

Expected response:

```json
{
  "success": true,
  "message": "Invite sent via EMAIL",
  "inviteToken": "abc123xyz...",
  "inviteCode": "ABC123",
  "inviteUrl": "https://shepherdsync.app/invite/abc123xyz...",
  "expiresAt": "2024-02-15T00:00:00.000Z",
  "sentVia": "EMAIL"
}
```

#### Step 4: Check Your Email

1. Check the email inbox you used in the member creation
2. You should receive an email with:
   - Subject: "You're Invited to [Your Church Name]!"
   - Purple gradient header
   - "Accept Invite & Get Started" button
   - Manual code in highlighted box (e.g., ABC123)
   - Expiration date
   - Copy/paste link fallback

### 4. Verify Logs

Check backend console for:

```
[EmailService] Member invite email sent to your-test-email@example.com (Code: ABC123)
```

### 5. Test Deep Link

Click the button in the email - it should:
- Open your mobile app (if installed and deep links configured)
- OR redirect to app store to download
- OR open web app with invite token

### 6. Test Manual Code Entry

1. Open mobile app
2. Tap "I have an invite code" (when implemented)
3. Enter the 6-digit code from email
4. Should validate and proceed to signup

---

## Troubleshooting

### Email Not Received

**Check 1: Postmark API Key**
```bash
# Should NOT see this in logs:
[EmailService] Invite email not sent (Postmark not configured)

# Should see this:
[EmailService] Member invite email sent to ...
```

**Check 2: Spam Folder**
- Check spam/junk folder
- Add sender to contacts

**Check 3: Postmark Activity**
1. Go to Postmark dashboard
2. Navigate to **Activity**
3. Look for recent sends
4. Check delivery status

### Template Not Found

```
Error: Could not find template with alias 'member-invite'
```

Fix:
- Template alias must be exactly `member-invite` (case-sensitive)
- Template must be in same server as API key

### Email Goes to Spam

Fix:
- Verify domain in Postmark
- Add DKIM and SPF DNS records
- Test with [Mail Tester](https://www.mail-tester.com/)

---

## Development Mode (Without Postmark)

For testing without Postmark account:

1. Leave `POSTMARK_API_KEY` empty in `.env`
2. Send invite as usual
3. Check logs for email details:

```
[EmailService] Invite email not sent (Postmark not configured): john@example.com
[EmailService] Would send to john@example.com with code: ABC123
```

This logs all email details without actually sending.

---

## Email Flow Verification

### Complete Flow

```
1. Admin creates member
   ↓
2. Admin clicks "Send Invite" → Selects EMAIL
   ↓
3. Backend generates:
   - 32-char token: abc123xyz...
   - 6-digit code: ABC123
   - Expires: 7 days
   ↓
4. Backend calls EmailService.sendMemberInviteEmail()
   ↓
5. EmailService sends via Postmark API
   - Template: member-invite
   - Variables: CHURCH_NAME, INVITE_URL, INVITE_CODE, etc.
   ↓
6. Member receives email
   ↓
7. Member clicks button OR enters code
   ↓
8. Mobile app validates invite
   ↓
9. Member completes signup
```

### Database Records

After sending invite, check database:

```sql
-- Invite token created
SELECT * FROM "InviteToken" WHERE "inviteCode" = 'ABC123';

-- Member status updated
SELECT "inviteStatus", "invitedAt" FROM "Member" WHERE id = 'member-id';
-- Should show: inviteStatus = 'INVITED', invitedAt = timestamp
```

---

## Production Checklist

Before going live:

- [ ] Postmark domain verified
- [ ] DKIM and SPF records added
- [ ] Template tested with real data
- [ ] Email renders correctly on all clients (Gmail, Outlook, Apple Mail)
- [ ] Deep link tested on iOS and Android
- [ ] Manual code entry tested
- [ ] Spam score checked (< 2.0)
- [ ] Bounce handling configured
- [ ] Postmark webhooks configured (optional)

---

## Next Steps

After email is working:

1. **Test resend invite**: Verify old tokens are invalidated
2. **Test expiration**: Check expired invites are rejected
3. **Add SMS**: Integrate Twilio for SMS invites
4. **Add WhatsApp**: Integrate WhatsApp Business API
5. **Analytics**: Track email open/click rates

---

**Email integration is complete and ready to test!** ✅
