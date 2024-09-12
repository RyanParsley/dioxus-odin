# Lesson 6: Routing in Dioxus Applications

## Objective
By the end of this lesson, you will understand how to implement client-side routing in Dioxus applications using the dioxus-router crate.

## 1. Introduction to Routing in Dioxus
Routing allows you to create multi-page applications with different views based on the URL. Dioxus provides a powerful routing system through the dioxus-router crate.

## 2. Setting up dioxus-router
First, add dioxus-router to your `Cargo.toml`:

```toml
[dependencies]
dioxus = "0.5.0"
dioxus-router = "0.5.0"
```

## 3. Basic Route Setup
Here's a basic example of setting up routes:

```rust
use dioxus::prelude::*;
use dioxus_router::prelude::*;

#[derive(Routable, Clone)]
enum Route {
    #[route("/")]
    Home,
    #[route("/about")]
    About,
    #[route("/contact")]
    Contact,
}

fn App(cx: Scope) -> Element {
    cx.render(rsx! {
        Router::<Route> {}
    })
}

#[inline_props]
fn Home(cx: Scope) -> Element {
    cx.render(rsx! {
        h1 { "Home Page" }
        Link { to: Route::About {}, "Go to About" }
    })
}

#[inline_props]
fn About(cx: Scope) -> Element {
    cx.render(rsx! {
        h1 { "About Page" }
        Link { to: Route::Contact {}, "Go to Contact" }
    })
}

#[inline_props]
fn Contact(cx: Scope) -> Element {
    cx.render(rsx! {
        h1 { "Contact Page" }
        Link { to: Route::Home {}, "Go to Home" }
    })
}
```

## 4. Nested Routes
You can create nested routes for more complex applications:

```rust
#[derive(Routable, Clone)]
enum Route {
    #[route("/")]
    Home,
    #[route("/users")]
    Users,
    #[route("/users/:id")]
    UserProfile { id: String },
}

#[inline_props]
fn Users(cx: Scope) -> Element {
    cx.render(rsx! {
        h1 { "Users Page" }
        ul {
            li { Link { to: Route::UserProfile { id: "1".to_string() }, "User 1" } }
            li { Link { to: Route::UserProfile { id: "2".to_string() }, "User 2" } }
        }
    })
}

#[inline_props]
fn UserProfile(cx: Scope, id: String) -> Element {
    cx.render(rsx! {
        h1 { "User Profile" }
        p { "User ID: {id}" }
        Link { to: Route::Users {}, "Back to Users" }
    })
}
```

## 5. Route Parameters
As seen in the UserProfile example, you can use route parameters:

```rust
#[route("/users/:id")]
UserProfile { id: String },
```

## 6. Query Parameters
You can also handle query parameters:

```rust
use dioxus_router::hooks::use_query;

#[inline_props]
fn SearchResults(cx: Scope) -> Element {
    let query = use_query(cx);
    let search_term = query.get("q").unwrap_or("");

    cx.render(rsx! {
        h1 { "Search Results" }
        p { "Searching for: {search_term}" }
    })
}
```

## 7. Navigation Guards
You can implement navigation guards to protect routes:

```rust
use dioxus_router::prelude::*;

fn is_authenticated() -> bool {
    // Your authentication logic here
    true
}

#[inline_props]
fn ProtectedRoute(cx: Scope) -> Element {
    let navigator = use_navigator(cx);

    if !is_authenticated() {
        navigator.replace(Route::Login {});
        return None;
    }

    cx.render(rsx! {
        h1 { "Protected Content" }
    })
}
```

## 8. 404 Not Found Route
Handle unknown routes with a 404 page:

```rust
#[derive(Routable, Clone)]
enum Route {
    #[route("/")]
    Home,
    #[route("/:..route")]
    NotFound { route: Vec<String> },
}

#[inline_props]
fn NotFound(cx: Scope, route: Vec<String>) -> Element {
    cx.render(rsx! {
        h1 { "404 Not Found" }
        p { "The page /{route.join("/")} does not exist." }
        Link { to: Route::Home {}, "Go to Home" }
    })
}
```

## Practice Exercises
1. Create a simple blog application with routes for a home page, post list, and individual post pages.
2. Implement a user authentication system with protected routes and a login page.
3. Build a product catalog with category and product detail pages, using nested routes and query parameters for filtering.

## Next Steps
- Explore more advanced routing scenarios, such as lazy loading routes
- Learn about integrating routing with state management in Dioxus
- In the next lesson, we'll cover state management techniques in Dioxus applications
