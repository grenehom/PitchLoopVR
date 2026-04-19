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
        .windowStyle(.plain)
        .windowResizability(.contentSize)

        // Plain windows (no glass chrome) ————————————————————————

        WindowGroup(id: "speaker-session") {
            SpeakerSessionView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.below(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "session-notification") {
            SessionNotificationWindow()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "cue-preview") {
            CuePreviewView()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "waiting-participants") {
            WaitingParticipantsView()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(main))
            }
            return WindowPlacement()
        }

        // Audience windows ————————————————————————————————————————

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
