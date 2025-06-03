import SwiftUI

struct Lancamento: Identifiable {
    let id = UUID()
    let resultados: [String]
    let data: Date
}

struct ContentView: View {
    @State private var numberOfCoins = ""
    @State private var results: [String] = []
    @State private var historico: [Lancamento] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Krarkashima Coin Flipper")
                .font(.largeTitle)
                .padding(.top)
            
            TextField("Quantas moedas?", text: $numberOfCoins)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

            HStack {
                Button("Lançar Moedas") {
                    launchCoins()
                    hideKeyboard()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Limpar") {
                    numberOfCoins = ""
                    results = []
                    historico = []
                    hideKeyboard()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            if !results.isEmpty {
                let caras = results.filter { $0 == "Cara" }.count
                let coroas = results.filter { $0 == "Coroa" }.count

                VStack(alignment: .leading, spacing: 10) {
                    Text("Resultado atual:")
                        .font(.title2)
                    Text("Caras: \(caras)")
                    Text("Coroas: \(coroas)")
                    Text("Lançamentos: \(results.map { $0 == "Cara" ? "🙂" : "👑" }.joined(separator: " "))")
                        .foregroundColor(.gray)
                }
                .padding()
            }

            if !historico.isEmpty {
                Divider()
                Text("Histórico de Lançamentos")
                    .font(.headline)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(historico.reversed()) { lancamento in
                            let caras = lancamento.resultados.filter { $0 == "Cara" }.count
                            let coroas = lancamento.resultados.filter { $0 == "Coroa" }.count
                            VStack(alignment: .leading) {
                                Text("🕒 \(formattedDate(lancamento.data))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("Caras: \(caras), Coroas: \(coroas)")
                                Text("Lançamentos: \(lancamento.resultados.map { $0 == "Cara" ? "🙂" : "👑" }.joined(separator: " "))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 200)
            }

            Spacer()
        }
    }
    
    func launchCoins() {
        guard let count = Int(numberOfCoins), count > 0 else {
            results = []
            return
        }
        
        let novosResultados = (1...count).map { _ in Bool.random() ? "Cara" : "Coroa" }
        results = novosResultados
        historico.append(Lancamento(resultados: novosResultados, data: Date()))
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter.string(from: date)
    }
}

// 👉 Extensão para esconder o teclado
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
