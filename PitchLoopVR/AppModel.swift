import SwiftUI
import RealityKit

@MainActor
@Observable
class AppModel {
    var speakerNotification: SessionNotification? = nil
    var speakerSessionCompleted: Bool = false
    var shouldEndSession: Bool = false
}
