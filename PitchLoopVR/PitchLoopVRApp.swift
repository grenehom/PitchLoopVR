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
    @State private var audienceFeedbackModel = AudienceFeedbackModel()

    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
                .environment(appModel)
                .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "live-question") {
            FeedbackQuestionView()
                .environment(audienceFeedbackModel)
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


    }
}
