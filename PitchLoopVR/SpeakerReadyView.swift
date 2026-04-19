//
//  SpeakerReadyView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 4/8/26.
//

import SwiftUI

struct SpeakerReadyView: View {
    
    @State private var goToNext = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Spacer()
                
                VStack(spacing: 18) {
                    
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                    
                    Text("You're all set")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("When you press start, your session will begin.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("tap to continue")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 28)
                .frame(width: 560)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(.ultraThinMaterial)
                )
                
                Spacer()
            }
            
            // X button top right
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.top, 30)
                    .padding(.trailing, 40)
                }
                
                Spacer()
            }
            
        }
        .contentShape(Rectangle())
        .navigationDestination(isPresented: $goToNext) {
            SpeakerSessionRoomView()
        }
        .navigationDestination(isPresented: $goToNext) {
            SpeakerSessionRoomView()
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    NavigationStack {
        SpeakerReadyView()
    }
}
