/*
 AudienceView.swift
 Live Interactions — PitchLoop VR

 Updated: removed all background panels entirely.
 Now shows ONLY:
   - AudienceFeedbackPanel (bottom pill + center modal) floating over the immersive space
   - "Feedback Sent" confirmation badge top-left after sending (matches image 4)
*/

import SwiftUI

struct AudienceView: View {

    let onLeave: () -> Void

    @EnvironmentObject var feedbackStore: FeedbackStore

    // Controls the "Feedback Sent" badge at top-left
    @State private var showFeedbackSent = false

    var body: some View {
        ZStack {

            // ── "Feedback Sent" confirmation — top left ──────────────
            // Appears for 3 seconds after audience sends any feedback.
            // Matches image 4: green pill, checkmark, "Feedback Sent".
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Button("Leave Session") {
                            onLeave()
                        }
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .buttonStyle(.plain)

                        if showFeedbackSent {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Feedback Sent")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }

                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                Spacer()
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showFeedbackSent)

            // ── Feedback panel — bottom pill + center modal ──────────
            // AudienceFeedbackPanel handles both the pill and the modal.
            // onFeedbackSent fires after audience selects an option.
            AudienceFeedbackPanel(onFeedbackSent: {
                showFeedbackSent = true
                Task {
                    try? await Task.sleep(for: .seconds(3))
                    await MainActor.run {
                        withAnimation {
                            showFeedbackSent = false
                        }
                    }
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}
