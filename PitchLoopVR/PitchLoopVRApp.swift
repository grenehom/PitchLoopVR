//
//  PitchLoopVRApp.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/23/26.
//

import SwiftUI

@main
struct PitchLoopVRApp: App {
    
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()
    @State private var audienceFeedbackModel = AudienceFeedbackModel()
 // WindowGroup handles the large background handled in the room. Floating behavior 
    var body: some Scene {
        WindowGroup(id: "main") {
            if avPlayerViewModel.isPlaying {
                AVPlayerView(viewModel: avPlayerViewModel)
            } else {
                ContentView()
                    .environment(appModel)
            }
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "audience-feedback") {
            AudienceFeedbackWindow()
                .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.below(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "feedback-question") {
            FeedbackQuestionView()
                .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)    }
}
