// MARK: - Sources/OnboardingFlow/OnboardingFlow.swift

import SwiftUI

// MARK: - Configuration Models

public struct OnboardingConfiguration: Sendable {
    public let theme: OnboardingTheme
    public let professions: [ProfessionOption]
    public let interests: [InterestOption]
    public let maxInterestSelection: Int
    public let loadingSteps: [String]
    public let loadingTexts: [String]
    public let enableHaptics: Bool
    
    public init(
        theme: OnboardingTheme = OnboardingTheme(),
        professions: [ProfessionOption] = ProfessionOption.defaultProfessions,
        interests: [InterestOption] = InterestOption.defaultInterests,
        maxInterestSelection: Int = 3,
        loadingSteps: [String] = [
            "Analyzing your preferences...",
            "Creating personalized content...",
            "Setting up your profile...",
            "Almost ready!"
        ],
        loadingTexts: [String] = [
            "Data uploading...",
            "Personalizing experience...",
            "Configuring settings...",
            "Finalizing setup..."
        ],
        enableHaptics: Bool = true
    ) {
        self.theme = theme
        self.professions = professions
        self.interests = interests
        self.maxInterestSelection = maxInterestSelection
        self.loadingSteps = loadingSteps
        self.loadingTexts = loadingTexts
        self.enableHaptics = enableHaptics
    }
}

public struct OnboardingTheme: Sendable {
    public let primaryColor: Color
    public let secondaryColor: Color
    public let backgroundColor: Color
    public let textColor: Color
    public let secondaryTextColor: Color
    public let cardBackgroundColor: Color
    public let borderColor: Color
    public let shadowColor: Color
    
    public let titleFont: Font
    public let bodyFont: Font
    public let buttonFont: Font
    public let captionFont: Font
    
    public let cornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let animationDuration: Double
    
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .purple,
        backgroundColor: Color = Color(.systemBackground),
        textColor: Color = .primary,
        secondaryTextColor: Color = .secondary,
        cardBackgroundColor: Color = .white,
        borderColor: Color = Color.gray.opacity(0.4),
        shadowColor: Color = Color.black.opacity(0.12),
        titleFont: Font = .system(size: 28, weight: .bold, design: .rounded),
        bodyFont: Font = .system(size: 18, weight: .regular),
        buttonFont: Font = .system(size: 16, weight: .semibold),
        captionFont: Font = .system(size: 14, weight: .regular),
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 3,
        animationDuration: Double = 0.3
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.secondaryTextColor = secondaryTextColor
        self.cardBackgroundColor = cardBackgroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.titleFont = titleFont
        self.bodyFont = bodyFont
        self.buttonFont = buttonFont
        self.captionFont = captionFont
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.animationDuration = animationDuration
    }
}

public struct ProfessionOption: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let emoji: String
    public let title: String
    
    public init(emoji: String, title: String) {
        self.emoji = emoji
        self.title = title
    }
    
    public static let defaultProfessions: [ProfessionOption] = [
        ProfessionOption(emoji: "👨‍🏫", title: "Teacher"),
        ProfessionOption(emoji: "👩‍🎓", title: "Student"),
        ProfessionOption(emoji: "🎓", title: "University Student"),
        ProfessionOption(emoji: "👨‍💼", title: "Professional"),
        ProfessionOption(emoji: "👩‍💻", title: "Developer"),
        ProfessionOption(emoji: "👨‍⚕️", title: "Healthcare Worker"),
        ProfessionOption(emoji: "👩‍🔬", title: "Researcher"),
        ProfessionOption(emoji: "👨‍🎨", title: "Creative Professional"),
        ProfessionOption(emoji: "📚", title: "Other")
    ]
}

public struct InterestOption: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let emoji: String
    public let title: String
    
    public init(emoji: String, title: String) {
        self.emoji = emoji
        self.title = title
    }
    
    public static let defaultInterests: [InterestOption] = [
        InterestOption(emoji: "🎓", title: "Education"),
        InterestOption(emoji: "🔬", title: "Science"),
        InterestOption(emoji: "📚", title: "History"),
        InterestOption(emoji: "🎨", title: "Arts"),
        InterestOption(emoji: "💻", title: "Technology"),
        InterestOption(emoji: "🏃‍♂️", title: "Sports"),
        InterestOption(emoji: "🎵", title: "Music"),
        InterestOption(emoji: "🍳", title: "Cooking"),
        InterestOption(emoji: "🌍", title: "Geography"),
        InterestOption(emoji: "🧮", title: "Math"),
        InterestOption(emoji: "📱", title: "Social Media"),
        InterestOption(emoji: "🎮", title: "Gaming")
    ]
}

