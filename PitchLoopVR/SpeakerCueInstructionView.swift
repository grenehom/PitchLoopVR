//
//  SpeakerCueInstructionView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/27/26.
//

import SwiftUI

struct SpeakerCueInstructionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var goToNext = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 18) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(.blue)

                    Text("Look up for feedback cues")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("If someone flags something like pace, it will appear as a subtle notification. Use it to adjust while you speak.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(maxWidth: 520)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 34)
                .frame(width: 700, height: 250)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.9))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .padding(.trailing, 12)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { goToNext = true }
        .onAppear { openWindow(id: "cue-preview") }
        .onDisappear { dismissWindow(id: "cue-preview") }
        .navigationDestination(isPresented: $goToNext) {
            SpeakerRecordPromptView()
        }
        .navigationBarBackButtonHidden(true)
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
            Text("tap to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }

}

#Preview {
    NavigationStack {
        SpeakerCueInstructionView()
    }
    .frame(width: 726, height: 281)
    .fixedSize()
}
