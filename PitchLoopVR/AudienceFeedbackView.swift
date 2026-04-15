import SwiftUI

struct AudienceFeedbackView: View {
    let onDismiss: () -> Void

    let feedbackItems: [AudienceFeedbackItem] = [
        AudienceFeedbackItem(icon: "eye", label: "Eye Contact"),
        AudienceFeedbackItem(icon: "clock", label: "Timing"),
        AudienceFeedbackItem(icon: "waveform", label: "Pace"),
        AudienceFeedbackItem(icon: "list.bullet.rectangle", label: "Structure"),
        AudienceFeedbackItem(icon: "person.fill", label: "Confidence")
    ]

    @State private var selectedStatus: FeedbackStatus? = nil
    @State private var selectedItem: AudienceFeedbackItem? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 22) {
                topBar

                VStack(spacing: 14) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(.blue)

                    Text("Audience Feedback")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("Monitor the speaker's performance. Tap an icon below to flag an issue in real-time.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 420)
                }

                HStack(spacing: 14) {
                    statusChip(
                        title: "Good",
                        color: .green,
                        isSelected: selectedStatus == .good
                    ) {
                        selectedStatus = .good
                    }

                    statusChip(
                        title: "Issue",
                        color: .red,
                        isSelected: selectedStatus == .issue
                    ) {
                        selectedStatus = .issue
                    }
                }

                Button(action: {
                    print("Start Session tapped")
                }) {
                    Text("Start Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 420)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.blue)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
            .padding(.horizontal, 36)
            .padding(.top, 28)

            VStack {
                Spacer()

                HStack(spacing: 18) {
                    ForEach(feedbackItems) { item in
                        feedbackIconButton(item: item)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 18)
                .background(
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 18, x: 0, y: 8)
                .padding(.bottom, 34)
            }
        }
        .padding()
    }

    private var topBar: some View {
        HStack {
            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary.opacity(0.7))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
        }
    }

    private func statusChip(
        title: String,
        color: Color,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .frame(width: 165, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.white.opacity(0.14) : Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(isSelected ? 0.18 : 0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func feedbackIconButton(item: AudienceFeedbackItem) -> some View {
        let isSelected = selectedItem?.id == item.id

        return Button(action: {
            selectedItem = item
        }) {
            Image(systemName: item.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.primary.opacity(0.9))
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(isSelected ? Color.white.opacity(0.16) : Color.clear)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct AudienceFeedbackItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let label: String
}

enum FeedbackStatus {
    case good
    case issue
}

#Preview {
    AudienceFeedbackView(onDismiss: {})
}
