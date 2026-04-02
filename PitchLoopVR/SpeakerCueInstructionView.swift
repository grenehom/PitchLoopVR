//
//  SpeakerCueInstructionView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/27/26.
//

import SwiftUI

struct SpeakerCueInstructionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goToNext = false

    var body: some View {
        ZStack {
            VStack {
                // Top floating cue pill
                cuePreview

                Spacer()

                // Center instruction card
                VStack(spacing: 18) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(.blue)

                    Text("Look up for feedback cues")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("If someone flags something like pace, it will appear as a subtle notification.\nUse it to adjust while you speak.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(maxWidth: 520)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 34)
                .frame(width: 700, height: 250)
                .background(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )

                Text("tap to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.82))
                    .padding(.top, 18)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // X button pinned to card region
            VStack {
                Spacer().frame(height: 220)

                HStack {
                    Spacer()

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 340)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            goToNext = true
        }
        .navigationDestination(isPresented: $goToNext) {
            SpeakerRecordPromptView()
        }
        .navigationBarBackButtonHidden(true)
    }

    private var cuePreview: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    .frame(width: 62, height: 62)

                Image(systemName: "waveform")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text("Pace Yourself")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(width: 360, height: 92)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .padding(.top, 22)
    }
}

#Preview {
    NavigationStack {
        SpeakerCueInstructionView()
    }
}
