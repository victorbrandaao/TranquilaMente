import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme // Detecta o esquema de cores do sistema

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer(minLength: 40) // Adiciona espaço no topo

                Image("logo") // Certifique-se de que a imagem "logo" está em seus assets.
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120) // Altura limitada para equilíbrio visual
                    .padding(.bottom, 40)

                Text("Bem-Vindo ao TranquilaMente")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .blue) // Cor se adapta ao tema
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                Text("Seu espaço seguro para apoio à saúde mental.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .gray : .black)
                    .padding(.horizontal)
                    .padding(.bottom, 30)

                // Botões com ícones
                NavigationButton(title: "Suporte em Tempo Real", icon: "bubble.left.and.bubble.right.fill", color: Color.blue, destination: ChatbotView())
                NavigationButton(title: "Conectar com Profissionais", icon: "person.fill.checkmark", color: Color.green, destination: ProfessionalsView())
                NavigationButton(title: "Comunidade de Apoio", icon: "person.2.square.stack.fill", color: Color.orange, destination: CommunityView())

                Spacer() // Espaço flexível na parte inferior
            }
            .padding(.horizontal, 20)
            .background(colorScheme == .dark ? Color.black : Color("LightBackground")) // Altera a cor de fundo com base no tema
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(colorScheme) // Aqui você pode forçar .light ou .dark para testar
    }
}

struct NavigationButton<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .imageScale(.large)
                    .frame(width: 30, alignment: .center)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

// As outras Views (ChatbotView, ProfessionalsView, CommunityView) devem ser estilizadas de forma semelhante e incluir .preferredColorScheme(colorScheme) se necessário.

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark) // Aqui você pode mudar para .light para testar o modo claro
    }
}

