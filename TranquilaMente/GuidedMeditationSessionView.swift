import SwiftUI

struct GuidedMeditationSessionView: View {
    var sessionName: String
    var duration: String

    @State private var isPlaying: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(sessionName)
                    .font(.headline)
                    .foregroundColor(.blue)

                Text("Duração: \(duration)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 2)
        )
        .padding(.vertical, 5)
        .onDisappear {
            // Lógica de limpeza ou pausa ao sair da visualização
            isPlaying = false
        }
    }
}

struct MeditationGuidedView: View {
    var body: some View {
        VStack {
            Image(systemName: "headphones")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding()

            Text("Meditação Guiada")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()

            Text("Encontre paz interior com nossas meditações guiadas. Escolha uma sessão e comece sua jornada de mindfulness.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.gray)

            Spacer()

            GuidedMeditationSessionView(sessionName: "Sessão 1", duration: "10 min")
            GuidedMeditationSessionView(sessionName: "Sessão 2", duration: "15 min")

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(20)
        .shadow(radius: 5)
        .navigationBarTitle("Meditação Guiada", displayMode: .inline)
    }
}

struct MeditationGuidedView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationGuidedView()
    }
}

