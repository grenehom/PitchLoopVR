import SwiftUI

// Shared item definitions — used by AudienceLiveFeedbackView, AudienceFeedbackWindow, and FeedbackQuestionView
let audienceFeedbackItems: [LiveFeedbackItem] = [
    LiveFeedbackItem(icon: "waveform",    label: "Pace",        description: "Pinch to note how the pacing felt"),
    LiveFeedbackItem(icon: "eye",         label: "Eye Contact", description: "Pinch to flag an eye contact issue"),
    LiveFeedbackItem(icon: "hand.raised", label: "Gesture",     description: "Pinch to note a gesture concern"),
    LiveFeedbackItem(icon: "clock",       label: "Timing",      description: "Pinch to note a timing issue"),
]

@MainActor
@Observable
class AudienceFeedbackModel {
    var activeFeedbackItem: LiveFeedbackItem? = nil

    // Tutorial state
    var isTutorialMode: Bool = false
    var tutorialStep: Int = 0          // index into audienceFeedbackItems
    var tutorialComplete: Bool = false

    // Live session trigger (set by audienceReminder → causes feedback window to dismiss main)
    var liveSessionStarted: Bool = false

    var isLastTutorialItem: Bool {
        tutorialStep == audienceFeedbackItems.count - 1
    }

    // True after tutorial completes, until the live session begins
    var isWaitingForSession: Bool {
        tutorialComplete && !liveSessionStarted
    }
}
