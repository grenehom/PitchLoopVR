//
//  AppModel.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/23/26.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var conferenceRoomEntity: Entity?
    var rootEntity: Entity = Entity()
}
