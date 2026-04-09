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

        WindowGroup(id: "cue-preview") {
            CuePreviewView()
        }
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(mainWindow))
            }
            return WindowPlacement()
        }
        .defaultSize(CGSize(width: 342, height: 110))

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
