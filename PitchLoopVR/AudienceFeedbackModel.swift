import SwiftUI

@MainActor
@Observable
class AudienceFeedbackModel {
    var activeFeedbackItem: LiveFeedbackItem? = nil
}