public struct OnboardingResult: Sendable {
    public let profession: String
    public let interests: [String]
    public let isCompleted: Bool
    
    public init(profession: String, interests: [String], isCompleted: Bool) {
        self.profession = profession
        self.interests = interests
        self.isCompleted = isCompleted
    }
}

// MARK: - Main Onboarding View

public struct OnboardingFlowView: View {
    private let configuration: OnboardingConfiguration
    private let onComplete: (OnboardingResult) -> Void
    
    @State private var currentPage = 0
    @State private var isOnboardingComplete = false
    @State private var selectedInterests: Set<String> = []
    @State private var selectedProfession: String = ""
    @State private var showPersonalizedLoading = false
    
    private let pages: [OnboardingPageModel]
    
    public init(
        configuration: OnboardingConfiguration = OnboardingConfiguration(),
        onComplete: @escaping (OnboardingResult) -> Void
    ) {
        self.configuration = configuration
        self.onComplete = onComplete
        self.pages = [
            OnboardingPageModel(
                title: "Welcome to Your App",
                description: "Let's personalize your experience with a quick setup!",
                iconName: "star.fill",
                backgroundColor: configuration.theme.primaryColor
            ),
            OnboardingPageModel(
                title: "Tell Us About Yourself",
                description: "This helps us customize content for you",
                iconName: "person.fill",
                backgroundColor: configuration.theme.secondaryColor
            ),
            OnboardingPageModel(
                title: "Select Your Interests",
                description: "Choose what matters most to you",
                iconName: "heart.fill",
                backgroundColor: Color.orange
            )
        ]
    }
    
    public var body: some View {
        ZStack {
            configuration.theme.backgroundColor
                .ignoresSafeArea()
            
            if showPersonalizedLoading {
                PersonalizedLoadingView(
                    configuration: configuration,
                    profession: selectedProfession,
                    interests: Array(selectedInterests)
                ) {
                    let result = OnboardingResult(
                        profession: selectedProfession,
                        interests: Array(selectedInterests),
                        isCompleted: true
                    )
                    onComplete(result)
                }
            } else {
                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            performHaptic(.light)
                            let result = OnboardingResult(
                                profession: "",
                                interests: [],
                                isCompleted: false
                            )
                            onComplete(result)
                        }
                        .foregroundColor(configuration.theme.primaryColor)
                        .font(configuration.theme.buttonFont)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .opacity(currentPage == pages.count - 1 ? 0 : 1)
                    
                    // Page content
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Group {
                                    switch index {
                                    case 1:
                                        ProfessionSelectionView(
                                            configuration: configuration,
                                            selectedProfession: $selectedProfession
                                        )
                                    case 2:
                                        InterestSelectionView(
                                            configuration: configuration,
                                            selectedInterests: $selectedInterests
                                        )
                                    default:
                                        OnboardingPageView(
                                            configuration: configuration,
                                            page: pages[index]
                                        )
                                    }
                                }
                                .frame(width: geometry.size.width)
                            }
                        }
                        .offset(x: -CGFloat(currentPage) * geometry.size.width)
                        .animation(.easeInOut(duration: configuration.theme.animationDuration), value: currentPage)
                    }
                    
                    // Bottom section
                    VStack(spacing: 24) {
                        // Page indicators
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .foregroundColor(index == currentPage ? configuration.theme.primaryColor : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3), value: currentPage)
                            }
                        }
                        
                        // Action buttons
                        HStack(spacing: 16) {
                            if currentPage > 0 {
                                Button("Back") {
                                    performHaptic(.light)
                                    withAnimation(.easeInOut(duration: configuration.theme.animationDuration)) {
                                        currentPage -= 1
                                    }
                                }
                                .buttonStyle(SecondaryButtonStyle(theme: configuration.theme))
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                            }
                            
                            Spacer()
                            
                            Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                                performHaptic(.medium)
                                if currentPage == pages.count - 1 {
                                    performHaptic(.success)
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showPersonalizedLoading = true
                                    }
                                } else {
                                    withAnimation(.easeInOut(duration: configuration.theme.animationDuration)) {
                                        currentPage += 1
                                    }
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle(theme: configuration.theme, isEnabled: canProceed))
                            .disabled(!canProceed)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentPage {
        case 1: return !selectedProfession.isEmpty
        case 2: return !selectedInterests.isEmpty
        default: return true
        }
    }
    
    private func performHaptic(_ type: HapticType) {
        guard configuration.enableHaptics else { return }
        
        Task { @MainActor in
            switch type {
            case .light:
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            case .medium:
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            case .success:
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
            case .selection:
                let selectionFeedback = UISelectionFeedbackGenerator()
                selectionFeedback.selectionChanged()
            }
        }
    }
}

