/*
 SpeakerView.swift
 Live Interactions — PitchLoop VR

 Updated: removed the instructions panel entirely.
 Now shows ONLY:
   - "Presenting" badge + "End Presentation" button stacked at top-left (matches image 2)
   - SpeakerFeedbackOverlay at top-center (notification pills from audience)
 The immersive space and SharePlay personas fill the rest of the view.
*/

import SwiftUI

struct SpeakerView: View {

    let onLeave: () -> Void
    @EnvironmentObject var feedbackStore: FeedbackStore

    var body: some View {
        ZStack(alignment: .top) {

            // ─ Top-left: Presenting badge + End Presentation button ─
            // Matches image 2: stacked vertically, top-left corner
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // "• Presenting" badge
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                        Text("Presenting")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.regularMaterial, in: Capsule())

                    Spacer()
                }

                // "End Presentation" button — below the badge
                Button("End Presentation") {
                    feedbackStore.endSession()
                    onLeave()
                }
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: Capsule())
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 20)

            // ── Top-center: notification pills from audience ──────────
            // SpeakerFeedbackOverlay reads pendingFeedback from FeedbackStore
            // and shows animated pill banners centered at top.
            VStack {
                SpeakerFeedbackOverlay()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
