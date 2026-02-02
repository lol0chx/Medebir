# EasyShop Frontend Design System Reference

## Quick Reference Guide for Developers

### CSS Variables Available

#### Colors
```css
--primary-color: #2563eb;           /* Main action color - Blue */
--primary-dark: #1e40af;            /* Darker shade for hover */
--primary-light: #3b82f6;           /* Lighter shade for backgrounds */
--secondary-color: #10b981;         /* Success/Add actions */
--danger-color: #ef4444;            /* Destructive actions */
--success-color: #10b981;           /* Positive feedback */
--text-dark: #1f2937;               /* Main text */
--text-light: #6b7280;              /* Secondary text */
--bg-light: #f9fafb;                /* Light backgrounds */
```

#### Spacing Scale
```css
--spacing-xs: 0.25rem;      /* 4px */
--spacing-sm: 0.5rem;       /* 8px */
--spacing-md: 1rem;         /* 16px */
--spacing-lg: 1.5rem;       /* 24px */
--spacing-xl: 2rem;         /* 32px */
--spacing-2xl: 2.5rem;      /* 40px */
--spacing-3xl: 3rem;        /* 48px */
```

#### Typography
```css
--font-size-xs: 0.75rem;    /* 12px */
--font-size-sm: 0.875rem;   /* 14px */
--font-size-base: 1rem;     /* 16px */
--font-size-lg: 1.125rem;   /* 18px */
--font-size-xl: 1.25rem;    /* 20px */
--font-size-2xl: 1.5rem;    /* 24px */
--font-size-3xl: 1.875rem;  /* 30px */
```

#### Shadows
```css
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
--shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
```

---

## Component Classes

### Buttons
```html
<!-- Primary Button (Main actions) -->
<button class="btn btn-primary">Action</button>

<!-- Success Button (Confirmatory actions) -->
<button class="btn btn-success">Add to Cart</button>

<!-- Danger Button (Destructive actions) -->
<button class="btn btn-danger">Delete</button>

<!-- Secondary Button (Cancel/neutral) -->
<button class="btn btn-secondary">Cancel</button>

<!-- Outline Button (Less prominent) -->
<button class="btn btn-outline-danger">Remove</button>
```

### Cards & Containers
```html
<!-- Product Card -->
<div class="product">
    <h4>Product Name</h4>
    <div class="photo">
        <img src="..." alt="...">
    </div>
    <p>Description</p>
    <div class="price">$99.99</div>
    <div class="add-button">
        <button class="btn btn-success">Add to Cart</button>
    </div>
</div>

<!-- Cart Item -->
<div class="cart-item">
    <div class="photo"><img src="..." alt="..."></div>
    <div class="cart-item-details">
        <h4>Item Name</h4>
        <p>Description</p>
        <div class="cart-item-price">$99.99</div>
    </div>
    <div class="cart-item-actions">
        <!-- Quantity and remove controls -->
    </div>
</div>
```

### Forms
```html
<!-- Floating Label Form Input -->
<div class="form-floating mb-3">
    <input type="text" class="form-control" id="name" placeholder="Name">
    <label for="name">Name</label>
</div>

<!-- Select Dropdown -->
<select class="form-select">
    <option>Option 1</option>
</select>

<!-- Range Slider -->
<input type="range" class="form-range">
```

### Alerts
```html
<!-- Danger Alert -->
<div class="alert alert-danger">Error message</div>

<!-- Success Alert -->
<div class="alert alert-success">Success message</div>

<!-- Info Alert -->
<div class="alert alert-info">Info message</div>
```

---

## Layout Classes

### Main Layout
```html
<!-- Two-column layout (sidebar + content) -->
<main>
    <div class="filter-box"><!-- Sidebar content --></div>
    <div id="content" class="content"><!-- Main content --></div>
</main>

<!-- Full-width content -->
<div class="content-form"><!-- Form content --></div>
```

### Grid Systems
```css
/* Product Grid - Auto-responsive */
#content {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: var(--spacing-lg);
}

/* Responsive columns */
/* Desktop: 3 columns */
/* Tablet: 2 columns */
/* Mobile: 1 column */
```

---

