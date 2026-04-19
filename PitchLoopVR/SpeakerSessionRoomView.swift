import SwiftUI

struct SpeakerSessionRoomView: View {

    var body: some View {

        ZStack {

            Image("meeting-room-360")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                HStack {
                    Label("Presenting", systemImage: "circle.fill")
                        .foregroundStyle(.red)

                    Spacer()
                }
                .padding(30)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SpeakerSessionRoomView()
    }
}
