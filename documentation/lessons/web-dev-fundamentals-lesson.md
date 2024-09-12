# Lesson 2: Web Development Fundamentals

## Objective
By the end of this lesson, you will understand key web development concepts and how they relate to Rust and Dioxus development.

## 1. Web Technologies Overview
- HTML: Structure
- CSS: Presentation
- JavaScript: Behavior
- WebAssembly: High-performance code execution in the browser

## 2. HTML Basics
HTML provides the structure for web pages. Example:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Web Page</title>
</head>
<body>
    <h1>Welcome to My Web Page</h1>
    <p>This is a paragraph.</p>
</body>
</html>
```

## 3. CSS Basics
CSS is used for styling web pages. Example:

```css
body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
}

h1 {
    color: #333;
    text-align: center;
}
```

## 4. JavaScript and DOM Manipulation
JavaScript allows for dynamic content and interactivity. Example:

```javascript
document.addEventListener('DOMContentLoaded', () => {
    const button = document.createElement('button');
    button.textContent = 'Click me!';
    button.addEventListener('click', () => {
        alert('Button clicked!');
    });
    document.body.appendChild(button);
});
```

## 5. Client-Side vs Server-Side Rendering
- Client-Side Rendering (CSR): JavaScript builds the page in the browser
- Server-Side Rendering (SSR): HTML is generated on the server
- Dioxus supports both CSR and SSR

## 6. Single Page Applications (SPAs)
- SPAs update the current page instead of loading new pages
- Improved user experience with faster transitions
- Dioxus is well-suited for building SPAs

## 7. RESTful APIs and HTTP
- HTTP methods: GET, POST, PUT, DELETE
- JSON as a common data format
- Example of fetching data (we'll use JavaScript here, but later we'll do this in Rust):

```javascript
fetch('https://api.example.com/data')
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error('Error:', error));
```

## 8. Web Components and Componentization
- Breaking UI into reusable components
- Dioxus uses a component-based architecture similar to React

## 9. Responsive Design Principles
- Flexible grids and layouts
- CSS media queries
- Mobile-first approach

## 10. Web Security Basics
- HTTPS
- Cross-Site Scripting (XSS) prevention
- Cross-Site Request Forgery (CSRF) protection

## Practice Exercises
1. Create a simple HTML page with a header, main content area, and footer.
2. Style your HTML page using CSS to make it visually appealing.
3. Add a JavaScript function that changes the text of a paragraph when a button is clicked.

## Next Steps
- Experiment with creating simple web pages using HTML, CSS, and JavaScript
- Start thinking about how these concepts might translate to Rust and Dioxus
- In the next lesson, we'll introduce Dioxus and start exploring its ecosystem
