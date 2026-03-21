# Legacy Recipes - Flutter App Conversion Project Summary

## Quick Reference

**Project:** Convert React Web App to Flutter Mobile App  
**Timeline:** 8-10 weeks  
**Platforms:** iOS & Android  
**Backend:** Reuse existing FastAPI (no changes)

---

## Current Application Overview

### Tech Stack (Web)
- **Frontend:** React 19 + Tailwind CSS + Shadcn/UI
- **Backend:** FastAPI (Python) + MongoDB
- **Auth:** JWT tokens
- **PDF:** jsPDF (client-side)

### Features (Web)
✅ Authentication (Register/Login)  
✅ Recipe CRUD  
✅ Photo upload (Gallery + Camera)  
✅ Search & Filter  
✅ Recipe Detail View  
✅ Edit Recipe  
✅ Profile/My Recipes  
✅ Settings  
✅ Family Cookbook PDF Export  
✅ Comments  
✅ Notifications  

### Pages/Screens (Web)
1. Login/Register
2. Home (Recipe Feed)
3. Add Recipe
4. Recipe Detail
5. Edit Recipe
6. Profile/My Recipes
7. Settings
8. Family Cookbook

---

## Flutter App Conversion Plan

### 10 Milestones (8-10 weeks)

| # | Milestone | Duration | Key Deliverables |
|---|-----------|----------|------------------|
| 1 | Project Setup & Foundation | Week 1 | Flutter structure, API layer, Design system, New branding |
| 2 | Authentication & User Management | Week 2 | Login/Register, Profile, Protected routes |
| 3 | Recipe Feed & Discovery | Week 3 | Home feed, Search, Filter, Recipe detail |
| 4 | Recipe Creation & Editing | Week 4 | Add/Edit recipe, Photo upload, Form validation |
| 5 | Profile & My Recipes | Week 5 | Profile page, My recipes, Settings |
| 6 | Comments & Social Features | Week 6 | Comments, Notifications |
| 7 | Family Cookbook & PDF Export | Week 7 | Cookbook selection, PDF generation |
| 8 | Mobile-Specific Features | Week 8 | Native features, Performance, Permissions |
| 9 | Testing & Bug Fixes | Week 9 | Testing, Bug fixes, Code quality |
| 10 | App Store Preparation | Week 10 | Assets, Builds, Submissions |

---

## Key Technical Decisions

### State Management
- **Choice:** Provider or Riverpod
- **Reason:** Suitable for project size, good documentation

### PDF Generation
- **Recommendation:** Backend API endpoint
- **Reason:** Better control, consistent styling, smaller app size
- **Alternative:** Client-side with `pdf` package

### Image Handling
- **Upload:** Base64 encoding (current approach)
- **Display:** Cached network images
- **Storage:** Consider cloud storage for production

### Design System
- **Colors:** Maintain "Spice & Linen" palette
- **Typography:** Google Fonts equivalents
- **Components:** Recreate Shadcn/UI in Flutter

---

## Rebranding Requirements

**Old Name:** Legacy Tables Family Recipes  
**New Name:** Legacy Recipes  
**Logo:** New design required  
**Branding:** Update throughout app

---

## API Endpoints (Reuse Existing)

### Authentication
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`
- `PUT /api/auth/profile`

### Recipes
- `GET /api/recipes` (with filters)
- `POST /api/recipes`
- `GET /api/recipes/{id}`
- `PUT /api/recipes/{id}`
- `DELETE /api/recipes/{id}`
- `GET /api/categories`

### Comments
- `POST /api/recipes/{id}/comments`
- `GET /api/recipes/{id}/comments`
- `DELETE /api/comments/{id}`

### Notifications
- `GET /api/notifications`
- `GET /api/notifications/unread-count`
- `PUT /api/notifications/{id}/read`
- `PUT /api/notifications/read-all`

---

## Success Criteria

### Functional
✅ All web features work on mobile  
✅ Authentication functional  
✅ Recipe CRUD works  
✅ PDF generation works  
✅ Comments & notifications work  

### Performance
✅ App loads in < 3 seconds  
✅ Smooth 60fps animations  
✅ Works on iOS 13+ and Android 8+  

### User Experience
✅ Native mobile feel  
✅ Intuitive navigation  
✅ Consistent design  

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| API compatibility | Test thoroughly, add mobile endpoints if needed |
| PDF generation | Use backend API for consistency |
| Image upload performance | Implement compression |
| App Store rejection | Follow guidelines, test thoroughly |
| Design consistency | Maintain design system, regular reviews |

---

## Post-Launch Enhancements (Future)

- Push notifications
- Recipe favorites/bookmarks
- Recipe sharing
- Recipe ratings
- Advanced search
- Recipe collections
- Meal planning

---

## Project Files

- **Detailed Milestones:** `FLUTTER_APP_MILESTONES.md`
- **API Collection:** `HTrecipes_API.postman_collection.json`
- **Backend Code:** `backend/server.py`
- **Frontend Code:** `frontend/src/App.js`

---

## Next Steps

1. ✅ Review milestone document
2. ⏳ Approve project plan
3. ⏳ Set up development environment
4. ⏳ Begin Milestone 1: Project Setup

---

**Status:** Ready for Development  
**Last Updated:** January 2025
