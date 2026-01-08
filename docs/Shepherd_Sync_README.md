# Shepherd Sync – README (Product Overview + Feature Explanations)

**Version:** 1.0  
**Last Updated:** January 2026

---

## 📌 Introduction
**Shepherd Sync** is a cross-platform Church Management System that helps churches run operations more efficiently by integrating member engagement, donation tracking, attendance management, media sharing, and role-based administration tools. Designed for both web and mobile platforms, Shepherd Sync provides a unified experience for church leaders, staff, and members.

---

## 🎯 Objectives
- Seamless church operation across mobile and web
- Strengthen member engagement via media, announcements, and events
- Centralized attendance, donations, and reporting
- Scalable for multi-branch churches
- Support offline usage (especially for ushers)
- Enable SaaS-based monetisation with multi-tenant architecture and subscription tiers

---

## 🔑 Feature Overview with Purpose, Dependencies, and Interactions

### 👥 1. User & Role Management
**Purpose:** Define user access levels and control functionality visibility.
**Roles:** Super Admin, Admin, Pastor, Usher, Member, Parent
**Dependencies:** Auth system (Auth0/Firebase), Role-based Access Control
**Interactions:**
- Impacts access to every other feature
- Determines dashboard layout, media visibility, giving permissions

---

### 🔐 2. Authentication & Access Control
**Purpose:** Secure login with role-based access.
**Methods:** Email/Password, Google, Apple
**Dependencies:** Firebase Auth / Auth0, User Role Management
**Interactions:**
- Controls feature access on frontend (e.g., parents can't upload media)
- Integrates with login, registration, subscription, and event access

---

### 🖼️ 3. Media Gallery
**Purpose:** Share photos/videos from church life (events, sermons, children’s activities).
**Roles Involved:** Admins, Pastors (upload); Members, Parents (view)
**Dependencies:** Cloudinary for uploads; Role Access Control; Event Tags
**Interactions:**
- Events can be tagged with media
- Child media restricted to Parent access
- Notification module can alert users when new media is posted

---

### 💰 4. Giving Management
**Purpose:** Enable secure, categorized donation system.
**Donation Types:** Tithes, Offerings, Pastor Appreciation, Building Fund, etc.
**Roles:** Members (donate), Admins/Super Admins (view reports)
**Dependencies:** Stripe / Paystack; Auth system for logged-in users
**Interactions:**
- Summary stats shown in Admin dashboards
- Can be filtered in Analytics module
- Tied to user profiles for transaction history

---

### 🧍 5. Attendance Tracking
**Purpose:** Track service attendance by role and group (e.g., members, children).
**Check-In Methods:** QR Code, Manual (Usher)
**Offline Support:** Usher app caches data for sync when online
**Dependencies:** Local storage, Network status APIs, User role linkage
**Interactions:**
- Admins filter attendance by role or age group
- Parents track their children’s check-ins
- Used in Analytics reports and engagement graphs

---

### 📢 6. Communication & Announcements
**Purpose:** Send important updates and messages to the congregation
**Methods:** Push notifications, Email, SMS (via Twilio, optional)
**Roles:** Pastors and Admins (send); Members (receive)
**Dependencies:** Notification service (FCM, email service); User database
**Interactions:**
- Event and media uploads can trigger notifications
- Can be scheduled or recurring
- Integrated with the calendar/event system

---

### 🎫 7. Event Management
**Purpose:** Plan and manage registrations for church events
**Roles:** Admins (create/manage); Members (register); Parents (register children)
**Features:** QR codes for entry, linked media/gallery
**Dependencies:** Calendar system, QR code generation API, User role linkage
**Interactions:**
- Events may have media linked post-event
- Attendance and engagement tracking tied to events
- Notifications are triggered on registration or reminders

---

### 📊 8. Reporting & Analytics
**Purpose:** Give church leadership access to clear, downloadable metrics
**Features:** Graphs for giving, attendance, registrations
**Roles:** Admins, Super Admins
**Dependencies:** Attendance logs, Giving data, Event data
**Interactions:**
- Pulls from all major user actions (check-ins, donations, registration)
- Custom filters per role/date/event
- Downloadable as CSV/Excel

---

### 👶 9. Children & Teens Management
**Purpose:** Register and track participation of underage attendees via parent accounts
**Roles:** Parents (register, track); Admins (manage reports)
**Categories:** 0–12, 13–18, 19–25
**Dependencies:** Parent-child relational database, Attendance tracking, Role access
**Interactions:**
- Parents receive confirmations for attendance/events
- Children’s media only viewable by parents
- Analytics breakdown available per age group

---

### 💳 10. Subscription & Plans
**Purpose:** Manage paid access to Shepherd Sync for different churches
**Roles:** Admins (subscribe); Super Admins (set pricing)
**Payment Options:** Monthly / Yearly
**Dependencies:** Stripe / Paystack APIs; Admin Registration Flow
**Interactions:**
- Determines access to premium features (media, analytics)
- Auto-renewals trigger admin notifications
- Includes feature gating logic by tier
- Enables 14-day free trial system

---

### 🌗 11. Theme and Accessibility (Dark/Light Mode)
**Purpose:** Provide inclusive and accessible visual experience for all users
**Features:** Toggle for dark/light mode, scalable fonts, high-contrast UI
**Dependencies:** Tailwind CSS + system preferences
**Interactions:**
- User preferences stored per session/device
- Enhances UI/UX consistency across web and mobile

---

### 🏢 12. SaaS-Specific Enhancements
**12.1 Multi-Tenant Support**  
Support for multiple organisations (churches) under a single platform with tenant-based data separation using `org_id` logic or schema isolation.

**12.2 Feature Gating by Plan**  
Each subscription plan defines access to specific modules. For example:
- Basic: Core attendance, giving, events
- Pro: Analytics, children’s module, media uploads
- Premium: Multi-branch analytics, custom branding, priority support

**12.3 Internal Admin Dashboard**  
A back-office dashboard for the platform owner to:
- View registered churches
- Monitor activity & subscriptions
- Assist churches via impersonation or live support

**12.4 Onboarding Flows for Admins**  
Step-by-step setup experience:
- Welcome tour
- Set up first event, donation type, media category
- Dashboard tips/tooltips

**12.5 Free Trial & Referral System**  
- 14-day trial access to premium features
- Built-in referral tracking: 1 free month per successful referral

---

## ⚙️ Technology Stack

### Frontend
- **Mobile App:** Flutter (Dart)
- **Web Dashboard:** Next.js (React)
- **Styling:** Tailwind CSS + Radix UI

### Backend
- **API Server:** NestJS (TypeScript)
- **ORM:** Prisma
- **Database:** PostgreSQL
- **Authentication:** Auth0 or Firebase Auth
- **Real-Time:** WebSockets / Pusher

### Media & Hosting
- **Media Upload:** Cloudinary (images/videos)
- **CDN:** Cloudinary CDN / Cloudflare
- **Notifications:** Firebase Cloud Messaging (FCM)
- **CI/CD:** GitHub Actions
- **Deployment:** Vercel (Web), Render or AWS Beanstalk (API)

### Analytics
- **Web Usage:** Google Analytics 4
- **User Behavior:** Mixpanel or Amplitude

---

## 🧪 Future Enhancements
- AI-powered sermon transcription & summarisation
- Volunteer shift scheduling
- WhatsApp Business integration for messaging
- Auto facial blurring for uploaded images
- GraphQL API support

---

## ✅ Conclusion
**Shepherd Sync** empowers churches to operate smarter — not harder. From streamlined attendance and media sharing to giving insights and secure role-based access, it unifies pastoral care, administration, and digital engagement in a single system.

With its modular structure, scalable architecture, and thoughtful feature relationships, Shepherd Sync is designed for real-world growth and community-driven impact.

---

**Next Steps:**
- Use this README as your **source of truth** for product scope and architecture
- Define epics/sprints based on these modules
- Extend with wireframes, database schema, and API specifications for dev handoff

