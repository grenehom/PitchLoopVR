import SwiftUI

struct SpeakerFeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goToNext = false
    
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 18) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 38, weight: .regular))
                    .foregroundStyle(.blue)

                Text("Before you begin")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("You’ll receive feedback as you speak.\nSubtle cues will help you adjust in the moment.")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .frame(maxWidth: 460)

                Text("tap to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, 30)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary.opacity(0.9))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .padding(.top, 28)
            .padding(.trailing, 28)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            goToNext = true
        }
        .navigationDestination(isPresented: $goToNext) {
            SpeakerCueInstructionView()
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    NavigationStack {
        SpeakerFeedbackView()
    }
}
