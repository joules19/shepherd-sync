# Postmark Email Integration Setup

## Overview

The Shepherd Sync backend is configured to use Postmark for transactional emails. This guide walks you through setting up your Postmark account and configuring the member invite email template.

---

## 1. Environment Variables

Add these to your `.env` file:

```bash
# Postmark Configuration
POSTMARK_API_KEY=your-server-api-token-here
POSTMARK_FROM_EMAIL=noreply@shepherdsync.com  # Or your verified domain
```

### Getting Your API Key

1. Log in to [Postmark](https://postmarkapp.com)
2. Go to **Servers** → Select your server
3. Navigate to **API Tokens**
4. Copy your **Server API Token**
5. Paste it as `POSTMARK_API_KEY` in your `.env`

### Sender Signature

Before sending emails, you must verify your sender email:

1. In Postmark, go to **Sender Signatures**
2. Click **Add Domain** or **Add Email Address**
3. For production: Add your domain (e.g., `shepherdsync.com`)
4. For testing: Add a specific email (e.g., `noreply@shepherdsync.com`)
5. Follow verification instructions (DNS records for domain, or confirmation email)

---

## 2. Create Member Invite Template

### Option A: Using Postmark UI (Recommended)

1. Go to **Templates** → **New Template**
2. Choose **Blank Template**
3. Set **Template Alias**: `member-invite` (IMPORTANT: must match exactly)
4. Copy the HTML from `/backend/email-templates/member-invite.html`
5. Paste into the **HTML** tab
6. Set **Subject**: `You're Invited to {{CHURCH_NAME}}!`
7. Click **Save Template**

### Option B: Using Postmark API

```bash
curl "https://api.postmarkapp.com/templates" \
  -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Postmark-Server-Token: YOUR-API-TOKEN" \
  -d '{
    "Name": "Member Invite",
    "TemplateAlias": "member-invite",
    "Subject": "You'\''re Invited to {{CHURCH_NAME}}!",
    "HtmlBody": "<html>...paste HTML here...</html>",
    "TextBody": "Hi {{MEMBER_FIRST_NAME}},\n\nYou'\''ve been invited to join {{CHURCH_NAME}} on Shepherd Sync!\n\nClick here to accept: {{INVITE_URL}}\n\nOr enter this code in the app: {{INVITE_CODE}}\n\nThis invite expires on {{EXPIRATION_DATE}}."
  }'
```

---

## 3. Template Variables

The `member-invite` template uses these variables:

| Variable              | Description                          | Example                                    |
|-----------------------|--------------------------------------|-------------------------------------------|
| `CHURCH_NAME`         | Name of the church                   | "Grace Community Church"                  |
| `CHURCH_LOGO_URL`     | URL to church logo (optional)        | "https://cdn.example.com/logo.png"        |
| `MEMBER_FIRST_NAME`   | Member's first name                  | "John"                                    |
| `INVITE_URL`          | Deep link URL                        | "https://shepherdsync.app/invite/abc123..." |
| `INVITE_CODE`         | 6-digit manual code                  | "ABC123"                                  |
| `EXPIRATION_DATE`     | Formatted expiration date            | "February 15, 2024"                       |

---

## 4. Test Email Sending

### Test Template in Postmark

1. In Postmark, go to your **member-invite** template
2. Click **Test Template**
3. Fill in sample data:
   ```json
   {
     "CHURCH_NAME": "Grace Community Church",
     "MEMBER_FIRST_NAME": "John",
     "INVITE_URL": "https://shepherdsync.app/invite/abc123xyz",
     "INVITE_CODE": "ABC123",
     "EXPIRATION_DATE": "February 15, 2024",
     "CHURCH_LOGO_URL": ""
   }
   ```
4. Click **Send Test Email**
5. Check your inbox

### Test via API

```bash
# Start your backend server
npm run start:dev

# Send a test invite (replace with real member ID and org ID)
curl -X POST http://localhost:3000/api/v1/members/{member-id}/send-invite \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "method": "EMAIL"
  }'
```

Expected log output:
```
[EmailService] Member invite email sent to john@example.com (Code: ABC123)
```

---

## 5. Email Design Preview

The invite email includes:

✅ **Header:**
- Purple gradient background
- "You're Invited!" headline
- "Welcome to [Church Name]" subtitle

✅ **Content:**
- Personalized greeting: "Hi [FirstName],"
- Invitation message
- Big purple "Accept Invite & Get Started" button (links to deep link)

✅ **Manual Code Section:**
- Gray background box
- "Or enter this code in the app:"
- Large monospace code in dashed purple border: `ABC123`

✅ **Fallback Link:**
- Copy/paste link if button doesn't work
- Full URL displayed

✅ **Expiration Warning:**
- Yellow highlighted box
- "⏰ Important: This invite expires on [Date]"

✅ **Footer:**
- "Sent by [Church Name]"
- "Powered by Shepherd Sync"

---

## 6. Production Checklist

Before going live:

- [ ] Domain verified in Postmark
- [ ] DKIM and SPF records added to DNS
- [ ] `POSTMARK_API_KEY` set in production `.env`
- [ ] `POSTMARK_FROM_EMAIL` uses verified domain
- [ ] Template `member-invite` created with correct alias
- [ ] Test email received successfully
- [ ] Email renders correctly on:
  - [ ] Gmail (web + mobile)
  - [ ] Outlook (web + desktop)
  - [ ] Apple Mail (Mac + iPhone)
  - [ ] Yahoo Mail
- [ ] Deep link opens mobile app correctly
- [ ] Manual code is readable and copyable

---

## 7. Monitoring

### View Email Activity

1. In Postmark, go to **Activity**
2. Filter by template: `member-invite`
3. See delivery status, opens, clicks, bounces

### Handle Bounces

If emails bounce:

1. Check **Bounces** tab in Postmark
2. Common issues:
   - Invalid email address → Verify member email
   - Spam filter → Check SPF/DKIM setup
   - Suppression list → Remove email from suppressions

### Webhooks (Optional)

Set up Postmark webhooks to track:
- Email opens
- Link clicks
- Bounces
- Spam complaints

Configure webhook URL in Postmark:
```
POST https://api.shepherdsync.com/webhooks/postmark
```

---

## 8. Cost Estimate

Postmark Pricing:
- **Free tier**: 100 emails/month
- **Pay-as-you-go**: $1.25 per 1,000 emails
- **Monthly plans**: Start at $15/month for 10,000 emails

For a church sending 500 invites/month:
- **Cost**: ~$0.63/month or free tier

---

## 9. Troubleshooting

### Email Not Sending

**Check logs:**
```bash
# Look for this in backend logs:
[EmailService] Member invite email sent to ...
```

**If you see:**
```
[EmailService] Invite email not sent (Postmark not configured)
```

Fix:
1. Verify `POSTMARK_API_KEY` is set
2. Restart backend server
3. Check API key is valid in Postmark dashboard

### Template Not Found Error

```
Error: TemplateValidationError: Could not find template with alias 'member-invite'
```

Fix:
1. Go to Postmark Templates
2. Verify template alias is exactly: `member-invite` (case-sensitive)
3. Template must be in the same server as your API key

### Email Goes to Spam

Fix:
1. Add DKIM and SPF records (Postmark provides these)
2. Use verified domain for `POSTMARK_FROM_EMAIL`
3. Avoid spam trigger words in template
4. Test with [Mail Tester](https://www.mail-tester.com/)

---

## 10. Alternative: Development Mode (Without Postmark)

For local development without Postmark:

1. Leave `POSTMARK_API_KEY` unset
2. Backend will log email details instead of sending:
   ```
   [EmailService] Invite email not sent (Postmark not configured): john@example.com
   [EmailService] Would send to john@example.com with code: ABC123
   ```

This lets you develop and test without needing a Postmark account.

---

## 11. Next Steps

After email is working:

1. **Add SMS support**: Integrate Twilio for SMS invites
2. **Add WhatsApp**: Use WhatsApp Business API
3. **Email analytics**: Track open/click rates
4. **A/B testing**: Test different subject lines
5. **Automated reminders**: Send reminder emails for expired invites

---

## Support

- **Postmark Docs**: https://postmarkapp.com/developer
- **Postmark Support**: https://postmarkapp.com/support
- **Shepherd Sync Issues**: [GitHub Issues](https://github.com/yourorg/shepherd-sync/issues)

---

**Ready to send your first invite email!** 🚀
