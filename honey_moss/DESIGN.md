---
name: Honey & Moss
colors:
  surface: '#fff8f6'
  surface-dim: '#f9d1c8'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff0ed'
  surface-container: '#ffe9e4'
  surface-container-high: '#ffe2db'
  surface-container-highest: '#ffdad2'
  on-surface: '#2b1611'
  on-surface-variant: '#56423c'
  inverse-surface: '#432a25'
  inverse-on-surface: '#ffede9'
  outline: '#89726b'
  outline-variant: '#ddc0b8'
  surface-tint: '#9f4122'
  primary: '#9f4122'
  on-primary: '#ffffff'
  primary-container: '#ff8a65'
  on-primary-container: '#752305'
  inverse-primary: '#ffb59e'
  secondary: '#4a654f'
  on-secondary: '#ffffff'
  secondary-container: '#c9e7cc'
  on-secondary-container: '#4e6953'
  tertiary: '#735c00'
  on-tertiary: '#ffffff'
  tertiary-container: '#cca620'
  on-tertiary-container: '#4d3d00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd0'
  primary-fixed-dim: '#ffb59e'
  on-primary-fixed: '#3a0b00'
  on-primary-fixed-variant: '#7f2a0d'
  secondary-fixed: '#cceacf'
  secondary-fixed-dim: '#b0ceb4'
  on-secondary-fixed: '#062010'
  on-secondary-fixed-variant: '#334d38'
  tertiary-fixed: '#ffe087'
  tertiary-fixed-dim: '#ebc23e'
  on-tertiary-fixed: '#241a00'
  on-tertiary-fixed-variant: '#574500'
  background: '#fff8f6'
  on-background: '#2b1611'
  surface-variant: '#ffdad2'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 8px
  container-padding-desktop: 40px
  container-padding-mobile: 20px
  gutter: 24px
  stack-sm: 12px
  stack-md: 24px
  stack-lg: 48px
---

## Brand & Style

This design system extends a friendly, mascot-driven aesthetic into a "Magazine-style utility" framework. It balances the playful warmth of the "Bear" brand with the structured editorial clarity required for a recipe module. The emotional goal is to make home cooking feel accessible, cozy, and rewarding.

The style is **Premium Cute**, utilizing high-quality whitespace and soft depth to avoid feeling juvenile. It leans on tactile metaphors—think soft-touch paper and honey-smooth surfaces—to create an inviting digital kitchen companion. It prioritizes legibility and a calm, "slow-living" vibe over aggressive conversion metrics.

## Colors

The palette is anchored by a warm vanilla base that prevents the high-contrast fatigue of pure white. 

- **Primary (Terracotta):** Used for primary calls to action, active states, and "Start Cooking" buttons.
- **Secondary (Moss Green):** Represents freshness and health. Used for "Quick & Easy" tags and vegetarian indicators.
- **Tertiary (Honey Yellow):** Represents indulgence and warmth. Used for dessert categories, baking tips, and "Premium" recipe highlights.
- **Neutral (Cocoa):** Replaces pure black for typography and iconography to maintain the soft, organic feel of the brand.

## Typography

This design system uses **Plus Jakarta Sans** exclusively to maintain a modern, friendly, and geometric consistency. 

Editorial "Magazine" flair is achieved through dramatic scale differences rather than mixing typefaces. Use `display-lg` for recipe titles on hero headers to create a focal point. All labels should be uppercase with slight tracking to ensure they feel like distinct UI metadata rather than standard prose.

## Layout & Spacing

The layout follows a **Fluid Grid** model with generous margins to mimic the layout of a physical cookbook. 

- **Desktop:** 12-column grid with 40px outer margins. Content is often centered in a max-width container (1200px) to maintain readability for long-form instructions.
- **Mobile:** Single column with 20px margins. 
- **Rhythm:** Use a strict 8px baseline. Spacing between recipe steps should be wide (`stack-lg`) to allow users to follow along easily while cooking.

## Elevation & Depth

To achieve "Premium Cute," this design system avoids harsh shadows. Instead, it uses **Ambient Tonal Depth**:

- **Level 1 (Cards):** Very soft, wide-spread shadows (#4E342E at 5% opacity) with a 20px blur and 4px vertical offset.
- **Level 2 (Active/Modals):** Increased blur (40px) and a subtle inner glow on the top edge to simulate a slightly raised, physical card.
- **Backdrop:** Background blurs (12px) are used behind navigation bars to maintain the vanilla surface texture while scrolling over colorful recipe photography.

## Shapes

The shape language is **Ultra-Rounded**. 

Recipe cards use a `32px` corner radius to feel soft and approachable. Interactive elements like "Cook Now" buttons or category chips use a full pill-shape. Photography should always be clipped with the same corner radius as its container to maintain the "molded" 3D aesthetic seen in the brand mascot.

## Components

### Recipe Cards
Cards feature a full-bleed image at the top with a 32px radius. The content area below uses `title-md` for the name and a row of `label-sm` chips for time and difficulty.

### Category Chips
Pill-shaped backgrounds using 10% opacity of the accent colors (Moss for Healthy, Honey for Sweet). The text uses the full-saturation color for legibility.

### Step-by-Step Instructions
Large, Cocoa-colored numerals in `headline-lg`. Each step is housed in a "Surface" card to separate individual tasks clearly.

### Floating Action Button (FAB)
The "Start Cooking" or "Add to Grocery List" button is a large pill-shaped Terracotta button with a soft shadow, pinned to the bottom right on mobile.

### Iconography
Icons must have a minimum stroke weight of 2px with rounded terminals. Avoid sharp corners. Use specific cooking metaphors: a rounded whisk, a chubby chef's hat, and a soft-edged cookbook.