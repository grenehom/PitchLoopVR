/*
 AudienceView.swift
 Live Interactions — PitchLoop VR

 Updated: removed all background panels entirely.
 Now shows ONLY:
   - AudienceFeedbackPanel (bottom pill + center modal) floating over the immersive space
   - "Feedback Sent" confirmation badge top-left after sending (matches image 4)
*/

import SwiftUI

private enum SessionChoice {
    case yes
    case no
}

struct AudienceView: View {

    let onLeave: () -> Void

    @EnvironmentObject var feedbackStore: FeedbackStore

    // Controls the "Feedback Sent" badge at top-left
    @State private var showFeedbackSent = false
    @State private var mainPointChoice: SessionChoice? = nil
    @State private var confidenceChoice: SessionChoice? = nil
    @State private var didSubmitSessionFeedback = false

    private var canSubmitSessionFeedback: Bool {
        mainPointChoice != nil && confidenceChoice != nil
    }

    var body: some View {
        ZStack {

            // ── "Feedback Sent" confirmation — top left ──────────────
            // Appears for 3 seconds after audience sends any feedback.
            // Matches image 4: green pill, checkmark, "Feedback Sent".
            if !feedbackStore.sessionEnded {
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
            }

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

            if feedbackStore.sessionEnded {
                SessionEndOverlayCard(
                    didSubmit: didSubmitSessionFeedback,
                    mainPointChoice: $mainPointChoice,
                    confidenceChoice: $confidenceChoice,
                    canSubmit: canSubmitSessionFeedback,
                    onClose: {
                        feedbackStore.resetSessionEndState()
                    },
                    onSubmit: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            didSubmitSessionFeedback = true
                        }
                    },
                    onViewScoreCard: {
                        feedbackStore.resetSessionEndState()
                    },
                    onLeaveSession: {
                        feedbackStore.resetSessionEndState()
                        onLeave()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.82), value: feedbackStore.sessionEnded)
        .onChange(of: feedbackStore.sessionEnded) { _, isEnded in
            if isEnded {
                mainPointChoice = nil
                confidenceChoice = nil
                didSubmitSessionFeedback = false
            }
        }
    }
}

private struct SessionEndOverlayCard: View {
    let didSubmit: Bool
    @Binding var mainPointChoice: SessionChoice?
    @Binding var confidenceChoice: SessionChoice?
    let canSubmit: Bool
    let onClose: () -> Void
    let onSubmit: () -> Void
    let onViewScoreCard: () -> Void
    let onLeaveSession: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if didSubmit { submittedBody } else { questionnaireBody }
        }
        .frame(width: 420)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thickMaterial)
                .overlay(RoundedRectangle(cornerRadius: 24).fill(Color.black.opacity(0.22)))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.3), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.22), radius: 30, y: 10)
        .padding(.bottom, 120)
    }

    private var questionnaireBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text("Session Ended")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Could you follow the speaker's main\npoint?")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack(spacing: 10) {
                        ChoiceButton(
                            title: "Yes",
                            isSelected: mainPointChoice == .yes
                        ) { mainPointChoice = .yes }

                        ChoiceButton(
                            title: "No",
                            isSelected: mainPointChoice == .no
                        ) { mainPointChoice = .no }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Did the speaker come across as\nconfident?")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack(spacing: 10) {
                        ChoiceButton(
                            title: "Yes",
                            isSelected: confidenceChoice == .yes
                        ) { confidenceChoice = .yes }

                        ChoiceButton(
                            title: "No",
                            isSelected: confidenceChoice == .no
                        ) { confidenceChoice = .no }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Button(action: onSubmit) {
                Text("Submit Feedback")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white.opacity(canSubmit ? 1.0 : 0.85))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        Capsule()
                            .fill(canSubmit ? Color.blue : Color(white: 0.35, opacity: 0.9))
                    )
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit)
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
    }

    private var submittedBody: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 72, height: 72)
                    .shadow(color: .green.opacity(0.4), radius: 18)
                Image(systemName: "checkmark")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 24)

            Text("Feedback Submitted")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Text("Waiting for speaker to view scorecard together")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button(action: onViewScoreCard) {
                Text("View Score Card")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Capsule().fill(.blue)) 
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Button(action: onLeaveSession) {
                Text("Leave Session")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Capsule().fill(Color(white: 0.35, opacity: 0.9)))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }
}

private struct ChoiceButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Capsule()
                        .fill(isSelected ? .blue : Color(white: 0.35, opacity: 0.82))
                )
        }
        .buttonStyle(.plain)
    }
}
