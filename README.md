# AttributedText

A SwiftUI component for rendering richly attributed text with tappable (interactive) segments.

## Features
- Render text with custom attributes (color, font, underline, etc.)
- Make any part of the text tappable and handle tap actions
- Simple API, fully SwiftUI compatible

## Installation

### Swift Package Manager
Add the following to your `Package.swift` dependencies:

```swift
.package(url: "<your-repo-url>", from: "1.0.0")
```

And add `AttributedText` as a dependency for your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "AttributedText", package: "AttributedText")
    ]
)
```

Or, in Xcode: `File > Add Packages...`，输入你的仓库地址。

## Usage

### Basic Example
```swift
import AttributedText

struct ContentView: View {
    var body: some View {
        AttributedText("Hello, world!")
    }
}
```

### Tappable Text Example
```swift
AttributedText("Normal ") +
AttributedText("Tappable") { text in
    text.foregroundColor = .blue
    text.underlineStyle = .single
}
.onTap {
    print("Tappable text tapped!")
} +
AttributedText(" Text")
```

### Custom Font and Color
```swift
AttributedText("Custom Style") { text in
    text.foregroundColor = .red
    text.font = .system(size: 20, weight: .bold)
}
```

## Notes
- If you use `.underline()`, specify the color for best results: `.underline(color: .blue)`
- Combine multiple `AttributedText` instances with `+` to build complex rich text.

## License
MIT 