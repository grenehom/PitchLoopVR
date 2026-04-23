/*
 FeedbackSubmittedView.swift
 Live Interactions — PitchLoop VR

 Shown after audience submits post-session feedback (Image 3).
*/
import SwiftUI

struct FeedbackSubmittedView: View {
    var onLeave: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            // Green checkmark circle
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 8)

            VStack(spacing: 10) {
                Text("Feedback Submitted")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Waiting for speaker to view scorecard together")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                // View Score Card — blue, prominent
                Button(action: {
                    // Score card not yet implemented — placeholder
                }) {
                    Text("View Score Card")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue)
                        )
                }
                .buttonStyle(.plain)

                // Leave Session — secondary
                Button(action: onLeave) {
                    Text("Leave Session")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.12))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(32)
        .frame(width: 480)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.22))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        )
    }
}//
//  FeedbackSubmittedView.swift
//  Live Interactions
//
//  Created by Dhruvi Jagani on 4/23/26.
//

