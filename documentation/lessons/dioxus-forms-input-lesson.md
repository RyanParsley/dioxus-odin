# Lesson 8: Forms and User Input Handling in Dioxus

## Objective
By the end of this lesson, you will understand how to create and manage forms, handle various types of user input, and implement form validation in Dioxus applications.

## 1. Basic Form Handling
Let's start with a simple form example:

```rust
use dioxus::prelude::*;

fn SimpleForm(cx: Scope) -> Element {
    let mut name = use_state(cx, String::new);

    let on_submit = move |evt: FormEvent| {
        evt.prevent_default();
        log::info!("Form submitted with name: {}", name);
    };

    cx.render(rsx! {
        form { onsubmit: on_submit,
            label { "Name: " }
            input {
                value: "{name}",
                oninput: move |evt| name.set(evt.value.clone()),
            }
            button { type: "submit", "Submit" }
        }
    })
}
```

## 2. Handling Multiple Inputs
For forms with multiple inputs, use a struct to manage the form state:

```rust
use dioxus::prelude::*;

#[derive(Default)]
struct FormData {
    username: String,
    email: String,
    password: String,
}

fn MultiInputForm(cx: Scope) -> Element {
    let mut form_data = use_state(cx, FormData::default);

    let on_submit = move |evt: FormEvent| {
        evt.prevent_default();
        log::info!("Form submitted: {:?}", form_data);
    };

    cx.render(rsx! {
        form { onsubmit: on_submit,
            label { "Username: " }
            input {
                value: "{form_data.username}",
                oninput: move |evt| form_data.modify(|f| f.username = evt.value.clone()),
            }
            label { "Email: " }
            input {
                r#type: "email",
                value: "{form_data.email}",
                oninput: move |evt| form_data.modify(|f| f.email = evt.value.clone()),
            }
            label { "Password: " }
            input {
                r#type: "password",
                value: "{form_data.password}",
                oninput: move |evt| form_data.modify(|f| f.password = evt.value.clone()),
            }
            button { type: "submit", "Register" }
        }
    })
}
```

## 3. Different Input Types
Dioxus supports various HTML input types:

```rust
fn InputTypesExample(cx: Scope) -> Element {
    let mut text = use_state(cx, String::new);
    let mut number = use_state(cx, || 0);
    let mut date = use_state(cx, String::new);
    let mut checked = use_state(cx, || false);

    cx.render(rsx! {
        div {
            input {
                r#type: "text",
                value: "{text}",
                oninput: move |evt| text.set(evt.value.clone()),
            }
            input {
                r#type: "number",
                value: "{number}",
                oninput: move |evt| number.set(evt.value.parse().unwrap_or(0)),
            }
            input {
                r#type: "date",
                value: "{date}",
                oninput: move |evt| date.set(evt.value.clone()),
            }
            input {
                r#type: "checkbox",
                checked: "{checked}",
                oninput: move |evt| checked.set(evt.value.parse().unwrap_or(false)),
            }
        }
    })
}
```

## 4. Select and Textarea Elements
Handling select and textarea elements:

```rust
fn SelectAndTextareaExample(cx: Scope) -> Element {
    let mut selected = use_state(cx, || "option1".to_string());
    let mut text_area = use_state(cx, String::new);

    cx.render(rsx! {
        div {
            select {
                value: "{selected}",
                onchange: move |evt| selected.set(evt.value.clone()),
                option { value: "option1", "Option 1" }
                option { value: "option2", "Option 2" }
                option { value: "option3", "Option 3" }
            }
            textarea {
                value: "{text_area}",
                oninput: move |evt| text_area.set(evt.value.clone()),
            }
        }
    })
}
```

## 5. Form Validation
Implement basic form validation:

```rust
use dioxus::prelude::*;

#[derive(Default)]
struct FormData {
    email: String,
    password: String,
}

#[derive(Default)]
struct FormErrors {
    email: Option<String>,
    password: Option<String>,
}

fn ValidatedForm(cx: Scope) -> Element {
    let mut form_data = use_state(cx, FormData::default);
    let mut form_errors = use_state(cx, FormErrors::default);

    let validate_form = move || {
        let mut errors = FormErrors::default();
        if !form_data.email.contains('@') {
            errors.email = Some("Invalid email address".to_string());
        }
        if form_data.password.len() < 8 {
            errors.password = Some("Password must be at least 8 characters".to_string());
        }
        form_errors.set(errors);
        errors.email.is_none() && errors.password.is_none()
    };

    let on_submit = move |evt: FormEvent| {
        evt.prevent_default();
        if validate_form() {
            log::info!("Form submitted successfully: {:?}", form_data);
        } else {
            log::warn!("Form has errors: {:?}", form_errors);
        }
    };

    cx.render(rsx! {
        form { onsubmit: on_submit,
            label { "Email: " }
            input {
                r#type: "email",
                value: "{form_data.email}",
                oninput: move |evt| form_data.modify(|f| f.email = evt.value.clone()),
            }
            {form_errors.email.as_ref().map(|error| rsx!{ p { class: "error", "{error}" } })}

            label { "Password: " }
            input {
                r#type: "password",
                value: "{form_data.password}",
                oninput: move |evt| form_data.modify(|f| f.password = evt.value.clone()),
            }
            {form_errors.password.as_ref().map(|error| rsx!{ p { class: "error", "{error}" } })}

            button { type: "submit", "Submit" }
        }
    })
}
```

## 6. Handling File Inputs
Working with file inputs requires some special handling:

```rust
use dioxus::prelude::*;
use dioxus::events::FormData;

fn FileInputExample(cx: Scope) -> Element {
    let mut file_name = use_state(cx, || "No file selected".to_string());

    let on_file_change = move |evt: Event<FormData>| {
        if let Some(files) = evt.files() {
            if let Some(file) = files.get(0) {
                file_name.set(file.name().to_string());
            }
        }
    };

    cx.render(rsx! {
        div {
            input {
                r#type: "file",
                onchange: on_file_change,
            }
            p { "Selected file: {file_name}" }
        }
    })
}
```

## Practice Exercises
1. Create a multi-step form wizard with at least three steps, using state to manage the current step and form data.
2. Implement a dynamic form where users can add or remove form fields (e.g., a list of skills or experiences).
3. Build a form with custom validation rules, including asynchronous validation (e.g., checking if a username is already taken).

## Next Steps
- Explore more advanced form libraries and integrations for Dioxus
- Learn about accessibility considerations for forms in web applications
- In the next lesson, we'll cover API integration and data fetching in Dioxus applications
