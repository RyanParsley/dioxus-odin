# Lesson 1: Introduction to Rust Basics

## Objective
By the end of this lesson, you will understand fundamental Rust concepts and syntax, preparing you for Dioxus development.

## 1. Installing Rust
- Use rustup to install Rust: https://rustup.rs/
- Verify installation: `rustc --version` and `cargo --version`

## 2. Hello, World!
Create your first Rust program:

```rust
fn main() {
    println!("Hello, World!");
}
```

Save as `hello.rs` and run with `rustc hello.rs && ./hello`

## 3. Variables and Mutability
```rust
let x = 5; // Immutable by default
let mut y = 10; // Mutable variable
y = 15; // This is allowed
```

## 4. Data Types
- Scalar types: integers, floating-point numbers, booleans, and characters
- Compound types: tuples and arrays

```rust
let integer: i32 = 42;
let float: f64 = 3.14;
let boolean: bool = true;
let character: char = 'A';

let tuple: (i32, f64, char) = (500, 6.4, 'Z');
let array: [i32; 5] = [1, 2, 3, 4, 5];
```

## 5. Functions
```rust
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

fn main() {
    let message = greet("Rustacean");
    println!("{}", message);
}
```

## 6. Control Flow
```rust
fn main() {
    let number = 7;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }

    for i in 1..5 {
        println!("Number: {}", i);
    }
}
```

## 7. Ownership and Borrowing
- Ownership: Each value has a variable that's its "owner"
- Borrowing: References allow you to refer to some value without taking ownership

```rust
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

## Practice Exercises
1. Create a function that takes two numbers and returns their sum.
2. Write a program that prints the first 10 Fibonacci numbers.
3. Implement a simple guessing game where the user tries to guess a number between 1 and 100.

## Next Steps
- Explore the Rust Book for more in-depth explanations: https://doc.rust-lang.org/book/
- Practice writing small Rust programs to reinforce these concepts
- In the next lesson, we'll dive into web development fundamentals and start exploring how Dioxus fits into the Rust ecosystem.
