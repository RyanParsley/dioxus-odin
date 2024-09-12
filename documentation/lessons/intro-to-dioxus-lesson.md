# Lesson 3: Introduction to Dioxus

## Objective
By the end of this lesson, you will understand what Dioxus is, its key features, and how to set up and create a basic Dioxus project.

## 1. What is Dioxus?
- Dioxus is a portable, performant, and ergonomic framework for building user interfaces in Rust
- It can be used for web, desktop, mobile, and TUI (Text User Interface) applications
- Inspired by React, but designed to leverage Rust's unique features

## 2. Key Features of Dioxus
- Component-based architecture
- Virtual DOM for efficient rendering
- Cross-platform support
- Strong typing and compile-time checks
- Server-side rendering capabilities
- WebAssembly support

## 3. Setting Up Dioxus
First, ensure you have Rust installed. Then, install the Dioxus CLI:

```sh
cargo install dioxus-cli
```

Create a new Dioxus project:

```sh
dioxus create my_dioxus_app
cd my_dioxus_app
```

## 4. Project Structure
A typical Dioxus project structure:

```
my_dioxus_app/
├── Cargo.toml
├── index.html
└── src/
    └── main.rs
```

## 5. Your First Dioxus Component
Open `src/main.rs` and replace its content with:

```rust
use dioxus::prelude::*;

fn main() {
    dioxus_web::launch(App);
}

fn App(cx: Scope) -> Element {
    cx.render(rsx! {
        div {
            h1 { "Hello, Dioxus!" }
            p { "Welcome to your first Dioxus application." }
        }
    })
}
```

## 6. Running Your Dioxus App
Run your app with:

```sh
dioxus serve
```

Visit `http://localhost:8080` in your browser to see your app.

## 7. Understanding the Dioxus Component
- Components are functions that take a `Scope` and return an `Element`
- The `rsx!` macro is used to write JSX-like syntax in Rust
- Elements are created using a declarative syntax similar to HTML

## 8. Adding Interactivity
Let's modify our `App` component to include a button that increments a counter:

```rust
use dioxus::prelude::*;

fn main() {
    dioxus_web::launch(App);
}

fn App(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);

    cx.render(rsx! {
        div {
            h1 { "Hello, Dioxus!" }
            p { "Welcome to your first Dioxus application." }
            p { "Count: {count}" }
            button {
                onclick: move |_| count += 1,
                "Increment"
            }
        }
    })
}
```

## 9. Dioxus Ecosystem
- dioxus-router: For handling routing in your application
- dioxus-free-css: For writing CSS in Rust
- dioxus-signals: For state management
- dioxus-std: A collection of standard components and hooks

## Practice Exercises
1. Modify the counter app to include a "Decrement" button.
2. Create a new component that displays a list of items.
3. Add a form to your app that allows users to add new items to the list.

## Next Steps
- Explore the Dioxus documentation: https://dioxuslabs.com/docs/
- Experiment with creating more complex components
- In the next lesson, we'll dive deeper into Dioxus components and their lifecycle
