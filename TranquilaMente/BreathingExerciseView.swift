import SwiftUI

struct BreathingExerciseView: View {
    @State private var timerValue = 60
    @State private var isBreathing = false

    var body: some View {
        VStack {
            if isBreathing {
                Text("Inspire...")
                    .font(.title)
                    .padding()

                Text("\(timerValue)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundColor(.blue)

                Button(action: stopBreathing) {
                    Text("Parar")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
            } else {
                Button(action: startBreathing) {
                    Text("Iniciar Exercício de Respiração")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(20)
        .shadow(radius: 5)
        .onChange(of: isBreathing) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                // Adapte conforme necessário para animações adicionais ou ajustes visuais específicos
            }
        }
        .navigationBarTitle("Exercício de Respiração", displayMode: .inline)
    }

    func startBreathing() {
        isBreathing = true

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timerValue > 0 {
                timerValue -= 1
            } else {
                stopBreathing()
            }
        }
    }

    func stopBreathing() {
        isBreathing = false
        timerValue = 60
    }
}

