import SwiftUI
import RealityKit


enum AppScreen {
    case roleSelection
    case speakerFeedback
    case speakerCueInstruction
    case speakerStartSession
    case speakerCountdown
    case speakerSession
    case speakerRecording
    case audienceOnboarding
    case audienceFeedback
}

struct ContentView: View {
    @State private var screen: AppScreen = .roleSelection
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(AppModel.self) private var appModel

    private var showCue: Bool {
        screen == .speakerCueInstruction || screen == .speakerRecording
    }

    var body: some View {
        Group {
            switch screen {
        case .roleSelection:
            RoleSelectionView { role in
                screen = (role == .audience) ? .audienceOnboarding : .speakerFeedback
            }
            .frame(width: 726, height: 281)
            .fixedSize()
        
        case .speakerSession:
            Color.clear

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

        case .speakerRecording:
            SpeakerRecordingView()
                .frame(width: 600, height: 700)
                .fixedSize()

        case .audienceOnboarding:
            AudienceOnboardingView(
                onDismiss: { screen = .roleSelection },
                onNext: {
                    screen = .audienceFeedback
                    openWindow(id: "audience-feedback")
                }
            )
            .frame(width: 640, height: 280)
            .fixedSize()

        case .audienceFeedback:
            Color.clear
                .frame(width: 1, height: 1)
                .fixedSize()
            }
        }
        .ornament(
            visibility: showCue ? .visible : .hidden,
            attachmentAnchor: .scene(.top),
            contentAlignment: .bottom
        ) {
            CuePreviewView()
        }
        .task {
            if appModel.immersiveSpaceState == .closed {
                appModel.immersiveSpaceState = .inTransition
                await openImmersiveSpace(id: appModel.immersiveSpaceID)
                appModel.immersiveSpaceState = .open
            }
        }
            CuePreviewView()
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
