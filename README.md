# OnboardingFlow

A customizable, elegant onboarding flow package for SwiftUI applications. Create beautiful user onboarding experiences with profession selection, interest picking, and personalized loading animations.

## Features

- 🎨 **Fully Customizable Themes** - Colors, fonts, animations, and styling
- 👤 **Profession Selection** - Let users identify their role/profession  
- ❤️ **Interest Selection** - Configurable interest categories with selection limits
- ⚡ **Smooth Animations** - Beautiful transitions and haptic feedback
- 📱 **iOS 15+ Support** - Modern SwiftUI implementation
- 🔧 **Easy Integration** - Simple setup with comprehensive customization options
- 📊 **Progress Tracking** - Animated loading screen with personalized content

## Installation

### Swift Package Manager

Add this package to your project through Xcode:

1. File → Add Package Dependencies
2. Enter the package URL: `https://github.com/chingizagha/OnboardingFlow`
3. Click Add Package

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/chingizagha/OnboardingFlow", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftUI
import OnboardingFlow

struct ContentView: View {
    @State private var showOnboarding = true
    
    var body: some View {
        if showOnboarding {
            OnboardingFlowView { result in
                print("Profession: \(result.profession)")
                print("Interests: \(result.interests)")
                showOnboarding = false
            }
        } else {
            MainAppView()
        }      
    }
}
```

## Basic Customization

### Custom Theme

```swift
let customTheme = OnboardingTheme(
    primaryColor: .blue,
    secondaryColor: .purple,
    backgroundColor: Color(.systemBackground),
    titleFont: .system(size: 32, weight: .bold, design: .rounded),
    bodyFont: .system(size: 18, weight: .regular),
    cornerRadius: 16,
    animationDuration: 0.3
)

OnboardingFlowView(
    configuration: OnboardingConfiguration(theme: customTheme)
) { result in
    // Handle completion
}
```

### Custom Professions

```swift
let professions = [
    ProfessionOption(emoji: "👨‍💻", title: "Software Engineer"),
    ProfessionOption(emoji: "👩‍🎨", title: "Designer"),
    ProfessionOption(emoji: "👨‍🔬", title: "Researcher"),
    ProfessionOption(emoji: "👩‍💼", title: "Manager")
]

OnboardingFlowView(
    configuration: OnboardingConfiguration(professions: professions)
) { result in
    // Handle completion
}
```

### Custom Interests

```swift
let interests = [
    InterestOption(emoji: "🤖", title: "AI & Machine Learning"),
    InterestOption(emoji: "🚀", title: "Space Exploration"),
    InterestOption(emoji: "🌱", title: "Sustainability"),
    InterestOption(emoji: "🎬", title: "Film & Media")
]

OnboardingFlowView(
    configuration: OnboardingConfiguration(
        interests: interests,
        maxInterestSelection: 2
    )
) { result in
    // Handle completion
}
```

## Advanced Configuration

### Complete Configuration Example

```swift
let configuration = OnboardingConfiguration(
    theme: OnboardingTheme(
        primaryColor: Color(red: 0.2, green: 0.6, blue: 1.0),
        secondaryColor: Color(red: 0.8, green: 0.3, blue: 0.9),
        backgroundColor: Color(.systemBackground),
        textColor: .primary,
        secondaryTextColor: .secondary,
        cardBackgroundColor: .white,
        borderColor: Color.gray.opacity(0.3),
        shadowColor: Color.black.opacity(0.1),
        titleFont: .system(size: 28, weight: .bold, design: .rounded),
        bodyFont: .system(size: 18, weight: .regular),
        buttonFont: .system(size: 16, weight: .semibold),
        captionFont: .system(size: 14, weight: .regular),
        cornerRadius: 12,
        shadowRadius: 4,
        animationDuration: 0.3
    ),
    professions: customProfessions,
    interests: customInterests,
    maxInterestSelection: 3,
    loadingSteps: [
        "Analyzing your preferences...",
        "Creating personalized content...",
        "Setting up your profile...",
        "Almost ready!"
    ],
    loadingTexts: [
        "Data uploading...",
        "Personalizing experience...", 
        "Configuring settings...",
        "Finalizing setup..."
    ],
    enableHaptics: true
)

