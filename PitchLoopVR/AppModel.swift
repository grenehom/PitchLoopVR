import SwiftUI

@MainActor
@Observable
class AppModel {
    var speakerNotification: SessionNotification? = nil
    var speakerSessionCompleted: Bool = false
    var shouldEndSession: Bool = false
}
