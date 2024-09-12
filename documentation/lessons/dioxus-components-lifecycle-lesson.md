# Lesson 4: Dioxus Components and Lifecycle

## Objective
By the end of this lesson, you will have a deep understanding of Dioxus components, their lifecycle, and how to manage component state effectively.

## 1. Component Basics Review
- Components are functions that take a `Scope` and return an `Element`
- They use the `rsx!` macro for declarative UI description

```rust
fn MyComponent(cx: Scope) -> Element {
    cx.render(rsx! {
        div { "Hello from MyComponent" }
    })
}
```

## 2. Props in Dioxus
Props allow passing data to child components:

```rust
#[derive(Props, PartialEq)]
struct GreetingProps {
    name: String,
}

fn Greeting(cx: Scope<GreetingProps>) -> Element {
    cx.render(rsx! {
        div { "Hello, {cx.props.name}!" }
    })
}

fn App(cx: Scope) -> Element {
    cx.render(rsx! {
        Greeting { name: "Alice".to_string() }
    })
}
```

## 3. Component State
Use `use_state` hook for local component state:

```rust
fn Counter(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);
    
    cx.render(rsx! {
        div {
            p { "Count: {count}" }
            button { onclick: move |_| count += 1, "Increment" }
        }
    })
}
```

## 4. Lifecycle Methods
Dioxus uses hooks for lifecycle management:

- `use_effect`: Run side effects after render
- `use_effect_with_deps`: Run effects when dependencies change

```rust
use dioxus::prelude::*;

fn DataFetcher(cx: Scope) -> Element {
    let data = use_state(cx, String::new);

    use_effect(cx, (), |_| {
        to_owned![data];
        async move {
            // Simulating an API call
            let fetched_data = "Fetched data".to_string();
            data.set(fetched_data);
        }
    });

    cx.render(rsx! {
        div {
            "Data: {data}"
        }
    })
}
```

## 5. Conditional Rendering
Use Rust's control flow for conditional rendering:

```rust
fn ConditionalComponent(cx: Scope) -> Element {
    let show_message = use_state(cx, || false);

    cx.render(rsx! {
        div {
            button { 
                onclick: move |_| show_message.set(!show_message),
                "Toggle Message"
            }
            {if *show_message.get() {
                rsx! { p { "Hello, World!" } }
            } else {
                rsx! { p { "Message is hidden" } }
            }}
        }
    })
}
```

## 6. List Rendering
Render lists using Rust's iterators:

```rust
fn ItemList(cx: Scope) -> Element {
    let items = vec!["Apple", "Banana", "Cherry"];

    cx.render(rsx! {
        ul {
            {items.into_iter().map(|item| rsx! {
                li { key: "{item}", "{item}" }
            })}
        }
    })
}
```

## 7. Event Handling
Handle events in Dioxus:

```rust
fn EventHandler(cx: Scope) -> Element {
    let mut input_value = use_state(cx, String::new);

    cx.render(rsx! {
        input {
            value: "{input_value}",
            oninput: move |evt| input_value.set(evt.value.clone()),
        }
        p { "You typed: {input_value}" }
    })
}
```

## 8. Component Composition
Combine multiple components:

```rust
fn Header(cx: Scope) -> Element {
    cx.render(rsx! { h1 { "My App" } })
}

fn Footer(cx: Scope) -> Element {
    cx.render(rsx! { footer { "© 2024 My Company" } })
}

fn App(cx: Scope) -> Element {
    cx.render(rsx! {
        Header {}
        main { "Main content here" }
        Footer {}
    })
}
```

## Practice Exercises
1. Create a `TodoList` component that allows adding and removing items.
2. Implement a `Timer` component that counts down from a given number of seconds.
3. Build a `Tabs` component that switches between different content panes.

## Next Steps
- Explore more advanced state management techniques in Dioxus
- Learn about routing in Dioxus applications
- In the next lesson, we'll cover styling in Dioxus using CSS-in-Rust with dioxus-free-css
