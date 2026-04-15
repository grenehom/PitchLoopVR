import SwiftUI

struct SpeakerStartSessionView: View {
    let onNext: () -> Void

    @State private var participantCount = 1

    var body: some View {
        VStack(spacing: 0) {
            // Icon
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
                .padding(.bottom, 22)

            Button(action: onNext) {
                Text("Start Session")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 10)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(40)
        .frame(maxWidth: 560)
        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 9, height: 9)
                Text("Waiting for \(participantCount) participant\(participantCount == 1 ? "" : "s") to join")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .glassBackgroundEffect(in: Capsule())
        }
    }
}

#Preview {
    SpeakerStartSessionView(onNext: {})
}