// MARK: - Supporting Views

struct ProfessionSelectionView: View {
    let configuration: OnboardingConfiguration
    @Binding var selectedProfession: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("What's your profession?")
                        .font(configuration.theme.titleFont)
                        .foregroundColor(configuration.theme.textColor)
                    
                    Text("Help us personalize your experience")
                        .font(configuration.theme.bodyFont)
                        .foregroundColor(configuration.theme.secondaryTextColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                    ForEach(configuration.professions) { profession in
                        ProfessionCard(
                            configuration: configuration,
                            profession: profession,
                            isSelected: selectedProfession == profession.title
                        ) {
                            performHaptic(configuration.enableHaptics)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedProfession = profession.title
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                if !selectedProfession.isEmpty {
                    VStack(spacing: 8) {
                        Text("Selected: \(selectedProfession)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(configuration.theme.primaryColor)
                        
                        Text("Perfect! We'll customize content for you.")
                            .font(configuration.theme.captionFont)
                            .foregroundColor(configuration.theme.secondaryTextColor)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    private func performHaptic(_ enabled: Bool) {
        guard enabled else { return }
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

struct InterestSelectionView: View {
    let configuration: OnboardingConfiguration
    @Binding var selectedInterests: Set<String>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("What interests you?")
                        .font(configuration.theme.titleFont)
                        .foregroundColor(configuration.theme.textColor)
                    
                    Text("Select up to \(configuration.maxInterestSelection) topics")
                        .font(configuration.theme.bodyFont)
                        .foregroundColor(configuration.theme.secondaryTextColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(configuration.interests) { interest in
                        InterestCard(
                            configuration: configuration,
                            interest: interest,
                            isSelected: selectedInterests.contains(interest.title),
                            isDisabled: !selectedInterests.contains(interest.title) && selectedInterests.count >= configuration.maxInterestSelection
                        ) {
                            performHaptic(configuration.enableHaptics)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedInterests.contains(interest.title) {
                                    selectedInterests.remove(interest.title)
                                } else if selectedInterests.count < configuration.maxInterestSelection {
                                    selectedInterests.insert(interest.title)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 8) {
                    if !selectedInterests.isEmpty {
                        Text("Selected: \(selectedInterests.count)/\(configuration.maxInterestSelection) topics")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(configuration.theme.primaryColor)
                        
                        Text(selectedInterests.count == configuration.maxInterestSelection ? "Perfect selection!" : "Choose \(configuration.maxInterestSelection - selectedInterests.count) more topics")
                            .font(configuration.theme.captionFont)
                            .foregroundColor(configuration.theme.secondaryTextColor)
                    } else {
                        Text("Select at least 1 topic to continue")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.orange)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            .padding(.bottom, 40)
        }
    }
    
    private func performHaptic(_ enabled: Bool) {
        guard enabled else { return }
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

// MARK: - Card Views

struct ProfessionCard: View {
    let configuration: OnboardingConfiguration
    let profession: ProfessionOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(profession.emoji)
                    .font(.system(size: 36))
                
                Text(profession.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : configuration.theme.textColor)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: configuration.theme.cornerRadius)
                    .foregroundColor(isSelected ? configuration.theme.primaryColor : configuration.theme.cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: configuration.theme.cornerRadius)
                            .stroke(isSelected ? configuration.theme.primaryColor : configuration.theme.borderColor, lineWidth: 1.5)
                    )
            )
            .shadow(
                color: isSelected ? configuration.theme.primaryColor.opacity(0.3) : configuration.theme.shadowColor,
                radius: isSelected ? 6 : configuration.theme.shadowRadius,
                x: 0,
                y: isSelected ? 3 : 1
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InterestCard: View {
    let configuration: OnboardingConfiguration
    let interest: InterestOption
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(interest.emoji)
                    .font(.system(size: 32))
                
                Text(interest.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textColor)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1.5)
                    )
            )
            .shadow(
                color: shadowColor,
                radius: isSelected ? 6 : 3,
                x: 0,
                y: isSelected ? 3 : 1
            )
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return configuration.theme.primaryColor
        } else if isDisabled {
            return Color.gray.opacity(0.1)
        } else {
            return configuration.theme.cardBackgroundColor
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return configuration.theme.primaryColor
        } else if isDisabled {
            return Color.gray.opacity(0.2)
        } else {
            return configuration.theme.borderColor
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isDisabled {
            return Color.gray
        } else {
            return configuration.theme.textColor
        }
    }
    
    private var shadowColor: Color {
        if isDisabled {
            return Color.black.opacity(0.05)
        } else if isSelected {
            return configuration.theme.primaryColor.opacity(0.3)
        } else {
            return configuration.theme.shadowColor
        }
    }
}

// MARK: - Loading View

struct PersonalizedLoadingView: View {
    let configuration: OnboardingConfiguration
    let profession: String
    let interests: [String]
    let onComplete: () -> Void
    
    @State private var currentStep = 0
    @State private var loadingProgress: CGFloat = 0
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            // Title
            VStack(spacing: 16) {
                Text("✨")
                    .font(.system(size: 60))
                    .rotationEffect(.degrees(loadingProgress * 360))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: loadingProgress)
                
                if showCheckmark {
                    Text("All Set!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(configuration.theme.textColor)
                        .transition(.opacity)
                } else {
                    Text(currentStep < configuration.loadingSteps.count ? configuration.loadingSteps[currentStep] : "Ready!")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(configuration.theme.textColor)
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut(duration: configuration.theme.animationDuration), value: currentStep)
                }
            }
            
            // Progress bar section
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    ZStack(alignment: .leading) {
                        // Background bar
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        // Progress bar
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [configuration.theme.primaryColor, configuration.theme.secondaryColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, loadingProgress * UIScreen.main.bounds.width * 0.7), height: 8)
                            .animation(.easeInOut(duration: 0.5), value: loadingProgress)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    
                    // Loading text under the bar
                    Text(currentStep < configuration.loadingTexts.count ? configuration.loadingTexts[currentStep] : "Complete!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(configuration.theme.secondaryTextColor)
                        .animation(.easeInOut(duration: configuration.theme.animationDuration), value: currentStep)
                }
                
                // Progress percentage
                if !showCheckmark {
                    Text("\(Int(loadingProgress * 100))%")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(configuration.theme.primaryColor)
                        .animation(.easeInOut(duration: configuration.theme.animationDuration), value: loadingProgress)
                }
            }
            
            // User selection summary
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "person.fill")
                        .foregroundColor(configuration.theme.primaryColor)
                    Text(profession)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(configuration.theme.textColor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(configuration.theme.primaryColor.opacity(0.1))
                )
                
                if !interests.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(interests.prefix(configuration.maxInterestSelection), id: \.self) { interest in
                            Text(interest)
                                .font(configuration.theme.captionFont)
                                .foregroundColor(configuration.theme.secondaryTextColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(Color.gray.opacity(0.1))
                                )
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            startLoadingSequence()
        }
    }
    
    private func startLoadingSequence() {
        let loadingStepsCount = configuration.loadingSteps.count
        let animationDuration = configuration.theme.animationDuration
        
        Task { @MainActor in
            for step in 0..<loadingStepsCount {
                try? await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
                
                withAnimation(.easeInOut(duration: animationDuration)) {
                    currentStep = step + 1
                    loadingProgress = CGFloat(step + 1) / CGFloat(loadingStepsCount)
                }
            }
            
            // Complete loading
            withAnimation(.easeInOut(duration: 0.5)) {
                loadingProgress = 1.0
            }
            
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showCheckmark = true
            }
            
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            onComplete()
        }
    }
}

// MARK: - Page View

struct OnboardingPageView: View {
    let configuration: OnboardingConfiguration
    let page: OnboardingPageModel
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(page.backgroundColor)
                    .frame(width: 160, height: 160)
                    .shadow(color: page.backgroundColor.opacity(0.4), radius: 12, x: 0, y: 6)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(configuration.theme.textColor)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(configuration.theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1.5)
            }
            .padding(.horizontal, 28)
            
            Spacer()
        }
        .padding(.vertical, 32)
    }
}