## Modals
```html
<!-- Modal Structure -->
<div id="modal-name" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Title</h5>
                <button class="btn-close" onclick="hideModalForm()"></button>
            </div>
            <div class="modal-body">
                <!-- Content -->
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary">Cancel</button>
                <button class="btn btn-primary">Confirm</button>
            </div>
        </div>
    </div>
</div>
```

---

## Responsive Breakpoints

```css
/* Desktop (1024px and above) */
/* Default styles apply */

/* Tablet (768px - 1023px) */
@media (max-width: 1024px) { ... }

/* Small Tablet / Large Mobile (480px - 767px) */
@media (max-width: 768px) { ... }

/* Mobile (480px and below) */
@media (max-width: 480px) { ... }
```

---

## Icon Usage

Using Font Awesome 6.4.0:

```html
<!-- Home Icon -->
<i class="fas fa-home"></i>

<!-- User Icon -->
<i class="fas fa-user-circle"></i>

<!-- Cart Icon -->
<i class="fas fa-shopping-cart"></i>

<!-- Delete/Trash Icon -->
<i class="fas fa-trash"></i>

<!-- Plus Icon -->
<i class="fas fa-plus"></i>

<!-- Minus Icon -->
<i class="fas fa-minus"></i>

<!-- Check Icon (Success) -->
<i class="fas fa-check-circle"></i>

<!-- Warning Icon -->
<i class="fas fa-exclamation-circle"></i>

<!-- Filter Icon -->
<i class="fas fa-filter"></i>
```

**Common icon sizing:**
```html
<i class="fas fa-icon" style="margin-right: 0.5rem;"></i>  <!-- Small gap -->
<i class="fas fa-icon" style="margin-right: 0.75rem;"></i> <!-- Medium gap -->
<i class="fas fa-icon" style="margin-right: 1rem;"></i>    <!-- Large gap -->
```

---

## Common Patterns

### Hover Effects
```css
/* Button hover */
.btn:hover {
    transform: scale(1.02);
    transition: all var(--transition-base);
}

/* Card hover */
.product:hover {
    box-shadow: var(--shadow-lg);
    transform: translateY(-4px);
}

/* Link hover */
a:hover {
    color: var(--primary-color);
}
```

### Focus States
```css
input:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    outline: none;
}
```

### Active States
```css
button:active {
    transform: scale(0.98);
}
```

---

## Utility Classes

```css
.visible { display: block !important; }
.hidden { display: none !important; }
.text-center { text-align: center; }
.text-muted { color: var(--text-light); }
.mt-lg { margin-top: var(--spacing-lg); }
.mb-lg { margin-bottom: var(--spacing-lg); }
.pt-lg { padding-top: var(--spacing-lg); }
.pb-lg { padding-bottom: var(--spacing-lg); }
```

---

## Performance Tips

1. **Use CSS variables** for consistent theming
2. **Prefer CSS animations** over JavaScript
3. **Use GPU acceleration** with `transform` and `opacity`
4. **Avoid `position: absolute`** for layout (use flex/grid)
5. **Minimize DOM manipulation** in JavaScript
6. **Use event delegation** for dynamic content

---

## Accessibility Guidelines

- ✅ Use semantic HTML (`<button>`, `<label>`, `<nav>`)
- ✅ Provide `title` attributes on icons and interactive elements
- ✅ Ensure color contrast ratios meet WCAG AA (4.5:1 for text)
- ✅ Include both icon and text in buttons
- ✅ Use proper heading hierarchy (h1 > h2 > h3...)
- ✅ Test with keyboard navigation
- ✅ Include `alt` text for all images
- ✅ Use `aria-labels` where needed

---

## Future Enhancements

### Planned Features
- [ ] Dark mode (CSS variable theme override)
- [ ] Animation library integration
- [ ] Advanced form validation
- [ ] Search autocomplete
- [ ] Wishlist UI
- [ ] Product reviews section
- [ ] Admin dashboard
- [ ] Checkout page

### Customization Points
- `--primary-color` - Change main theme color
- `--font-family` - Change typography
- `--spacing-*` - Adjust all spacing globally
- Breakpoints - Modify responsive behavior

---

## Support & Questions

For questions about the design system or component usage, refer to:
1. CSS custom properties in `:root`
2. Responsive breakpoint comments
3. Component class examples above
4. Font Awesome icon documentation

**Note:** Never modify core CSS variables or breakpoints without testing across all pages and devices.
