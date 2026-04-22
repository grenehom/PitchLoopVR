import SwiftUI

enum AppScreen: Equatable {
    case roleSelection
    case speakerFeedback
    case speakerCueInstruction
    case speakerStartSession
    case speakerCountdown
    case speakerSession
    case speakerSummary
    case speakerScorecard
    case speakerFeedbackReview(String)
    case audienceOnboarding
    case audienceReminder
    case audienceReady
    case audienceWaiting
    case audienceFeedback
}

struct ContentView: View {
    @State private var screen: AppScreen = .roleSelection
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(AppModel.self) private var appModel
    @Environment(AudienceFeedbackModel.self) private var feedbackModel

    var body: some View {
        Group {
            switch screen {
        case .roleSelection:
            RoleSelectionView { role in
                screen = (role == .audience) ? .audienceOnboarding : .speakerFeedback
            }
            .frame(width: 726, height: 281)
            .fixedSize()

        case .speakerFeedback:
            SpeakerFeedbackView(
                onDismiss: { screen = .roleSelection },
                onNext: { screen = .speakerCueInstruction }
            )
            .frame(width: 640, height: 280)
            .fixedSize()

        case .speakerCueInstruction:
            SpeakerCueInstructionView(
                onDismiss: { screen = .roleSelection },
                onNext: { screen = .speakerStartSession }
            )
            .frame(width: 640, height: 280)
            .fixedSize()

        case .speakerStartSession:
            SpeakerStartSessionView(onNext: { screen = .speakerCountdown })
                .frame(width: 640)
                .fixedSize()

        case .speakerCountdown:
            SpeakerCountdownView(onNext: { screen = .speakerSession })
                .frame(width: 400, height: 300)
                .fixedSize()

        case .speakerSession:
            Color.clear
                .frame(width: 1, height: 1)
                .fixedSize()

        case .speakerSummary:
            PresentationSummaryView(
                onDone: {
                    dismissWindow(id: "speaker-session")
                    appModel.speakerSessionCompleted = false
                    screen = .roleSelection
                },
                onScorecard: { screen = .speakerScorecard }
            )
            .frame(width: 480)
            .fixedSize()

        case .speakerScorecard:
            SpeakerScorecardView(
                onBack: { screen = .speakerSummary },
                onReview: { title in screen = .speakerFeedbackReview(title) }
            )
            .frame(width: 780, height: 560)
            .fixedSize()

        case .speakerFeedbackReview(let title):
            FeedbackReviewView(
                title: title,
                onBack: { screen = .speakerScorecard }
            )
            .frame(width: 560, height: 680)
            .fixedSize()

        case .audienceOnboarding:
            AudienceOnboardingView(
                onDismiss: { screen = .roleSelection },
                onNext: {
                    feedbackModel.isTutorialMode = true
                    feedbackModel.tutorialStep = 0
                    feedbackModel.tutorialComplete = false
                    feedbackModel.liveSessionStarted = false
                    screen = .audienceFeedback
                    openWindow(id: "audience-feedback")
                }
            )
            .frame(width: 640, height: 280)
            .fixedSize()

        case .audienceReminder:
            AudienceReminderView(
                onDismiss: { screen = .roleSelection },
                onNext: { screen = .audienceReady }
            )
            .frame(width: 640, height: 280)
            .fixedSize()

        case .audienceReady:
            AudienceReadyView(
                onDismiss: { screen = .roleSelection },
                onBack: { screen = .audienceReminder },
                onReady: { screen = .audienceWaiting }
            )
            .frame(width: 640)
            .fixedSize()

        case .audienceWaiting:
            AudienceWaitingView(onNext: {
                feedbackModel.liveSessionStarted = true
                screen = .audienceFeedback
            })
            .fixedSize()

        case .audienceFeedback:
            if feedbackModel.isTutorialMode && feedbackModel.activeFeedbackItem != nil {
                FeedbackQuestionView()
                    .frame(width: 360)
                    .fixedSize()
            } else {
                Color.clear
                    .frame(width: 1, height: 1)
                    .fixedSize()
            }
            }
        }
        // Hide glass chrome during speaker session (plain window style on main)
        .glassBackgroundEffect(displayMode: { if case .speakerSession = screen { return .never }; return .implicit }())
        // Tutorial complete → move to reminder screen
        .onChange(of: feedbackModel.tutorialComplete) {
            if feedbackModel.tutorialComplete { screen = .audienceReminder }
        }
        // Speaker ends session → transition main window to summary
        .onChange(of: appModel.shouldEndSession) {
            if appModel.shouldEndSession {
                appModel.shouldEndSession = false
                screen = .speakerSummary
            }
        }
        // Open/close windows based on active screen
        .onChange(of: screen) {
            let newScreen = screen
            // Cue preview pill (plain window)
            let showCue = newScreen == .speakerCueInstruction
            if showCue {
                openWindow(id: "cue-preview")
            } else {
                dismissWindow(id: "cue-preview")
            }

            // Speaker session controls (plain window; also dismisses main on appear)
            if newScreen == .speakerSession {
                openWindow(id: "speaker-session")
            }

            // Waiting-for-participants pill (plain window)
            if newScreen == .speakerStartSession {
                openWindow(id: "waiting-participants")
            } else {
                dismissWindow(id: "waiting-participants")
            }
        }
    }
}

enum UserRole: String {
    case speaker = "Speaker"
    case audience = "Audience"
}

struct RoleSelectionView: View {
    let onNavigate: (UserRole) -> Void
    @State private var selectedRole: UserRole? = nil

    var body: some View {
        VStack(spacing: 54) {
            Text("Choose your preferred Role")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            VStack(spacing: 26) {
                RoleButton(
                    title: "Join as Speaker",
                    isSelected: selectedRole == .speaker
                ) {
                    selectedRole = .speaker
                    onNavigate(.speaker)
                }

                RoleButton(
                    title: "Join as Audience",
                    isSelected: selectedRole == .audience
                ) {
                    selectedRole = .audience
                    onNavigate(.audience)
                }
            }
        }
        .frame(maxWidth: 520)
        .padding()
    }
}

struct RoleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 34)
            .frame(width: 350, height: 60)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.blue : Color.white.opacity(0.28))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(isSelected ? 0.0 : 0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
