/*
 FeedbackModels.swift
 Live Interactions — PitchLoop VR

 Updated:
  - 4th type is now timeStructure (replaces gestures)
  - Each type has 3 specific options (matches screenshots)
  - FeedbackMessage carries the selected option's notificationText
  - FeedbackStore.send() takes both type and option
*/

import SwiftUI
import Combine

// MARK: - Feedback Option

struct FeedbackOption: Identifiable {
    let id = UUID()
    let label: String           // shown in the modal button
    let notificationText: String // shown on speaker's notification pill
}

// MARK: - Feedback Type

enum FeedbackType: String, CaseIterable, Identifiable, Codable {
    case pace          = "Pace"
    case eyeContact    = "Eye contact"
    case volume        = "Volume"
    case timeStructure = "Time & Structure"

    var id: String { rawValue }

    // SF Symbol icon — used in both the pill buttons and modal header
    var sfSymbol: String {
        switch self {
        case .pace:          return "person.wave.2"
        case .eyeContact:    return "eye"
        case .volume:        return "speaker.wave.2"
        case .timeStructure: return "clock"
        }
    }

    // Question shown at top of the center modal
    var sheetQuestion: String {
        switch self {
        case .pace:          return "How is the speaker's pacing?"
        case .eyeContact:    return "How is the speaker's eye contact?"
        case .volume:        return "How is the speaker's volume?"
        case .timeStructure: return "How is the speaker's presentation?"
        }
    }

    // 3 options per type — exactly matching the screenshots
    var options: [FeedbackOption] {
        switch self {
        case .pace:
            return [
                FeedbackOption(label: "Too fast",       notificationText: "Pace is too fast"),
                FeedbackOption(label: "Too slow",       notificationText: "Pace is too slow"),
                FeedbackOption(label: "Felt just right",notificationText: "Pacing feels good"),
            ]
        case .eyeContact:
            return [
                FeedbackOption(label: "Too scattered",  notificationText: "Eye contact too scattered"),
                FeedbackOption(label: "Too fixed",      notificationText: "Vary your eye contact"),
                FeedbackOption(label: "Felt just right",notificationText: "Eye contact feels good"),
            ]
        case .volume:
            return [
                FeedbackOption(label: "Too loud",       notificationText: "Lower your volume"),
                FeedbackOption(label: "Too quiet",      notificationText: "Speak up a little"),
                FeedbackOption(label: "Felt just right",notificationText: "Volume feels good"),
            ]
        case .timeStructure:
            return [
                FeedbackOption(label: "Too long",       notificationText: "Consider wrapping up"),
                FeedbackOption(label: "Hard to follow", notificationText: "Structure is hard to follow"),
                FeedbackOption(label: "Felt just right",notificationText: "Structure feels good"),
            ]
        }
    }

    // Accent color (used for the active ring on pill buttons)
    var color: Color {
        switch self {
        case .pace:          return .orange
        case .eyeContact:    return .cyan
        case .volume:        return .purple
        case .timeStructure: return .blue
        }
    }

    // Emoji shown in the audience feedback pill and modal icon
    var emoji: String {
        switch self {
        case .pace:          return "🗣️"
        case .eyeContact:    return "👁️"
        case .volume:        return "🔊"
        case .timeStructure: return "🕑"
        }
    }
}

// MARK: - Feedback Message

struct FeedbackMessage: Identifiable {
    let id: UUID
    let type: FeedbackType
    let notificationText: String  // driven by the selected option
    let sentAt: Date

    init(type: FeedbackType, option: FeedbackOption) {
        self.id             = UUID()
        self.type           = type
        self.notificationText = option.notificationText
        self.sentAt         = Date()
    }
}

extension FeedbackMessage: Equatable {
    static func == (lhs: FeedbackMessage, rhs: FeedbackMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Feedback Store

@MainActor
class FeedbackStore: ObservableObject {

    @Published var pendingFeedback: [FeedbackMessage] = []
    @Published var feedbackHistory: [FeedbackMessage] = []

    // Audience calls this with the type AND the chosen option
    func send(type: FeedbackType, option: FeedbackOption) {
        let message = FeedbackMessage(type: type, option: option)
        pendingFeedback.append(message)
        feedbackHistory.append(message)
    }

    // Speaker overlay calls this to remove a dismissed notification
    func dismiss(message: FeedbackMessage) {
        pendingFeedback.removeAll { $0.id == message.id }
    }

    // Called when session ends
    func clearAll() {
        pendingFeedback.removeAll()
    }
}
