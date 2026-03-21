# Icons Directory

This directory contains all the SVG icons used in the Legacy Table Family Recipes application.

## Source

All icons are extracted from the **Lucide React** icon library (v0.507.0) used in the frontend.

## Icon List

### Navigation & UI Icons
- **Home.svg** - Home page navigation
- **Menu.svg** - Mobile menu toggle
- **X.svg** - Close button
- **Search.svg** - Search functionality
- **Settings.svg** - Settings/configuration
- **Bell.svg** - Notifications
- **User.svg** - User profile
- **Users.svg** - Multiple users/family members

### Recipe & Cooking Icons
- **ChefHat.svg** - Chef/recipe icon
- **Utensils.svg** - Cooking utensils
- **Camera.svg** - Photo capture
- **Flame.svg** - Difficulty level (hot/spicy)
- **Clock.svg** - Cooking time
- **BookOpen.svg** - Recipe book/cookbook

### Actions & Controls
- **Plus.svg** - Add/create action
- **Edit.svg** - Edit action
- **Trash2.svg** - Delete action
- **Download.svg** - Download/export
- **Upload.svg** - Upload action
- **Send.svg** - Send/submit
- **Check.svg** - Confirm/checkmark
- **Minus.svg** - Remove/decrease

### Communication
- **MessageCircle.svg** - Comments/messages
- **Heart.svg** - Like/favorite

### Theme & Display
- **Sun.svg** - Light mode
- **Moon.svg** - Dark mode

### Navigation Arrows
- **ChevronDown.svg** - Dropdown indicator
- **ChevronUp.svg** - Collapse indicator
- **ChevronLeft.svg** - Previous/back
- **ChevronRight.svg** - Next/forward

### UI Elements
- **MoreHorizontal.svg** - More options (ellipsis)
- **Circle.svg** - Circle indicator
- **LogOut.svg** - Logout action

## Total Icons: 33

## Usage

All icons are in SVG format with:
- **ViewBox**: `0 0 24 24`
- **Stroke**: `currentColor` (inherits text color)
- **Stroke Width**: `2`
- **Fill**: `none`
- **Line Cap**: `round`
- **Line Join**: `round`

## Integration

These icons can be used:
1. **Directly in HTML/SVG**: Import as `<img>` or inline SVG
2. **In React**: Import and use as components
3. **In Flutter**: Convert to Flutter-compatible format
4. **In Design Tools**: Import into Figma, Sketch, etc.

## Customization

To change icon color, modify the `stroke` attribute or use CSS:
```css
.icon {
  color: #your-color;
}
```

Since icons use `stroke="currentColor"`, they will inherit the text color from their parent element.

## License

Icons are from Lucide (ISC License) - https://lucide.dev