OnboardingFlowView(configuration: configuration) { result in
    // Handle the result
    UserDefaults.standard.set(result.profession, forKey: "userProfession")
    UserDefaults.standard.set(result.interests, forKey: "userInterests")
    UserDefaults.standard.set(result.isCompleted, forKey: "onboardingCompleted")
}
```

## Configuration Options

### OnboardingTheme

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `primaryColor` | Color | Main brand color | `.blue` |
| `secondaryColor` | Color | Secondary accent color | `.purple` |
| `backgroundColor` | Color | Background color | `Color(.systemBackground)` |
| `textColor` | Color | Primary text color | `.primary` |
| `secondaryTextColor` | Color | Secondary text color | `.secondary` |
| `cardBackgroundColor` | Color | Card background color | `.white` |
| `borderColor` | Color | Border color for cards | `Color.gray.opacity(0.4)` |
| `shadowColor` | Color | Shadow color | `Color.black.opacity(0.12)` |
| `titleFont` | Font | Font for titles | `.system(size: 28, weight: .bold, design: .rounded)` |
| `bodyFont` | Font | Font for body text | `.system(size: 18, weight: .regular)` |
| `buttonFont` | Font | Font for buttons | `.system(size: 16, weight: .semibold)` |
| `captionFont` | Font | Font for captions | `.system(size: 14, weight: .regular)` |
| `cornerRadius` | CGFloat | Corner radius for elements | `12` |
| `shadowRadius` | CGFloat | Shadow radius | `3` |
| `animationDuration` | Double | Animation duration | `0.3` |

### OnboardingConfiguration

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `theme` | OnboardingTheme | Visual theme configuration | `OnboardingTheme()` |
| `professions` | [ProfessionOption] | Available profession options | Default professions |
| `interests` | [InterestOption] | Available interest options | Default interests |
| `maxInterestSelection` | Int | Maximum selectable interests | `3` |
| `loadingSteps` | [String] | Loading step descriptions | Default steps |
| `loadingTexts` | [String] | Loading text under progress bar | Default texts |
| `enableHaptics` | Bool | Enable haptic feedback | `true` |

## Handling Results

The completion handler receives an `OnboardingResult` object:

```swift
struct OnboardingResult {
    let profession: String      // Selected profession
    let interests: [String]     // Selected interests
    let isCompleted: Bool       // true if completed, false if skipped
}
```

Example usage:

```swift
OnboardingFlowView(configuration: configuration) { result in
    if result.isCompleted {
        print("User completed onboarding")
        print("Profession: \(result.profession)")
        print("Interests: \(result.interests.joined(separator: ", "))")
        
        // Save to UserDefaults, Core Data, etc.
        saveUserPreferences(result)
    } else {
        print("User skipped onboarding")
    }
    
    // Navigate to main app
    withAnimation {
        showOnboarding = false
    }
}
```

## Default Options

### Default Professions
- 👨‍🏫 Teacher
- 👩‍🎓 Student  
- 🎓 University Student
- 👨‍💼 Professional
- 👩‍💻 Developer
- 👨‍⚕️ Healthcare Worker
- 👩‍🔬 Researcher
- 👨‍🎨 Creative Professional
- 📚 Other

### Default Interests
- 🎓 Education
- 🔬 Science
- 📚 History
- 🎨 Arts
- 💻 Technology
- 🏃‍♂️ Sports
- 🎵 Music
- 🍳 Cooking
- 🌍 Geography
- 🧮 Math
- 📱 Social Media
- 🎮 Gaming

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Examples

Check out the example projects in the `/Examples` folder for more detailed implementation examples including:
- Basic implementation
- Custom themes
- Custom professions and interests
- Integration with Core Data
- Integration with Firebase

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you have any questions or need help integrating OnboardingFlow into your project, please open an issue on GitHub.

---

Made with ❤️ by Chingiz Agha
