# Lesson 5: Styling in Dioxus with CSS-in-Rust

## Objective
By the end of this lesson, you will understand how to style Dioxus components using CSS-in-Rust with dioxus-free-css, and learn about other styling options in Dioxus.

## 1. Introduction to CSS-in-Rust
CSS-in-Rust allows you to write CSS directly in your Rust code, providing type safety and integration with your component logic.

## 2. Setting up dioxus-free-css
First, add dioxus-free-css to your `Cargo.toml`:

```toml
[dependencies]
dioxus = "0.5.0"
dioxus-free-css = "0.5.0"
```

## 3. Basic Usage of dioxus-free-css
Here's how to create and apply styles:

```rust
use dioxus::prelude::*;
use dioxus_free_css::{css, Style};

fn StyledComponent(cx: Scope) -> Element {
    let style = css!(
        "
        .container {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 5px;
        }
        .title {
            color: #333;
            font-size: 24px;
        }
        "
    );

    cx.render(rsx! {
        Style { css: style }
        div { class: "container",
            h1 { class: "title", "Styled Component" }
            p { "This component is styled using CSS-in-Rust." }
        }
    })
}
```

## 4. Dynamic Styling
You can use Rust variables in your CSS:

```rust
fn DynamicStyledComponent(cx: Scope) -> Element {
    let bg_color = use_state(cx, || "#f0f0f0");

    let style = css!(
        "
        .container {{
            background-color: {bg_color};
            padding: 20px;
            border-radius: 5px;
        }}
        "
    );

    cx.render(rsx! {
        Style { css: style }
        div { class: "container",
            h1 { "Dynamic Styled Component" }
            button { 
                onclick: move |_| bg_color.set("#e0e0e0"),
                "Change Background"
            }
        }
    })
}
```

## 5. Scoped Styles
dioxus-free-css automatically scopes your styles to prevent conflicts:

```rust
fn ScopedStyleComponent(cx: Scope) -> Element {
    let style = css!(
        "
        .button {
            background-color: blue;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
        }
        "
    );

    cx.render(rsx! {
        Style { css: style }
        button { class: "button", "Scoped Button" }
    })
}
```

## 6. Media Queries and Responsive Design
You can use media queries for responsive design:

```rust
fn ResponsiveComponent(cx: Scope) -> Element {
    let style = css!(
        "
        .container {
            padding: 20px;
        }
        @media (max-width: 600px) {
            .container {
                padding: 10px;
            }
        }
        "
    );

    cx.render(rsx! {
        Style { css: style }
        div { class: "container",
            h1 { "Responsive Component" }
            p { "This component adapts to screen size." }
        }
    })
}
```

## 7. Global Styles
You can define global styles that apply to your entire application:

```rust
fn App(cx: Scope) -> Element {
    let global_style = css!(
        "
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
        }
        "
    );

    cx.render(rsx! {
        Style { css: global_style }
        div {
            h1 { "My Dioxus App" }
            p { "This app has global styles applied." }
        }
    })
}
```

## 8. Other Styling Options in Dioxus
- Inline styles: Use the `style` attribute directly in your RSX
- External CSS: Link to external CSS files in your `index.html`
- CSS Modules: Use the `dioxus-css-modules` crate for CSS module support

## Practice Exercises
1. Create a `Card` component with styles for a title, content, and a hover effect.
2. Implement a responsive navigation bar that collapses into a hamburger menu on small screens.
3. Style a form with input fields, labels, and a submit button using CSS-in-Rust.

## Next Steps
- Experiment with more complex CSS layouts and animations in Dioxus
- Explore CSS frameworks and how to integrate them with Dioxus
- In the next lesson, we'll cover routing in Dioxus applications
