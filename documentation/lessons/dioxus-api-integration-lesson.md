# Lesson 9: API Integration and Data Fetching in Dioxus

## Objective
By the end of this lesson, you will understand how to integrate external APIs, fetch data asynchronously, and manage loading and error states in Dioxus applications.

## 1. Setting Up
First, add the necessary dependencies to your `Cargo.toml`:

```toml
[dependencies]
dioxus = "0.5.0"
reqwest = { version = "0.11", features = ["json"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

## 2. Basic GET Request
Let's start with a simple GET request using `reqwest`:

```rust
use dioxus::prelude::*;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct Todo {
    id: u32,
    title: String,
    completed: bool,
}

async fn fetch_todo(id: u32) -> Result<Todo, reqwest::Error> {
    let url = format!("https://jsonplaceholder.typicode.com/todos/{}", id);
    reqwest::get(&url).await?.json().await
}

fn TodoFetcher(cx: Scope) -> Element {
    let todo = use_future(cx, (), |_| async move {
        fetch_todo(1).await
    });

    cx.render(rsx! {
        div {
            match todo.value() {
                Some(Ok(todo)) => rsx! {
                    h1 { "Todo" }
                    p { "Title: {todo.title}" }
                    p { "Completed: {todo.completed}" }
                },
                Some(Err(_)) => rsx! { p { "Error fetching todo" } },
                None => rsx! { p { "Loading..." } },
            }
        }
    })
}
```

## 3. Handling Loading and Error States
Let's improve our example to better handle loading and error states:

```rust
#[derive(Debug)]
enum FetchState<T> {
    NotStarted,
    Loading,
    Loaded(T),
    Error(String),
}

fn ImprovedTodoFetcher(cx: Scope) -> Element {
    let mut fetch_state = use_state(cx, || FetchState::NotStarted);

    let onclick = move |_| {
        fetch_state.set(FetchState::Loading);
        cx.spawn({
            to_owned![fetch_state];
            async move {
                match fetch_todo(1).await {
                    Ok(todo) => fetch_state.set(FetchState::Loaded(todo)),
                    Err(e) => fetch_state.set(FetchState::Error(e.to_string())),
                }
            }
        });
    };

    cx.render(rsx! {
        div {
            button { onclick: onclick, "Fetch Todo" }
            match fetch_state.get() {
                FetchState::NotStarted => rsx! { p { "Click the button to fetch a todo" } },
                FetchState::Loading => rsx! { p { "Loading..." } },
                FetchState::Loaded(todo) => rsx! {
                    h1 { "Todo" }
                    p { "Title: {todo.title}" }
                    p { "Completed: {todo.completed}" }
                },
                FetchState::Error(err) => rsx! { p { "Error: {err}" } },
            }
        }
    })
}
```

## 4. POST Request
Now let's implement a POST request to create a new todo:

```rust
async fn create_todo(title: String) -> Result<Todo, reqwest::Error> {
    let client = reqwest::Client::new();
    let new_todo = serde_json::json!({
        "title": title,
        "completed": false,
    });
    client.post("https://jsonplaceholder.typicode.com/todos")
        .json(&new_todo)
        .send()
        .await?
        .json()
        .await
}

fn TodoCreator(cx: Scope) -> Element {
    let mut title = use_state(cx, String::new);
    let mut created_todo = use_state(cx, || None::<Todo>);

    let onsubmit = move |evt: FormEvent| {
        evt.prevent_default();
        let title_value = title.get().clone();
        cx.spawn({
            to_owned![created_todo];
            async move {
                match create_todo(title_value).await {
                    Ok(todo) => created_todo.set(Some(todo)),
                    Err(e) => log::error!("Error creating todo: {}", e),
                }
            }
        });
    };

    cx.render(rsx! {
        form { onsubmit: onsubmit,
            input {
                value: "{title}",
                oninput: move |evt| title.set(evt.value.clone()),
            }
            button { type: "submit", "Create Todo" }
        }
        {created_todo.get().as_ref().map(|todo| rsx! {
            div {
                h2 { "Created Todo" }
                p { "Title: {todo.title}" }
                p { "ID: {todo.id}" }
            }
        })}
    })
}
```

## 5. Cancelling Requests
To cancel ongoing requests when a component unmounts, we can use `AbortController`:

```rust
use futures::future::AbortHandle;

fn CancellableTodoFetcher(cx: Scope) -> Element {
    let abort_handle = use_state(cx, || None::<AbortHandle>);
    let mut todo = use_state(cx, || None::<Todo>);

    let fetch_todo = move |_| {
        if let Some(handle) = abort_handle.get() {
            handle.abort();
        }
        let (abort_registration, abort_handle) = AbortHandle::new_pair();
        abort_handle.set(Some(abort_handle));

        cx.spawn({
            to_owned![todo];
            async move {
                let result = futures::future::Abortable::new(
                    async { fetch_todo(1).await },
                    abort_registration
                ).await;
                if let Ok(Ok(fetched_todo)) = result {
                    todo.set(Some(fetched_todo));
                }
            }
        });
    };

    use_effect(cx, (), |_| {
        || {
            if let Some(handle) = abort_handle.get() {
                handle.abort();
            }
        }
    });

    cx.render(rsx! {
        button { onclick: fetch_todo, "Fetch Todo" }
        {todo.get().as_ref().map(|t| rsx! {
            div {
                h2 { "Fetched Todo" }
                p { "Title: {t.title}" }
            }
        })}
    })
}
```

## 6. Pagination
Implementing pagination for a list of todos:

```rust
#[derive(Debug, Deserialize)]
struct TodoList(Vec<Todo>);

async fn fetch_todos(page: u32, limit: u32) -> Result<TodoList, reqwest::Error> {
    let url = format!(
        "https://jsonplaceholder.typicode.com/todos?_page={}&_limit={}",
        page, limit
    );
    reqwest::get(&url).await?.json().await
}

fn PaginatedTodoList(cx: Scope) -> Element {
    let mut page = use_state(cx, || 1);
    let todos = use_future(cx, page, |page| async move {
        fetch_todos(*page, 10).await
    });

    cx.render(rsx! {
        div {
            button { onclick: move |_| page -= 1, disabled: "{*page == 1}", "Previous" }
            button { onclick: move |_| page += 1, "Next" }
            match todos.value() {
                Some(Ok(TodoList(list))) => rsx! {
                    ul {
                        {list.iter().map(|todo| rsx! {
                            li { key: "{todo.id}", "{todo.title}" }
                        })}
                    }
                },
                Some(Err(_)) => rsx! { p { "Error fetching todos" } },
                None => rsx! { p { "Loading..." } },
            }
        }
    })
}
```

## Practice Exercises
1. Create a weather app that fetches data from a weather API based on user input (city name or coordinates).
2. Implement a GitHub user search feature that allows users to search for GitHub profiles and display basic user information.
3. Build a simple blog application that fetches posts from an API, implements pagination, and allows users to create new posts.

## Next Steps
- Explore more advanced API integration patterns, such as caching and optimistic updates
- Learn about authentication and authorization in API requests
- In the next lesson, we'll cover testing Dioxus applications
