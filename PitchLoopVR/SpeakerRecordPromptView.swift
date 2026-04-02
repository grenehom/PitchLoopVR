import SwiftUI

struct SpeakerRecordPromptView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goToNext = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 38, weight: .regular))
                    .foregroundStyle(.blue)

                Text("Record a practice run?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Review your performance and plan your next improvement")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 520)

                HStack(spacing: 20) {
                    Button(action: {
                        goToNext = true
                    }) {
                        Text("Record")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 220, height: 56)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(0.26))
                            )
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        goToNext = true
                    }) {
                        Text("Skip")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 220, height: 56)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(0.14))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)

                Text("tap to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, 18)
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
            SpeakerRecordingView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SpeakerRecordPromptView()
    }
}
