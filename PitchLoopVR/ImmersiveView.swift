//
//  ImmersiveView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/23/26.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        RealityView { content in
            
            print("🚀 immersive running")

            // Add the root entity to content first
            content.add(appModel.rootEntity)

            // Add MAXIMUM lighting to brighten the conference room
            
            // 1. Main directional light (like bright sunlight from above)
            var directionalLight = DirectionalLightComponent()
            directionalLight.color = .white
            directionalLight.intensity = 50000  // Massively increased
            
            let directionalEntity = Entity()
            directionalEntity.components.set(directionalLight)
            directionalEntity.look(at: [0, 0, 0], from: [0, 5, 0], relativeTo: nil)
            appModel.rootEntity.addChild(directionalEntity)
            
            // 2. Main point light overhead (very bright ceiling light)
            var pointLight1 = PointLightComponent()
            pointLight1.color = .white
            pointLight1.intensity = 50000  // Massively increased
            pointLight1.attenuationRadius = 50
            
            let pointLightEntity1 = Entity()
            pointLightEntity1.components.set(pointLight1)
            pointLightEntity1.position = [0, 3, 0]
            appModel.rootEntity.addChild(pointLightEntity1)
            
            // 3. Front fill light
            var pointLight2 = PointLightComponent()
            pointLight2.color = .white
            pointLight2.intensity = 30000
            pointLight2.attenuationRadius = 40
            
            let pointLightEntity2 = Entity()
            pointLightEntity2.components.set(pointLight2)
            pointLightEntity2.position = [0, 2, -3]
            appModel.rootEntity.addChild(pointLightEntity2)
            
            // 4. Side fill light (left)
            var pointLight3 = PointLightComponent()
            pointLight3.color = .white
            pointLight3.intensity = 25000
            pointLight3.attenuationRadius = 40
            
            let pointLightEntity3 = Entity()
            pointLightEntity3.components.set(pointLight3)
            pointLightEntity3.position = [-3, 2, 0]
            appModel.rootEntity.addChild(pointLightEntity3)
            
            // 5. Side fill light (right)
            var pointLight4 = PointLightComponent()
            pointLight4.color = .white
            pointLight4.intensity = 25000
            pointLight4.attenuationRadius = 40
            
            let pointLightEntity4 = Entity()
            pointLightEntity4.components.set(pointLight4)
            pointLightEntity4.position = [3, 2, 0]
            appModel.rootEntity.addChild(pointLightEntity4)
            
            // 6. Back light for depth
            var pointLight5 = PointLightComponent()
            pointLight5.color = .white
            pointLight5.intensity = 20000
            pointLight5.attenuationRadius = 35
            
            let pointLightEntity5 = Entity()
            pointLightEntity5.components.set(pointLight5)
            pointLightEntity5.position = [0, 2, 3]
            appModel.rootEntity.addChild(pointLightEntity5)

        } update: { content in
            // This closure runs when observed state changes
        } placeholder: {
            ProgressView()
        }
        .task {
            // Load the model asynchronously
            if let entity = try? await Entity(named: "Conference_room_-_3D (1)") {

                print("✅ model loaded")

                // Blender exported model needs axis conversion from Z-up to Y-up
                // Rotate 90° (positive) around X axis to convert Z-up (Blender) to Y-up (RealityKit)
                // This makes the floor flat on the ground and chairs upright
                let axisConversion = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0))
                
                // Rotate 180° around Y axis so you're at the end of the table looking down its length
                // This makes the screen/UI face toward you
                let viewAngle = simd_quatf(angle: .pi + .pi / 2, axis: SIMD3<Float>(0, 1, 0))
            
                // Combine rotations
                entity.orientation = axisConversion * viewAngle
                
                // Position the room so user is standing at a natural viewing height
                // X = 0 (centered horizontally)
                // Y = 4.0 (adjusted height)  
                // Z = -2.5 (room positioned in front of you)
                entity.position = SIMD3<Float>(0, 4.0, -2.5)

                appModel.conferenceRoomEntity = entity
                appModel.rootEntity.addChild(entity)

            } else {
                print("❌ failed to load model")
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
