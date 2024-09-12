# Lesson 7: State Management in Dioxus

## Objective
By the end of this lesson, you will understand various state management techniques in Dioxus, from local component state to global application state.

## 1. Local Component State
We've already seen `use_state` for local component state. Let's review and expand on this concept:

```rust
use dioxus::prelude::*;

fn Counter(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);

    cx.render(rsx! {
        div {
            p { "Count: {count}" }
            button { onclick: move |_| count += 1, "Increment" }
            button { onclick: move |_| count -= 1, "Decrement" }
        }
    })
}
```

## 2. Derived State with `use_memo`
Use `use_memo` to compute derived state efficiently:

```rust
fn DerivedStateExample(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);
    let is_even = use_memo(cx, count, |count| count % 2 == 0);

    cx.render(rsx! {
        div {
            p { "Count: {count}" }
            p { "Is even: {is_even}" }
            button { onclick: move |_| count += 1, "Increment" }
        }
    })
}
```

## 3. State Updates with Previous Value
When updating state based on its previous value, use the closure form:

```rust
fn CounterWithStep(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);
    let mut step = use_state(cx, || 1);

    cx.render(rsx! {
        div {
            p { "Count: {count}" }
            p { "Step: {step}" }
            button { onclick: move |_| count.modify(|c| c + *step), "Increment" }
            button { onclick: move |_| step += 1, "Increase Step" }
        }
    })
}
```

## 4. Sharing State Between Components
Use props to pass state down to child components:

```rust
#[derive(Props)]
struct ChildProps {
    count: i32,
    on_increment: EventHandler<()>,
}

fn Parent(cx: Scope) -> Element {
    let mut count = use_state(cx, || 0);

    cx.render(rsx! {
        div {
            h1 { "Parent Component" }
            p { "Count: {count}" }
            Child {
                count: *count,
                on_increment: move |_| count += 1
            }
        }
    })
}

fn Child(cx: Scope<ChildProps>) -> Element {
    cx.render(rsx! {
        div {
            h2 { "Child Component" }
            p { "Count from parent: {cx.props.count}" }
            button { onclick: move |_| cx.props.on_increment.call(()), "Increment" }
        }
    })
}
```

## 5. Context for Global State
Use context for global state that needs to be accessed by many components:

```rust
use dioxus::prelude::*;

struct AppState {
    count: i32,
}

fn App(cx: Scope) -> Element {
    use_context_provider(cx, || AppState { count: 0 });

    cx.render(rsx! {
        StateDisplay {}
        StateUpdater {}
    })
}

fn StateDisplay(cx: Scope) -> Element {
    let state = use_context::<AppState>(cx).unwrap();

    cx.render(rsx! {
        div {
            p { "Global Count: {state.count}" }
        }
    })
}

fn StateUpdater(cx: Scope) -> Element {
    let state = use_context::<AppState>(cx).unwrap();

    cx.render(rsx! {
        button {
            onclick: move |_| {
                state.count += 1;
                cx.needs_update();
            },
            "Increment Global Count"
        }
    })
}
```

## 6. Async State with `use_future`
Handle asynchronous state updates with `use_future`:

```rust
use dioxus::prelude::*;
use futures::future::ready;

async fn fetch_data() -> String {
    // Simulate API call
    ready("Fetched data").await.to_string()
}

fn AsyncStateExample(cx: Scope) -> Element {
    let data = use_future(cx, (), |_| async move {
        fetch_data().await
    });

    cx.render(rsx! {
        div {
            match data.value() {
                Some(value) => rsx! { p { "Data: {value}" } },
                None => rsx! { p { "Loading..." } },
            }
        }
    })
}
```

## 7. Complex State with Reducers
For complex state logic, use reducers:

```rust
use dioxus::prelude::*;

#[derive(Clone)]
enum Action {
    Increment,
    Decrement,
    Reset,
}

fn reducer(count: i32, action: Action) -> i32 {
    match action {
        Action::Increment => count + 1,
        Action::Decrement => count - 1,
        Action::Reset => 0,
    }
}

fn ReducerExample(cx: Scope) -> Element {
    let mut count = use_reducer(cx, reducer, || 0);

    cx.render(rsx! {
        div {
            p { "Count: {count}" }
            button { onclick: move |_| count.dispatch(Action::Increment), "Increment" }
            button { onclick: move |_| count.dispatch(Action::Decrement), "Decrement" }
            button { onclick: move |_| count.dispatch(Action::Reset), "Reset" }
        }
    })
}
```

## Practice Exercises
1. Create a todo list application using local state for the list items and derived state for completed/uncompleted counts.
2. Implement a shopping cart using context for global state, with components for product list, cart display, and checkout.
3. Build a weather dashboard that fetches data asynchronously and uses reducers to manage multiple locations.

## Next Steps
- Explore more advanced state management patterns, such as combining multiple contexts or using external state management libraries
- Learn about optimizing performance with state management techniques
- In the next lesson, we'll cover forms and user input handling in Dioxus
