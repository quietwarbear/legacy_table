# Legacy Recipes - Flutter Mobile App Development Milestones

## Project Overview

**Project Name:** Legacy Recipes (formerly Legacy Tables Family Recipes)  
**Type:** Web-to-Mobile App Conversion  
**Platform:** iOS & Android  
**Framework:** Flutter  
**Backend:** FastAPI + MongoDB (Reuse existing)  
**Timeline:** 8-10 weeks (estimated)

---

## Executive Summary

This document outlines the development milestones for converting the existing React web application into a native Flutter mobile app for iOS and Android. The app is a private, family-only recipe sharing platform that preserves culinary traditions within a closed community.

**Key Objectives:**
- Convert React web app to native Flutter mobile app
- Maintain all existing functionality
- Reuse existing FastAPI backend (no backend changes required)
- Implement native mobile UX patterns and gestures
- Rebrand from "Legacy Tables Family Recipes" to "Legacy Recipes"
- Ensure App Store and Play Store compliance
- Maintain the warm, heritage-focused design aesthetic

---

## Current Architecture Analysis

### Frontend (Web - React)
- **Framework:** React 19
- **UI Library:** Shadcn/UI + Tailwind CSS
- **State Management:** React Context API
- **Routing:** React Router v7
- **HTTP Client:** Axios
- **PDF Generation:** jsPDF (client-side)
- **Icons:** Lucide React

### Backend (API - FastAPI)
- **Framework:** FastAPI (Python)
- **Database:** MongoDB
- **Authentication:** JWT tokens with bcrypt
- **CORS:** Configured for cross-origin requests

### Current Features
1. ✅ User Authentication (Register/Login/Logout)
2. ✅ JWT Token-based Security
3. ✅ Recipe CRUD Operations
4. ✅ Photo Upload (Gallery + Camera)
5. ✅ Category Filtering
6. ✅ Search Functionality
7. ✅ My Recipes (Profile Page)
8. ✅ Recipe Detail View
9. ✅ Edit Recipe
10. ✅ Family Cookbook PDF Export
11. ✅ Settings/Profile Management
12. ✅ Notifications System
13. ✅ Comments on Recipes
14. ✅ Responsive Design

### Current Pages/Screens
- Login/Register Page
- Home Page (Recipe Feed)
- Add Recipe Page
- Recipe Detail Page
- Edit Recipe Page
- Profile/My Recipes Page
- Settings Page
- Family Cookbook Page (PDF Export)

---

## Flutter App Architecture

### Technology Stack
- **Framework:** Flutter 3.x
- **State Management:** Provider or Riverpod
- **HTTP Client:** Dio or http package
- **Local Storage:** SharedPreferences + Hive
- **Image Handling:** image_picker, cached_network_image
- **PDF Generation:** pdf package or backend API
- **Navigation:** go_router or Navigator 2.0
- **UI Components:** Custom widgets matching design system

### Project Structure
```
lib/
├── main.dart
├── config/
│   ├── api_config.dart
│   └── theme_config.dart
├── models/
│   ├── user.dart
│   ├── recipe.dart
│   ├── comment.dart
│   └── notification.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── storage_service.dart
│   └── pdf_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── recipe_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── auth/
│   ├── home/
│   ├── recipe/
│   ├── profile/
│   └── settings/
├── widgets/
│   ├── common/
│   ├── recipe/
│   └── ui/
└── utils/
    ├── constants.dart
    └── helpers.dart
```

---

## Development Milestones

### **Milestone 1: Project Setup & Foundation** (Week 1)
**Duration:** 5-7 days  
**Status:** Foundation

#### Tasks:
1. **Flutter Project Initialization**
   - Create Flutter project with proper structure
   - Configure iOS and Android build settings
   - Set up versioning and app identifiers
   - Configure app icons and splash screens (placeholder)

2. **Dependencies Setup**
   - Add required packages (dio, provider/riverpod, shared_preferences, etc.)
   - Configure pubspec.yaml
   - Set up environment configuration

3. **API Integration Layer**
   - Create API service class
   - Implement base HTTP client with interceptors
   - Set up JWT token handling
   - Create API endpoints constants
   - Implement error handling

4. **Design System Implementation**
   - Create theme configuration matching "Spice & Linen" design
   - Define color palette (Terracotta, Sage, Linen)
   - Set up typography (Playfair Display equivalent, body font)
   - Create reusable UI components (buttons, cards, inputs)
   - Implement dark/light theme support

5. **State Management Setup**
   - Set up Provider/Riverpod architecture
   - Create base providers structure
   - Implement authentication state management

6. **Rebranding Assets**
   - Design new "Legacy Recipes" logo
   - Create app icons for iOS and Android
   - Design splash screen
   - Update branding throughout app

