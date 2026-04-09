import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RoleSelectionView()
        }
        .frame(width: 726, height: 281)
        .fixedSize()
    }
}

enum UserRole: String {
    case speaker = "Speaker"
    case audience = "Audience"
}

struct RoleSelectionView: View {
    @State private var selectedRole: UserRole? = nil
    @State private var goToNext = false

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
                    goToNext = true
                }

                RoleButton(
                    title: "Join as Audience",
                    isSelected: selectedRole == .audience
                ) {
                    selectedRole = .audience
                    goToNext = true
                }
            }
        }
        .frame(maxWidth: 520)
        .padding()
        .navigationDestination(isPresented: $goToNext) {
            if selectedRole == .audience {
                AudienceFeedbackView()
            } else {
                SpeakerFeedbackView()
            }
        }
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
