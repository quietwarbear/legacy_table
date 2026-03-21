# Font Styles Guide - Legacy Tables Family Recipes App

This document lists all font styles used throughout the application and where they are applied.

---

## Font Families Used

### 1. **Playfair Display** (Serif)
- **Type**: Serif font
- **Usage**: All headings (H1, H2, H3, H4, H5, H6)
- **Weights**: 400 (Regular), 600 (Semi-bold), 700 (Bold)
- **Styles**: Regular, Italic
- **Fallback**: `serif`

### 2. **Manrope** (Sans-serif)
- **Type**: Sans-serif font
- **Usage**: Body text, buttons, forms, UI elements
- **Weights**: 400 (Regular), 500 (Medium), 600 (Semi-bold), 700 (Bold)
- **Fallback**: `sans-serif`

### 3. **Dancing Script** (Script/Handwriting)
- **Type**: Script/Handwriting font
- **Usage**: Logo text, brand name, decorative elements
- **Weights**: 400 (Regular), 500 (Medium), 600 (Semi-bold), 700 (Bold)
- **Fallback**: `cursive`

### 4. **Cormorant Garamond** (Serif)
- **Type**: Serif font (loaded but not actively used)
- **Weights**: 400, 600, 700 (Regular, Italic)
- **Status**: Available but not currently used in the app

### 5. **Arial** (Sans-serif)
- **Type**: System sans-serif
- **Usage**: SVG subtitle text (fallback)
- **Fallback**: `sans-serif`

---

## Font Usage by Text Type

### **Headings (H1, H2, H3, H4, H5, H6)**
- **Font**: `Playfair Display`
- **Fallback**: `serif`
- **Applied via**: CSS `@layer base` rule (automatic for all headings)
- **Examples**:
  - Page titles: "Legacy Tables Family", "Share a Recipe", "Edit Recipe"
  - Section headings: "Instructions", "Ingredients", "Family Cookbook"
  - Recipe card titles
  - Profile page headings

**Specific Usage:**
- **H1**: `font-serif text-3xl md:text-4xl font-bold` (Page titles)
- **H2**: `font-serif text-2xl font-semibold` (Section headings)
- **H3**: `font-serif text-xl font-semibold` (Subsection headings, recipe titles)

### **Body Text**
- **Font**: `Manrope`
- **Fallback**: `sans-serif`
- **Applied via**: CSS `body` rule (default for all text)
- **Examples**:
  - Paragraph text
  - Recipe instructions
  - Recipe descriptions
  - Form labels
  - Button text (secondary buttons)
  - Navigation links
  - Comments
  - User names

**Specific Usage:**
- **Body Large**: `text-lg leading-relaxed font-sans`
- **Body Base**: `text-base leading-relaxed font-sans text-muted-foreground`
- **Caption**: `text-sm font-medium tracking-wide uppercase text-muted-foreground`

### **Brand Name / Logo Text**
- **Font**: `Dancing Script`
- **Fallback**: `cursive`
- **Usage**: 
  - "Legacy Tables" text in logo component
  - HT monogram text inside logo icon
  - Brand identity elements

**Specific Usage:**
- Logo component: `fontFamily: "'Dancing Script', cursive"`
- SVG logo text: `font-family="'Dancing Script', cursive"`
- Font size: 26px (monogram), 48px (brand name)

### **Primary Buttons**
- **Font**: `Playfair Display` (serif)
- **Usage**: Main action buttons (Save, Submit, Add Recipe)
- **Classes**: `font-serif text-lg`
- **Examples**:
  - "Save Recipe" button
  - "Add Recipe" button
  - "Generate PDF" button
  - Login/Register submit buttons

### **Secondary Buttons**
- **Font**: `Manrope` (sans-serif)
- **Usage**: Secondary actions, outline buttons
- **Classes**: `font-sans`
- **Examples**:
  - "Cancel" buttons
  - Outline buttons
  - Ghost buttons

### **Form Labels**
- **Font**: `Manrope` (sans-serif)
- **Style**: `text-sm font-semibold uppercase tracking-wider text-muted-foreground`
- **Examples**:
  - "Recipe Title *"
  - "Email"
  - "Password"
  - "Cooking Time (minutes)"

### **Input Fields**
- **Font**: `Manrope` (sans-serif)
- **Style**: Inherits from body
- **Size**: `text-lg` (large inputs)

### **Navigation**
- **Font**: `Manrope` (sans-serif)
- **Usage**: Navigation links, menu items
- **Style**: `text-sm font-medium`

### **Subtitle / Secondary Text**
- **Font**: `Arial` (in SVG), `Manrope` (in app)
- **Usage**: 
  - "Family Recipes" subtitle in logo
  - Small descriptive text
  - Muted text
