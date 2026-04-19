import SwiftUI

struct LiveFeedbackItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let description: String
}

// MARK: - Icon bar

struct AudienceLiveFeedbackView: View {
    @Binding var hoveredItem: LiveFeedbackItem?
    var onSelect: (LiveFeedbackItem) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(audienceFeedbackItems) { item in
                let isHovered = hoveredItem?.id == item.id

                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(isHovered ? 0.18 : 0))
                            .frame(width: 68, height: 68)
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 68, height: 68)
                            .opacity(isHovered ? 1 : 0)
                        Image(systemName: item.icon)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(isHovered ? Color.blue : Color.primary.opacity(0.85))
                    }
                    .frame(width: 68, height: 68)

                    Text(item.label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        hoveredItem = hovering ? item : nil
                    }
                }
                .onTapGesture { onSelect(item) }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.15), value: hoveredItem?.id)
    }
}

// MARK: - Window wrapper

struct AudienceFeedbackWindow: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @Environment(AudienceFeedbackModel.self) private var feedbackModel
    @State private var hoveredItem: LiveFeedbackItem? = nil

    var body: some View {
        AudienceLiveFeedbackView(hoveredItem: $hoveredItem) { item in
            guard !feedbackModel.isTutorialMode else { return }
            if feedbackModel.activeFeedbackItem == nil {
                feedbackModel.activeFeedbackItem = item
                openWindow(id: "live-question")
            } else {
                feedbackModel.activeFeedbackItem = item
            }
        }
        .opacity(feedbackModel.isWaitingForSession ? 0.4 : 1.0)
        .allowsHitTesting(!feedbackModel.isWaitingForSession)
        .padding(16)
        .frame(width: 340)
        .fixedSize()
        .onAppear {
            if feedbackModel.isTutorialMode {
                openTutorialStep()
            }
            // Main window is kept open — it's reused for question display
        }
        .onChange(of: feedbackModel.tutorialStep) { _, _ in
            if feedbackModel.isTutorialMode {
                openTutorialStep()
            }
        }
        .onChange(of: feedbackModel.liveSessionStarted) { _, started in
            if started {
                feedbackModel.isTutorialMode = false
                hoveredItem = nil
                dismissWindow(id: "main")
            }
        }
        .ornament(
            visibility: hoveredItem != nil && !feedbackModel.isTutorialMode ? .visible : .hidden,
            attachmentAnchor: .scene(.top),
            contentAlignment: .bottom
        ) {
            HStack(spacing: 12) {
                Text(hoveredItem?.description ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                Button(action: { withAnimation { hoveredItem = nil } }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(width: 320)
            .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func openTutorialStep() {
        let item = audienceFeedbackItems[feedbackModel.tutorialStep]
        feedbackModel.activeFeedbackItem = item
        hoveredItem = item
        // No openWindow — main window handles display via activeFeedbackItem
    }
}

#Preview {
    AudienceLiveFeedbackView(hoveredItem: .constant(nil))
        .padding(16)
        .frame(width: 380)
}
