/*
 ContentView.swift
 Updated to inject FeedbackStore as an @EnvironmentObject so both
 SpeakerView and AudienceView share the exact same instance.
*/

import SwiftUI

enum Role {
    case speaker
    case audience
}

struct ContentView: View {

    @State private var selectedRole: Role? = nil

    // Single shared instance — both views read and write to this
    @StateObject private var feedbackStore = FeedbackStore()

    var body: some View {
        Group {
            switch selectedRole {
            case .none:
                RoleSelectionView { role in
                    selectedRole = role
                }

            case .speaker:
                SpeakerView(onLeave: { selectedRole = nil })

            case .audience:
                AudienceView(onLeave: { selectedRole = nil })
            }
        }
        // Inject once here — all child views get it automatically
        .environmentObject(feedbackStore)
    }
}

private struct RoleSelectionView: View {
    let onSelect: (Role) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Choose Your Role")
                .font(.title2)
                .bold()

            Button("Speaker") {
                onSelect(.speaker)
            }
            .buttonStyle(.borderedProminent)

            Button("Audience") {
                onSelect(.audience)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

//
//  Contentview.swift
//  PitchLoopVR
//
//  Created by Dhruvi Jagani on 4/3/26.
//  Copyright © 2026 Apple. All rights reserved.
//
