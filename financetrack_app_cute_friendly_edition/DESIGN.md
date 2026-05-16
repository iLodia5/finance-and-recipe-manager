---
name: FinanceTrack App (Cute & Friendly Edition)
colors:
  surface: '#fff8f6'
  surface-dim: '#fbd1c4'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1ed'
  surface-container: '#ffe9e3'
  surface-container-high: '#ffe2da'
  surface-container-highest: '#ffdbd0'
  on-surface: '#2c160e'
  on-surface-variant: '#56423c'
  inverse-surface: '#442a22'
  inverse-on-surface: '#ffede8'
  outline: '#89726b'
  outline-variant: '#ddc0b8'
  surface-tint: '#9f4122'
  primary: '#9f4122'
  on-primary: '#ffffff'
  primary-container: '#ff8a65'
  on-primary-container: '#752305'
  inverse-primary: '#ffb59e'
  secondary: '#3c6842'
  on-secondary: '#ffffff'
  secondary-container: '#bdefbe'
  on-secondary-container: '#426e47'
  tertiary: '#665e41'
  on-tertiary: '#ffffff'
  tertiary-container: '#b4aa88'
  on-tertiary-container: '#453f24'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd0'
  primary-fixed-dim: '#ffb59e'
  on-primary-fixed: '#3a0b00'
  on-primary-fixed-variant: '#7f2a0d'
  secondary-fixed: '#bdefbe'
  secondary-fixed-dim: '#a2d3a4'
  on-secondary-fixed: '#002109'
  on-secondary-fixed-variant: '#24502c'
  tertiary-fixed: '#eee2bd'
  tertiary-fixed-dim: '#d1c6a2'
  on-tertiary-fixed: '#211b05'
  on-tertiary-fixed-variant: '#4e472b'
  background: '#fff8f6'
  on-background: '#2c160e'
  surface-variant: '#ffdbd0'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '500'
    lineHeight: '1.6'
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: '1.6'
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: '1.4'
    letterSpacing: 0.02em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

The design system is built on the philosophy of "Emotional Finance"—transforming the often-stressful task of money tracking into a soothing, reflective, and delightful experience. It adopts a **Tactile and Illustrated** style, blending the charm of a physical stationery journal with the efficiency of a modern digital tool.

The brand personality is empathetic, encouraging, and playful. It prioritizes emotional resonance over corporate efficiency, aiming to evoke a sense of "Cozy Productivity." This is achieved through the use of a friendly mascot—a soft, round bear or cat—who guides the user through their financial journey as a supportive companion rather than a strict accountant.

## Colors

The palette is intentionally warm and low-contrast to prevent visual fatigue and reduce "financial anxiety."

- **Primary (Soft Coral):** Used for main actions, highlights, and primary buttons. It provides warmth without the aggression of a standard red.
- **Secondary (Mint Green):** Used for positive financial trends, savings goals, and success states. It feels natural and organic.
- **Backgrounds (Vanilla/Creme):** Two-tone creme layering creates a "paper-on-paper" look.
- **Typography & Icons (Warm Brown):** Replaces harsh black to maintain the "illustrated journal" aesthetic. This brown provides high legibility while remaining soft.

## Typography

The design system utilizes **Plus Jakarta Sans** for all levels of hierarchy. This font was selected for its generous x-height and distinctive rounded terminals, which mirror the soft edges of the UI components.

Typography should be treated with generous line-heights to ensure the interface feels "airy" and approachable. Headlines are kept bold to maintain a clear hierarchy against the soft background colors.

## Layout & Spacing

The layout follows a **Fluid Grid** model with high-density margins. Elements are given significant breathing room to prevent the interface from feeling cluttered or overwhelming.

- **Margins:** A standard 24px container margin ensures content is centered and cozy.
- **Plump Padding:** Inner component padding is intentionally oversized to give buttons and cards a "squishy" and accessible feel.
- **Visual Rhythm:** Vertical stacks use 16px or 32px increments to maintain a rhythmic, journal-like flow down the page.

## Elevation & Depth

Depth in this design system is conveyed through **Tonal Layering and Tinted Shadows**. Instead of using grey/black shadows, the system uses "Warm Shadows"—soft blurs with a #5D4037 color at 8-12% opacity.

- **Level 1 (Base):** The #FFF9E5 canvas.
- **Level 2 (Cards):** Surfaces in #FEF2CC or pure white with a subtle 4px blur shadow.
- **Level 3 (Interactive):** Floating Action Buttons (FABs) and active modals, using a larger 12px blur shadow to invite touch.
- **Layering:** Elements should appear to be "stacked paper" rather than objects in 3D space.

## Shapes

The shape language is strictly **Extremely Rounded**. There are no sharp 90-degree corners in the design system.

- **Primary Radius:** 24px for standard cards and containers.
- **Large Radius:** 32px+ for major surface areas and decorative header backgrounds.
- **Pill-Shape:** Used for buttons, tags, and chips to emphasize the friendly, non-threatening nature of the UI.

## Components

### Buttons
Buttons are high-contrast "lozenges." The primary button uses the Coral accent with white or dark brown text. They should have a slight "chunky" appearance, achieved by using a 2px-3px bottom border in a slightly darker shade of the button color to simulate a physical button press.

### Cards
Cards are the primary container. They utilize the 24px border radius and often feature a "header mascot" peek-a-boo effect where the cat or bear mascot rests on the top edge of the card.

### Input Fields
Inputs should feel like writing in a notebook. They use a soft creme background (#FEF2CC) and a thick, rounded 2px stroke when focused, using the Coral accent color.

### Icons
Custom icons are monoline but with very thick strokes (2px minimum) and perfectly rounded caps. They should be drawn with a slight "hand-drawn" imperfection—nothing too clinical or geometric.

### Empty States & Mascots
The mascot (Cat or Bear) is a core component. For empty states, the mascot should appear in a cozy scene (e.g., sleeping in an empty wallet or reading a book) to make "zero data" feel like a moment of peace rather than a failure.