**Deliverables:**
- ✅ Flutter project structure
- ✅ API service layer functional
- ✅ Design system components
- ✅ Theme configuration
- ✅ New branding assets

---

### **Milestone 2: Authentication & User Management** (Week 2)
**Duration:** 5-7 days  
**Status:** Core Functionality

#### Tasks:
1. **Authentication Screens**
   - Login screen UI
   - Register screen UI
   - Form validation
   - Error handling and display

2. **Authentication Logic**
   - Implement login API integration
   - Implement register API integration
   - JWT token storage and management
   - Auto-login on app launch
   - Logout functionality

3. **User Profile Management**
   - Get current user API integration
   - Update profile API integration
   - Avatar upload handling
   - Nickname management

4. **Navigation & Route Protection**
   - Set up app routing
   - Implement protected routes
   - Auth state-based navigation
   - Deep linking setup

5. **Local Storage**
   - Token persistence
   - User data caching
   - Settings storage

**Deliverables:**
- ✅ Complete authentication flow
- ✅ User profile management
- ✅ Protected navigation
- ✅ Persistent login

---

### **Milestone 3: Recipe Feed & Discovery** (Week 3)
**Duration:** 5-7 days  
**Status:** Core Functionality

#### Tasks:
1. **Home Screen**
   - Recipe feed UI
   - Recipe card component
   - Pull-to-refresh
   - Infinite scroll/pagination
   - Loading states

2. **Recipe Models & Data Layer**
   - Recipe model implementation
   - API integration for fetching recipes
   - Caching strategy
   - State management for recipes

3. **Search & Filtering**
   - Search bar implementation
   - Real-time search
   - Category filtering
   - Author filtering
   - Search results UI

4. **Recipe Detail Screen**
   - Recipe detail page UI
   - Image gallery/carousel
   - Ingredients list
   - Instructions display
   - Story section
   - Meta information (time, servings, difficulty)

5. **Navigation**
   - Screen transitions
   - Back navigation
   - Deep linking to recipes

**Deliverables:**
- ✅ Recipe feed with all recipes
- ✅ Search and filter functionality
- ✅ Recipe detail view
- ✅ Smooth navigation

---

### **Milestone 4: Recipe Creation & Editing** (Week 4)
**Duration:** 5-7 days  
**Status:** Core Functionality

#### Tasks:
1. **Add Recipe Screen**
   - Multi-step form UI
   - Title input
   - Ingredients list (add/remove)
   - Instructions text area
   - Story text area
   - Category selection
   - Difficulty selection
   - Cooking time and servings inputs

2. **Photo Management**
   - Image picker integration (gallery)
   - Camera capture functionality
   - Image preview
   - Multiple image selection
   - Image removal
   - Base64 encoding for API

3. **Form Validation**
   - Required field validation
   - Input format validation
   - Error messages
   - Form state management

4. **API Integration**
   - Create recipe API call
   - Update recipe API call
   - Error handling
   - Success feedback

5. **Edit Recipe Screen**
   - Pre-populate form with existing data
   - Update functionality
   - Author verification
   - Delete recipe functionality

**Deliverables:**
- ✅ Complete recipe creation flow
- ✅ Photo upload (gallery + camera)
- ✅ Recipe editing
- ✅ Recipe deletion

---

### **Milestone 5: Profile & My Recipes** (Week 5)
**Duration:** 5-7 days  
**Status:** Core Functionality

#### Tasks:
1. **Profile Screen**
   - User profile display
   - Avatar display
   - Display name (nickname or name)
   - User stats

2. **My Recipes Screen**
   - List user's recipes
   - Filter by user
   - Recipe management
   - Edit/Delete actions

3. **Settings Screen**
   - Profile settings
   - Theme toggle (dark/light)
   - Logout option
   - App information

4. **Navigation Integration**
   - Profile access from navigation
   - Settings access
   - Edit profile flow

**Deliverables:**
- ✅ Profile page
- ✅ My Recipes page
- ✅ Settings page
- ✅ Profile editing

---

### **Milestone 6: Comments & Social Features** (Week 6)
**Duration:** 5-7 days  
**Status:** Enhanced Features

#### Tasks:
1. **Comments System**
   - Comments list UI
   - Add comment functionality
   - Delete comment (author only)
   - Comment display with author
   - Timestamp display

2. **Notifications System**
   - Notifications list
   - Unread count badge
   - Mark as read functionality
   - Mark all as read
   - Notification types handling

3. **UI/UX Enhancements**
   - Notification bell icon
   - Badge indicators
   - Toast notifications
   - Loading indicators

**Deliverables:**
- ✅ Comments on recipes
- ✅ Notifications system
- ✅ Real-time updates

---

### **Milestone 7: Family Cookbook & PDF Export** (Week 7)
**Duration:** 5-7 days  
**Status:** Advanced Features

