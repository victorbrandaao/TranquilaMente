import SwiftUI

struct CommunityView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()

                Text("Comunidade de Apoio")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                Text("Conecte-se com outras pessoas e compartilhe experiências para promover a saúde mental.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.gray)

                Spacer()

                // Ferramentas de Autocuidado
                NavigationLink(destination: BreathingExerciseView()) {
                    AutocareToolView(toolName: "Exercício de Respiração", toolImage: "lungs.fill")
                }

                NavigationLink(destination: MeditationGuidedView()) {
                    VStack {
                        Image(systemName: "lotus.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                                    .shadow(color: Color.blue.opacity(0.7), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .shadow(color: Color.blue.opacity(0.7), radius: 5, x: 0, y: 3)
                            )
                            .padding(.bottom, 10)

                        Text("Meditação Guiada")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                            )
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
            )
            .cornerRadius(20)
            .shadow(radius: 5)
            .navigationBarTitle("Comunidade", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton {
                // Adicione qualquer lógica necessária ao pressionar o botão de volta
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                Text("Voltar")
            }
        }
    }
}

struct AutocareToolView: View {
    var toolName: String
    var toolImage: String

    var body: some View {
        VStack {
            Image(systemName: toolImage)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .padding()

            Text(toolName)
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 3)
        )
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}

