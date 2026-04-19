import SwiftUI

struct SpeakerCountdownView: View {
    let onNext: () -> Void

    @State private var count = 3

    var body: some View {
        VStack(spacing: 12) {
            Text("Session Start In")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.secondary)

            Text("\(count)")
                .font(.system(size: 96, weight: .bold))
                .foregroundStyle(.primary)
                .id(count)
                .transition(.asymmetric(
                    insertion: .scale(scale: 1.4).combined(with: .opacity),
                    removal: .scale(scale: 0.6).combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.25), value: count)
        }
        .padding(60)
        .onAppear {
            startCountdown()
        }
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if count > 1 {
                withAnimation {
                    count -= 1
                }
            } else {
                timer.invalidate()
                onNext()
            }
        }
    }
}

#Preview {
    SpeakerCountdownView(onNext: {})
}
