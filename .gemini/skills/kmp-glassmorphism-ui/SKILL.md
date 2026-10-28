---
name: kmp-glassmorphism-ui
description: >
  Production-grade Glassmorphism design system adapted from Aks-4125/kmp-glassmorphism-skill
  for AgroGest (Jakarta EE / JSP / CSS3). Implements LiquidBackground, GlassTheme tokens,
  GlassSurface, GlassCard (radial glow + 3-stop shimmer border), GlassButton, GlassTextField,
  GlassDropdown, and Floating Pill GlassSidebar.
version: 1.0.0
---

# Glassmorphism UI Design System (AgroGest Web Adaptation)

## Architecture & Component Mapping

1. **Theme System (`GlassTheme`)**:
   - Atmospheric dark charcoal-bronze base (`#1b1719` to `#2c2527`) with vibrant accent tokens:
     - Primary Lime/Emerald (`#a3e635` / `#4ade80`)
     - Secondary Warm Amber (`#f59e0b`)
     - Info Cyan (`#38bdf8`)
     - Coral/Alert (`#fb7185`)
2. **Background Layer (`LiquidBackground`)**:
   - Ambient radial gradient blobs positioned beneath all translucent surfaces.
3. **Primitive Components**:
   - `GlassSurface` (`.painel`, `.glass-surface`): Semi-transparent surface (`alpha: 0.5` equivalent via `rgba(255, 255, 255, 0.06)` + `backdrop-filter: blur(24px)`) with 1px gradient border stroke.
   - `GlassCard` (`.card`, `.stat`, `.produto`, `.hero-bento`): Premium card with radial top-left white glow + 3-stop shimmer border (`rgba(255,255,255,0.22)` -> `rgba(255,255,255,0.06)` -> `rgba(255,255,255,0.16)`).
4. **Input & Navigation Components**:
   - `GlassTextField`: Translucent pill/rounded input with subtle border and focus glow.
   - `GlassButton`: Pill-shaped button (`border-radius: 999px`) with hover elevation.
   - `GlassSidebar`: Floating black pill navigation rail (`#0a0a0d`, `border-radius: 28px`) with active icon/pill states.

