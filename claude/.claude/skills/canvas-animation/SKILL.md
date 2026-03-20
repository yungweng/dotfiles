---
name: canvas-animation
description: Build interactive canvas-based animations with pixel-art typography, spring physics, mouse/touch interaction, and idle animations. Use when asked to create animated backgrounds, letter grids, particle effects, or any interactive canvas component for React/Next.js sites.
argument-hint: [description of the animation]
---

# Interactive Canvas Animation Builder

Build production-quality, interactive canvas animations for React/Next.js projects. $ARGUMENTS

## Architecture

Every canvas animation component follows this structure:

```
1. Configuration constants (physics, sizing, colors)
2. Data definitions (fonts, shapes, patterns)
3. Pre-computation / caching layer
4. Tile/sprite baking (offscreen canvases at retina resolution)
5. React component with useEffect lifecycle:
   a. Layout computation (responsive sizing, DPR handling)
   b. State initialization (springs, positions, modes)
   c. Animation loop (requestAnimationFrame)
   d. Event listeners (pointer, touch, resize, theme)
   e. Cleanup
```

## Core Techniques

### Retina Canvas

Always render at device pixel ratio for crisp output:

```tsx
const dpr = window.devicePixelRatio || 1;
canvas.width = Math.round(rect.width * dpr);
canvas.height = Math.round(rect.height * dpr);
// Scale context, draw in CSS pixels
ctx.scale(dpr, dpr);
```

### Spring Physics

Use damped springs for natural, organic motion. Frame-relative dt for consistent behavior across refresh rates:

```tsx
const dt = Math.min((now - lastTime) / (1000 / 60), 3);

function springStep(pos, vel, target, tension, friction, dt) {
  const accel = tension * (target - pos) - friction * vel;
  vel += accel * dt;
  pos += vel * dt;
  return [pos, vel];
}
```

Good starting values:
- **Snappy**: tension 0.22, friction 0.45
- **Smooth**: tension 0.15, friction 0.4
- **Lazy**: tension 0.08, friction 0.35

### Tile Baking

Pre-render repeated shapes to offscreen canvases, then use `drawImage` for each instance. Much faster than drawing paths per frame:

```tsx
function bakeTile(size, color, drawFn) {
  const c = document.createElement("canvas");
  c.width = size; c.height = size;
  const ctx = c.getContext("2d")!;
  drawFn(ctx, size, color);
  return c;
}
// Bake at retina: Math.round(cellSize * dpr)
// Draw at CSS size: ctx.drawImage(tile, x, y, cellSize, cellSize)
```

### Mouse/Touch Interaction

Use window-level `pointermove` for mouse (works through layered content), parent-level touch events for mobile:

```tsx
// Mouse: window pointermove, check bounds manually
window.addEventListener("pointermove", (e) => {
  const rect = canvas.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;
  const inBounds = x >= 0 && x <= rect.width && y >= 0 && y <= rect.height;
  if (inBounds) { /* activate */ }
  else if (hovering) { /* deactivate ONCE */ }
});

// Touch: parent element events
section.addEventListener("touchstart", handler, { passive: true });
section.addEventListener("touchmove", handler, { passive: true });
section.addEventListener("touchend", handler);
```

### Idle Animation (Lissajous)

When not interacting, animate the focus point in a figure-8 pattern:

```tsx
const angle = (elapsed / PERIOD) * Math.PI * 2;
const idleX = (Math.sin(angle - Math.PI / 2) + 1) / 2;
const idleY = ((Math.sin(2 * angle) + 1) / 2) * (rows - 1);
// Lerp toward target: pos += (target - pos) * (1 - 0.75 ** dt)
```

### 2D Gaussian Height/Intensity Distribution

Drive visual intensity based on distance from a focus point:

```tsx
const sx = (itemX - focusX) / SIGMA_X;
const sy = (itemY - focusY) / SIGMA_Y;
const gaussian = Math.exp(-0.5 * (sx * sx + sy * sy));
const target = MIN + (MAX - MIN) * gaussian * blend;
```

### Pixel-Art Font System

Define letters as stretchable bitmaps with fixed caps and repeatable body rows:

```tsx
interface LetterDef {
  topCap: string[];      // Fixed top rows ("X" = filled, "." = empty)
  body: string;          // Repeated to fill height
  bottomCap: string[];   // Fixed bottom rows
  midBar?: string[];     // Optional middle section (for B, E, H, S, etc.)
  upperBody?: string;    // Override body for rows above midBar
}
```

Generate shadow cells adjacent to body cells at offsets [+1,0], [0,+1], [+1,+1].

### Theme Awareness

Watch for theme changes and rebake tiles:

```tsx
const observer = new MutationObserver(() => {
  color = getComputedStyle(el).getPropertyValue("--your-color").trim();
  // Rebake tiles with new color
});
observer.observe(document.documentElement, {
  attributes: true, attributeFilter: ["data-theme"]
});
```

## Blend & Mode System

Manage interaction intensity with a blend value (0 = idle, 1 = active):
- **Warmup**: Ramp tension gradually when hovering starts (prevents jarring snap)
- **Idle fade-in**: Use quadratic or quartic easing for gentle ambient effect
- **Overshoot**: Allow blend slightly >1 (e.g. max 1.35) for bouncy feel

## Performance Checklist

- [ ] Bake tiles to offscreen canvases (don't draw paths every frame)
- [ ] Cache generated patterns by key (e.g. `"${char}:${height}"`)
- [ ] Skip invisible cells (`if (alpha < 0.005) continue`)
- [ ] Use `Int8Array` / `Float32Array` for grid data
- [ ] Cap dt to prevent spiral-of-death (`Math.min(dt, 3)`)
- [ ] Use ResizeObserver (not window resize) for responsive layout
- [ ] Clean up everything in useEffect return (RAF, listeners, observers)

## Canvas Positioning

For background animations behind content:

```tsx
<section className="relative">
  <canvas className="absolute inset-0 w-full h-full pointer-events-none opacity-30"
          aria-hidden="true" tabIndex={-1} />
  {/* Content renders on top */}
</section>
```

## Reference Implementation

See `src/components/letter-grid.tsx` in the yannickwenger.de project for a complete example with all techniques above.