#### Tasks:
1. **Cookbook Screen**
   - Recipe selection UI
   - Select all/deselect all
   - Recipe preview
   - Selection state management

2. **PDF Generation**
   - Option A: Client-side using `pdf` package
   - Option B: Backend API endpoint (recommended for better control)
   - Cover page generation
   - Table of contents
   - Recipe pages formatting
   - Image embedding
   - Styling matching web version

3. **PDF Export & Sharing**
   - Generate PDF
   - Save to device
   - Share functionality
   - Progress indicators
   - Error handling

4. **PDF Styling**
   - Match "Spice & Linen" design
   - Decorative borders
   - Color scheme
   - Typography
   - Layout consistency

**Deliverables:**
- ✅ Cookbook selection interface
- ✅ PDF generation (client or server)
- ✅ PDF export and sharing
- ✅ Styled PDF matching design

---

### **Milestone 8: Mobile-Specific Features** (Week 8)
**Duration:** 5-7 days  
**Status:** Mobile Optimization

#### Tasks:
1. **Native Mobile Features**
   - Push notifications setup (if needed)
   - App lifecycle handling
   - Background/foreground states
   - Network connectivity handling
   - Offline mode support (caching)

2. **Performance Optimization**
   - Image caching
   - Lazy loading
   - Memory management
   - Smooth animations
   - List optimization

3. **Platform-Specific Features**
   - iOS-specific UI adjustments
   - Android-specific UI adjustments
   - Platform-specific navigation patterns
   - Haptic feedback
   - Native sharing

4. **Permissions**
   - Camera permission handling
   - Gallery permission handling
   - Permission request flows
   - Permission denied handling

5. **Error Handling**
   - Network error handling
   - API error handling
   - User-friendly error messages
   - Retry mechanisms

**Deliverables:**
- ✅ Native mobile features
- ✅ Performance optimizations
- ✅ Platform-specific adjustments
- ✅ Permission handling

---

### **Milestone 9: Testing & Bug Fixes** (Week 9)
**Duration:** 5-7 days  
**Status:** Quality Assurance

#### Tasks:
1. **Functional Testing**
   - Test all user flows
   - Test authentication
   - Test recipe CRUD
   - Test PDF generation
   - Test edge cases

2. **Device Testing**
   - Test on multiple iOS devices
   - Test on multiple Android devices
   - Test different screen sizes
   - Test different OS versions

3. **Bug Fixes**
   - Fix identified bugs
   - Performance issues
   - UI/UX improvements
   - Edge case handling

4. **Code Quality**
   - Code review
   - Refactoring
   - Documentation
   - Clean up unused code

**Deliverables:**
- ✅ Tested app on multiple devices
- ✅ Bug fixes completed
- ✅ Code quality improvements

---

### **Milestone 10: App Store Preparation & Submission** (Week 10)
**Duration:** 5-7 days  
**Status:** Launch Preparation

#### Tasks:
1. **App Store Assets**
   - App Store screenshots (iOS)
   - Play Store screenshots (Android)
   - App description
   - Privacy policy
   - Terms of service
   - App icon finalization

2. **Build Configuration**
   - Production API endpoint
   - Release build configuration
   - Code signing (iOS)
   - Keystore setup (Android)
   - Version management

3. **App Store Compliance**
   - Privacy policy implementation
   - Data handling disclosure
   - App Store guidelines compliance
   - Play Store guidelines compliance

4. **Testing & Validation**
   - Final testing on production build
   - TestFlight (iOS) setup
   - Internal testing (Android)
   - Beta testing

5. **Submission**
   - iOS App Store submission
   - Google Play Store submission
   - Handle review feedback
   - Monitor submission status

**Deliverables:**
- ✅ App Store assets ready
- ✅ Production builds
- ✅ App Store submissions
- ✅ Ready for review

---

## Technical Considerations

### Backend Reuse
- **No Backend Changes Required:** The existing FastAPI backend will be used as-is
- **API Compatibility:** All existing endpoints are compatible with Flutter
- **Authentication:** JWT token flow remains the same
- **CORS:** May need adjustment for mobile app origins

### Design System Migration
- **Colors:** Maintain "Spice & Linen" palette
  - Terracotta: #E07B4C
  - Sage: #4A7A5E
  - Linen: #F8F5F1
- **Typography:** Use Google Fonts equivalents
  - Playfair Display for headings
  - Roboto/Inter for body text
- **Components:** Recreate Shadcn/UI components in Flutter
- **Logo:** New "Legacy Recipes" logo design

### PDF Generation Options

**Option 1: Client-Side (Flutter)**
- Use `pdf` package
- Generate PDF in app
- Pros: No server load, works offline
- Cons: Limited styling, larger app size

