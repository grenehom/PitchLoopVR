/*
 SessionEndedView.swift
 Live Interactions — PitchLoop VR

 Shown in audience view after speaker ends the session.
 Two yes/no questions → Submit → FeedbackSubmittedView
*/
import SwiftUI

struct SessionEndedView: View {
    var onSubmit: () -> Void
    var onLeave: () -> Void

    @State private var followedMainPoint: Bool? = nil
    @State private var appearedConfident: Bool? = nil
    @State private var submitted = false

    var allAnswered: Bool {
        followedMainPoint != nil && appearedConfident != nil
    }

    var body: some View {
        if submitted {
            FeedbackSubmittedView(onLeave: onLeave)
        } else {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 28) {

                    Text("Session Ended")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)

                    // Question 1
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Could you follow the speaker's main point?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.primary)

                        HStack(spacing: 12) {
                            YesNoButton(
                                label: "Yes",
                                isSelected: followedMainPoint == true
                            ) { followedMainPoint = true }

                            YesNoButton(
                                label: "No",
                                isSelected: followedMainPoint == false
                            ) { followedMainPoint = false }
                        }
                    }

                    // Question 2
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Did the speaker come across as confident?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.primary)

                        HStack(spacing: 12) {
                            YesNoButton(
                                label: "Yes",
                                isSelected: appearedConfident == true
                            ) { appearedConfident = true }

                            YesNoButton(
                                label: "No",
                                isSelected: appearedConfident == false
                            ) { appearedConfident = false }
                        }
                    }

                    // Submit button
                    Button(action: {
                        guard allAnswered else { return }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            submitted = true
                        }
                        onSubmit()
                    }) {
                        Text("Submit Feedback")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(allAnswered ? .white : .primary.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(allAnswered ? Color.blue : Color.white.opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!allAnswered)
                    .animation(.easeInOut(duration: 0.2), value: allAnswered)
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

                // X dismiss
                Button(action: onLeave) {
                    ZStack {
                        Circle()
                            .fill(.thickMaterial)
                            .overlay(Circle().fill(Color.black.opacity(0.28)))
                            .frame(width: 28, height: 28)
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .padding(12)
            }
        }
    }
}

// MARK: - Yes/No Button

struct YesNoButton: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color.white.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}//
//  SessionEndedView.swift
//  Live Interactions
//
//  Created by Dhruvi Jagani on 4/23/26.
//