// MARK: - Supporting Models

struct OnboardingPageModel: Sendable {
    let title: String
    let description: String
    let iconName: String
    let backgroundColor: Color
}

enum HapticType: Sendable {
    case light, medium, success, selection
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    let theme: OnboardingTheme
    let isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.buttonFont)
            .foregroundColor(.white)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .foregroundColor(isEnabled ? theme.primaryColor : Color.gray.opacity(0.5))
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    let theme: OnboardingTheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.buttonFont)
            .foregroundColor(theme.primaryColor)
            .frame(width: 90, height: 48)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .foregroundColor(theme.cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.cornerRadius)
                            .stroke(theme.primaryColor, lineWidth: 1.5)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Usage Example

/*
 How to use this package in your app:
 
 1. Add this package to your project
 2. Import OnboardingFlow
 3. Use it like this:
 
 import SwiftUI
 import OnboardingFlow
 
 struct ContentView: View {
     @State private var showOnboarding = true
     
     var body: some View {
         if showOnboarding {
             OnboardingFlowView(
                 configuration: OnboardingConfiguration(
                     theme: OnboardingTheme(
                         primaryColor: .blue,
                         secondaryColor: .purple
                     ),
                     professions: [
                         ProfessionOption(emoji: "👨‍🏫", title: "Teacher"),
                         ProfessionOption(emoji: "👩‍🎓", title: "Student"),
                         // Add more professions...
                     ],
                     interests: [
                         InterestOption(emoji: "🎓", title: "Education"),
                         InterestOption(emoji: "🔬", title: "Science"),
                         // Add more interests...
                     ],
                     maxInterestSelection: 3,
                     loadingSteps: [
                         "Setting up your profile...",
                         "Customizing experience...",
                         "Almost ready!"
                     ]
                 )
             ) { result in
                 // Handle completion
                 print("Profession: \(result.profession)")
                 print("Interests: \(result.interests)")
                 print("Completed: \(result.isCompleted)")
                 
                 showOnboarding = false
             }
         } else {
             // Your main app content
             Text("Welcome to the app!")
         }
     }
 }
 
 // Custom theme example:
 let customTheme = OnboardingTheme(
     primaryColor: Color(red: 0.2, green: 0.6, blue: 1.0),
     secondaryColor: Color(red: 0.8, green: 0.3, blue: 0.9),
     backgroundColor: Color(.systemBackground),
     textColor: .primary,
     secondaryTextColor: .secondary,
     titleFont: .system(size: 32, weight: .bold, design: .rounded),
     bodyFont: .system(size: 20, weight: .regular),
     cornerRadius: 16,
     animationDuration: 0.4
 )
 
 // Custom professions example:
 let customProfessions = [
     ProfessionOption(emoji: "👨‍💻", title: "Software Engineer"),
     ProfessionOption(emoji: "👩‍🎨", title: "Designer"),
     ProfessionOption(emoji: "👨‍🔬", title: "Researcher"),
     ProfessionOption(emoji: "👩‍💼", title: "Manager"),
     ProfessionOption(emoji: "🏃‍♂️", title: "Athlete"),
     ProfessionOption(emoji: "🎭", title: "Artist")
 ]
 
 // Custom interests example:
 let customInterests = [
     InterestOption(emoji: "🤖", title: "AI & Machine Learning"),
     InterestOption(emoji: "🚀", title: "Space Exploration"),
     InterestOption(emoji: "🌱", title: "Sustainability"),
     InterestOption(emoji: "🎬", title: "Film & Media"),
     InterestOption(emoji: "🧬", title: "Biotechnology"),
     InterestOption(emoji: "🏛️", title: "Politics"),
     InterestOption(emoji: "💰", title: "Finance"),
     InterestOption(emoji: "🎪", title: "Entertainment")
 ]
 
 */
