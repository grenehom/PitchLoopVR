//
//  SpeakerRecordingView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/27/26.
//

import SwiftUI

struct SpeakerRecordingView: View {
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 0) {
                header

                ZStack {
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .fill(Color.black.opacity(0.08))

                    Image("speaker-recording-placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 520, height: 440)
                        .clipped()
                }
                .frame(width: 520, height: 440)

                footerControls
            }
            .frame(width: 520)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            )

            pageIndicator
                .padding(.top, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var header: some View {
        HStack {
            Text("Recording")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var footerControls: some View {
        HStack {
            Spacer()

            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.white.opacity(0.95))
                    .frame(width: 14, height: 14)

                Text("Begin")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.95))
            }
            .padding(.horizontal, 26)
            .frame(height: 52)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.16))
            )

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    private var pageIndicator: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 10, height: 10)

            Capsule()
                .fill(Color.white.opacity(0.7))
                .frame(width: 82, height: 10)
        }
    }
}

#Preview {
    SpeakerRecordingView()
        .frame(width: 600, height: 700)
        .fixedSize()
}
