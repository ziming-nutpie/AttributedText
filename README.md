# AttributedText

AttributedText is a text processing library for SwiftUI that provides a simple way to create and manage text views with rich text attributes. The library supports text concatenation, tap event handling, and custom styling.

## Features

- Rich text attribute support
- Text concatenation operations
- Tap event handling
- Custom text styling
- Fully SwiftUI compatible

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5.10+

## Installation

### Swift Package Manager

In Xcode, select File > Add Packages... and enter the repository URL:

```
https://github.com/yourusername/AttributedText.git
```

## Usage Examples

### Basic Usage

```swift
AttributedText("Hello World")
```

### Adding Styles

```swift
AttributedText("Styled Text") { text in
    text.foregroundColor = .green
}
```

### Adding Tap Events

```swift
AttributedText("Clickable Text")
    .onTap {
        print("Text tapped!")
    }
```

### Text Concatenation

```swift
AttributedText("Hello ")
    +
AttributedText("World") { text in
    text.foregroundColor = .blue
}
    .onTap {
        print("World tapped!")
    }
```

## Complete Example

```swift
Group {
    AttributedText("Test ")
        +
    AttributedText("Tappable Text") { text in
        text.foregroundColor = .green
    }
    .onTap {
        print("Test")
    }
        +
    AttributedText(" Short")
}
.font(.system(size: 28))
```

## License

Copyright © 2024 Nut AI. All rights reserved. 