**Option 2: Backend API (Recommended)**
- Create FastAPI endpoint for PDF generation
- Use ReportLab or WeasyPrint
- Pros: Better control, consistent styling, smaller app
- Cons: Requires backend endpoint

**Recommendation:** Backend API for better control and consistency

### State Management
- **Provider or Riverpod:** Recommended for this project size
- **Local State:** For UI-only state
- **Global State:** For auth, recipes, user data

### Image Handling
- **Upload:** Base64 encoding (current approach)
- **Display:** Cached network images
- **Storage:** Consider cloud storage for production

### Offline Support
- **Caching:** Cache recipes locally
- **Offline Mode:** Show cached data when offline
- **Sync:** Sync when back online

---

## Risk Assessment & Mitigation

### Risks
1. **API Compatibility Issues**
   - **Risk:** Mobile app may need different API responses
   - **Mitigation:** Test API thoroughly, add mobile-specific endpoints if needed

2. **PDF Generation Complexity**
   - **Risk:** Client-side PDF may not match web version
   - **Mitigation:** Use backend API for PDF generation

3. **Image Upload Performance**
   - **Risk:** Large images may cause performance issues
   - **Mitigation:** Implement image compression before upload

4. **App Store Rejection**
   - **Risk:** App may be rejected for various reasons
   - **Mitigation:** Follow guidelines strictly, test thoroughly

5. **Design Consistency**
   - **Risk:** Mobile app may not match web design
   - **Mitigation:** Maintain design system, regular design reviews

---

## Success Criteria

### Functional Requirements
- ✅ All web app features work on mobile
- ✅ Authentication and authorization functional
- ✅ Recipe CRUD operations work
- ✅ PDF generation and export work
- ✅ Comments and notifications work
- ✅ Search and filtering work

### Non-Functional Requirements
- ✅ App loads in < 3 seconds
- ✅ Smooth 60fps animations
- ✅ Works on iOS 13+ and Android 8+
- ✅ Offline support for viewing cached recipes
- ✅ App Store and Play Store approval

### User Experience
- ✅ Intuitive navigation
- ✅ Native mobile feel
- ✅ Consistent design
- ✅ Smooth performance
- ✅ Clear error messages

---

## Timeline Summary

| Milestone | Duration | Week |
|-----------|----------|------|
| 1. Project Setup & Foundation | 5-7 days | Week 1 |
| 2. Authentication & User Management | 5-7 days | Week 2 |
| 3. Recipe Feed & Discovery | 5-7 days | Week 3 |
| 4. Recipe Creation & Editing | 5-7 days | Week 4 |
| 5. Profile & My Recipes | 5-7 days | Week 5 |
| 6. Comments & Social Features | 5-7 days | Week 6 |
| 7. Family Cookbook & PDF Export | 5-7 days | Week 7 |
| 8. Mobile-Specific Features | 5-7 days | Week 8 |
| 9. Testing & Bug Fixes | 5-7 days | Week 9 |
| 10. App Store Preparation & Submission | 5-7 days | Week 10 |

**Total Estimated Duration:** 8-10 weeks (50-70 working days)

---

## Deliverables

### Code Deliverables
- ✅ Flutter source code
- ✅ iOS and Android build configurations
- ✅ API integration layer
- ✅ Complete UI implementation
- ✅ State management setup
- ✅ Documentation

### Documentation Deliverables
- ✅ Technical documentation
- ✅ API integration guide
- ✅ Setup instructions
- ✅ Deployment guide
- ✅ User guide (optional)

### App Store Deliverables
- ✅ iOS App Store submission
- ✅ Google Play Store submission
- ✅ App Store assets
- ✅ Privacy policy
- ✅ Terms of service

---

## Post-Launch Considerations

### Future Enhancements
- Push notifications for new recipes
- Recipe favorites/bookmarks
- Recipe sharing outside family
- Recipe ratings
- Advanced search filters
- Recipe collections
- Meal planning features

### Maintenance
- Bug fixes
- Performance improvements
- Feature updates
- OS compatibility updates
- Security updates

---

## Notes

1. **Backend Compatibility:** The existing FastAPI backend will be used without modifications. All API endpoints are compatible with Flutter.

2. **Rebranding:** The app will be rebranded from "Legacy Tables Family Recipes" to "Legacy Recipes" with a new logo design.

3. **Closed Environment:** The app remains a private, family-only platform. No public discovery features will be added.

4. **Design Consistency:** The warm "Spice & Linen" design aesthetic will be maintained in the mobile app.

5. **PDF Generation:** Recommendation is to use backend API for better control and consistency with web version.

---

## Approval & Sign-off

This milestone document should be reviewed and approved before starting development.

**Prepared by:** Development Team  
**Date:** January 2025  
**Version:** 1.0

---

*This document is a living document and may be updated as the project progresses.*
