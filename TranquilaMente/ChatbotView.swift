import SwiftUI
import Alamofire

struct ChatGPTResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }

        let message: Message
    }

    let choices: [Choice]?
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct HFResponse: Decodable {
    let privateModel: Bool
}

struct ChatbotView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @State private var retryDelay = 1.0
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isPrivateModel = false

    var body: some View {
        VStack {
            headerView

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        MessageView(message: message)
                            .animation(.easeInOut, value: messages)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(color: colorScheme == .dark ? .clear : .gray.opacity(0.3), radius: 5)

            if showError {
                ErrorView(message: errorMessage)
            }

            messageInputField
        }
        .navigationBarTitle("Conversa Tranquila", displayMode: .inline)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            getModelInfo()
        }
    }

    var headerView: some View {
        Text("Como posso ajudar você hoje?")
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(colorScheme == .dark ? .white : .blue)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
    }

    var messageInputField: some View {
        HStack {
            TextField("Digite sua mensagem...", text: $messageText)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)

            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
                    .padding(8)
                    .foregroundColor(Color.blue)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            .disabled(messageText.isEmpty)
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let newMessage = Message(text: trimmedText, isUser: true)
        messages.append(newMessage)
        messageText = ""

        requestChat(with: trimmedText)
    }

    private func requestChat(with text: String) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer YOUR_HUGGING_FACE_API_KEY"
        ]

        let payload: [String: Any] = [
            "model": "text-generation/gpt-2", // Substitua pelo modelo desejado
            "inputs": text
        ]

        AF.request("https://api-inference.huggingface.co/models/gpt-2/completions",
                   method: .post,
                   parameters: payload,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: ChatGPTResponse.self) { response in
                switch response.result {
                case .success(let chatResponse):
                    self.retryDelay = 1.0
                    self.showError = false
                    self.handleChatResponse(chatResponse)
                case .failure(let error):
                    if response.response?.statusCode == 429 {
                        self.showError(message: "Erro na API: Muitas solicitações. Tentando novamente após \(self.retryDelay) segundos.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                            self.retryDelay *= 2
                            self.requestChat(with: text)
                        }
                    } else {
                        self.showError(message: "Erro na API: \(error)")
                    }
                }
            }
    }

    private func handleChatResponse(_ response: ChatGPTResponse) {
        if let choice = response.choices?.first {
            let reply = choice.message.content

            let newMessage = Message(text: reply, isUser: false)
            DispatchQueue.main.async {
                self.messages.append(newMessage)
            }
        }
    }

    private func getModelInfo() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer YOUR_HUGGING_FACE_API_KEY"
        ]

        let modelIdentifier = "text-generation/gpt-2" // Substitua pelo modelo desejado

        let encodedModelIdentifier = modelIdentifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? modelIdentifier

        AF.request("https://api-inference.huggingface.co/models/\(encodedModelIdentifier)",
                   method: .get,
                   headers: headers)
            .validate()
            .responseDecodable(of: HFResponse.self) { response in
                switch response.result {
                case .success(let modelInfo):
                    self.isPrivateModel = modelInfo.privateModel
                case .failure(let error):
                    if response.response?.statusCode == 404 {
                        self.showError(message: "Modelo não encontrado. Verifique se o identificador do modelo está correto.")
                    } else {
                        self.showError(message: "Erro ao obter informações do modelo: \(error)")
                    }
                }
            }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func showError(message: String) {
        self.errorMessage = message
        self.showError = true
    }
}

struct MessageView: View {
    let message: Message
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(18)
                    .foregroundColor(.white)
            } else {
                Text(message.text)
                    .padding()
                    .background(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2))
                    .cornerRadius(18)
            }
        }
        .transition(.slide)
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .padding()
        }
        .transition(.slide)
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView().preferredColorScheme(.dark)
    }
}

