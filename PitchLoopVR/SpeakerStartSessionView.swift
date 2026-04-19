import SwiftUI

struct SpeakerStartSessionView: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                .frame(width: 44, height: 44)
                .padding(.bottom, 14)

            Text("You're all set!")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.bottom, 10)

            Text("Stretch, drink some water, and start the session when everyone is ready.")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 460)
                .padding(.bottom, 28)

            Button(action: onNext) {
                Text("Start Session")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 10)
                    .background(Capsule(style: .continuous).fill(Color.blue))
            }
            .buttonStyle(.plain)
        }
        .padding(40)
        .frame(maxWidth: 560)
    }
}

// Shown as a separate plain window above the main window
struct WaitingParticipantsView: View {
    var participantCount: Int = 1

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.red)
                .frame(width: 9, height: 9)
            Text("Waiting for \(participantCount) participant\(participantCount == 1 ? "" : "s") to join")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))
        .overlay(Capsule(style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
        .padding(8)
    }
}

#Preview {
    SpeakerStartSessionView(onNext: {})
}
