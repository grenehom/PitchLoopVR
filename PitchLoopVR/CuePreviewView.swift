import SwiftUI

struct CuePreviewView: View {
    var body: some View {
        HStack() {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    .frame(width: 62, height: 62)

                Image(systemName: "waveform")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text("Pace Yourself")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}