- **Style**: `text-xs uppercase tracking-widest text-muted-foreground font-medium`

### **Recipe Card Titles**
- **Font**: `Playfair Display`
- **Style**: `font-serif text-xl font-semibold`
- **Usage**: Recipe titles on cards

### **Recipe Details**
- **Font**: `Playfair Display` (headings), `Manrope` (body)
- **Usage**:
  - Recipe title: `font-serif text-3xl md:text-4xl font-bold`
  - Section headings: `font-serif text-2xl font-semibold`
  - Instructions/Ingredients: `Manrope` (body text)

### **Comments**
- **Font**: `Manrope` (sans-serif)
- **Usage**: User comments on recipes
- **Style**: Inherits body text styling

### **Badges / Tags**
- **Font**: `Manrope` (sans-serif)
- **Usage**: Category badges, difficulty tags
- **Style**: `text-sm font-medium`

### **Empty States**
- **Font**: `Playfair Display` (headings), `Manrope` (body)
- **Examples**:
  - "No recipes yet" heading: `font-serif text-2xl font-semibold`
  - Descriptive text: `Manrope` (body)

---

## Font Loading

All fonts are loaded from Google Fonts via:
```css
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=Manrope:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Dancing+Script:wght@400;500;600;700&display=swap');
```

**Fonts loaded:**
- Cormorant Garamond: 400, 600, 700 (Regular & Italic)
- Manrope: 400, 500, 600, 700
- Playfair Display: 400, 600, 700 (Regular & Italic)
- Dancing Script: 400, 500, 600, 700

---

## CSS Font Rules

### Base Styles (from `index.css`):
```css
body {
    font-family: 'Manrope', sans-serif;
}

h1, h2, h3, h4, h5, h6 {
    font-family: 'Playfair Display', serif;
}
```

### Tailwind Classes:
- `font-serif` → Uses Playfair Display (via CSS rule)
- `font-sans` → Uses Manrope (via CSS rule)
- `font-mono` → Uses JetBrains Mono (defined but not loaded)

---

## SVG Files Font Usage

### `app-icon.svg`
- **HT Monogram**: `'Dancing Script', cursive` (26px, bold)

### `app-name.svg`
- **Main Name**: `'Dancing Script', cursive, serif` (48px, bold)
- **Subtitle**: `Arial, sans-serif` (14px, medium, uppercase)

### `app-logo-complete.svg`
- **HT Monogram**: `'Dancing Script', cursive` (26px, bold)
- **Brand Name**: `'Dancing Script', cursive` (48px, bold)
- **Subtitle**: `Arial, sans-serif` (14px, medium, uppercase)

---

## Summary Table

| Text Type | Font Family | Weight | Size | Usage |
|-----------|------------|--------|------|-------|
| Page Titles (H1) | Playfair Display | Bold (700) | 3xl-4xl | Main page headings |
| Section Headings (H2) | Playfair Display | Semi-bold (600) | 2xl | Section titles |
| Subsection (H3) | Playfair Display | Semi-bold (600) | xl | Recipe titles, subsections |
| Body Text | Manrope | Regular (400) | base-lg | Paragraphs, descriptions |
| Body Text (muted) | Manrope | Regular (400) | base | Secondary text |
| Captions | Manrope | Medium (500) | sm | Small labels, captions |
| Brand Name | Dancing Script | Bold (700) | 48px | Logo text |
| Logo Monogram | Dancing Script | Bold (700) | 26px | HT initials |
| Primary Buttons | Playfair Display | Bold (700) | lg | Main action buttons |
| Secondary Buttons | Manrope | Medium (500) | base | Secondary actions |
| Form Labels | Manrope | Semi-bold (600) | sm | Input labels |
| Navigation | Manrope | Medium (500) | sm | Nav links |
| Badges/Tags | Manrope | Medium (500) | sm | Category tags |

---

## Design Guidelines

According to `design_guidelines.json`:

- **Headings**: Always use `Playfair Display` (serif)
- **Body**: Always use `Manrope` (sans-serif)
- **Brand/Logo**: Use `Dancing Script` for "Legacy Tables" text
- **DO NOT** use 'Inter' for headings (use Playfair Display instead)

---

## Notes

1. **Cormorant Garamond** is loaded but not currently used in the application
2. **JetBrains Mono** is defined in design guidelines but not loaded
3. All fonts have proper fallbacks (serif, sans-serif, cursive)
4. Font weights are optimized for readability and visual hierarchy
5. The serif/sans-serif combination creates a warm, heritage-focused aesthetic
