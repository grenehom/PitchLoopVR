/*
 SpeakerFeedbackOverlay.swift
 Live Interactions — PitchLoop VR

 Updated pill design to match image 2:
   - Light/white .regularMaterial background (not dark)
   - Left: white circle with colored SF Symbol icon
   - Right: notificationText in dark text e.g. "Pace is too fast"
   - Auto-dismisses after 5 seconds, tap to dismiss early
   - Stacks vertically if multiple arrive at once
*/

import SwiftUI

// MARK: - Overlay Container

struct SpeakerFeedbackOverlay: View {

    @EnvironmentObject var feedbackStore: FeedbackStore

    var body: some View {
        VStack(spacing: 10) {
            ForEach(feedbackStore.pendingFeedback) { message in
                FeedbackBanner(message: message) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        feedbackStore.dismiss(message: message)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal:   .move(edge: .top).combined(with: .opacity)
                    )
                )
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8),
                   value: feedbackStore.pendingFeedback.count)
    }
}

// MARK: - Notification Pill

/*
 Matches image 2 exactly:
   - Light material pill (regularMaterial — white/frosted in visionOS)
   - Left: white circle containing the SF Symbol icon (with colored tint)
   - Right: notificationText e.g. "Pace is too fast"
   - Tap anywhere to dismiss early
   - Auto-dismisses after 5 seconds with fade
*/
struct FeedbackBanner: View {

    let message: FeedbackMessage
    let onDismiss: () -> Void

    @State private var opacity: Double = 0

    var body: some View {
        Button(action: onDismiss) {
            HStack(spacing: 12) {

                // Circular icon — white circle with colored icon inside
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.08), radius: 2)

                    Text(message.type.emoji)
                        .font(.system(size: 22))
                }

                // Notification text — dark, matches image 2
                Text(message.notificationText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
        .opacity(opacity)
        .onAppear {
            // Fade in
            withAnimation(.easeOut(duration: 0.25)) {
                opacity = 1
            }
            // Auto-dismiss after 5 seconds
            Task {
                try? await Task.sleep(for: .seconds(4.5))
                withAnimation(.easeIn(duration: 0.5)) {
                    opacity = 0
                }
                try? await Task.sleep(for: .seconds(0.5))
                onDismiss()
            }
        }
    }
}
