import SwiftUI

struct SessionNotification: Equatable {
    let icon: String
    let text: String
}

// MARK: - Session controls (plain window, no glass chrome)

struct SpeakerSessionView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if appModel.speakerSessionCompleted {
                // Presentation Complete pill
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.green)
                    Text("Presentation Complete")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))
            } else {
                // Active session controls
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                        Text("Presenting")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))

                    Button(action: endSession) {
                        Text("End Presentation")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(0.12))
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(4)
        .onAppear {
            // Sample notification — onChange will open the notification window
            appModel.speakerNotification = SessionNotification(icon: "waveform", text: "Pace is too fast")
        }
        // Open notification window when a notification is queued
        .onChange(of: appModel.speakerNotification) { _, notification in
            if notification != nil {
                openWindow(id: "session-notification")
            }
        }
    }

    private func endSession() {
        appModel.speakerSessionCompleted = true
        appModel.shouldEndSession = true
    }
}

// MARK: - Notification window (plain, no glass chrome)

struct SessionNotificationWindow: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismiss) private var dismiss
    @State private var dismissTask: Task<Void, Never>? = nil

    var body: some View {
        Group {
            if let n = appModel.speakerNotification {
                SessionNotificationBanner(icon: n.icon, text: n.text)
            }
        }
        .padding(8)
        .onAppear { scheduleDismiss() }
        .onChange(of: appModel.speakerNotification) { _, _ in scheduleDismiss() }
    }

    private func scheduleDismiss() {
        dismissTask?.cancel()
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(3))
            appModel.speakerNotification = nil
            dismiss()
        }
    }
}

// MARK: - Reusable banner pill

struct SessionNotificationBanner: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))
        .overlay(Capsule(style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}

#Preview {
    SpeakerSessionView()
        .environment(AppModel())
        .fixedSize()
}
