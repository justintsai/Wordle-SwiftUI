import SwiftUI

struct Board: View {

    @StateObject private var viewModel = BoardViewModel()
    @FocusState private var textFieldActive: Bool
    
    var body: some View {
        VStack {
            ZStack {
                TextField("", text: $viewModel.string)
                    .keyboardType(.asciiCapable)
                    .disableAutocorrection(true)
                    .focused($textFieldActive)
                    .opacity(0)
                    .onChange(of: viewModel.string) { [old = viewModel.string] new in
                        viewModel.validateString(new, previousString: old)
                    }
                MatrixGrid(
                    width: viewModel.width,
                    height: viewModel.height,
                    spacing: 8
                ) { row, column in
                    LetterBox(
                        letter: viewModel.letters[row][column],
                        evaluation: viewModel.evaluations[row][column]
                    )
                }
                .frame(maxHeight: .infinity)
                .onTapGesture {
                    textFieldActive.toggle()
                }
            }
            Button("New Game") {
                withAnimation {
                    viewModel.newGame()
                }
            }
            .padding()
        }
        .padding(24)
        .background(Color(.systemGray3))
        .alert("You won! 🎉", isPresented: $viewModel.solved) {
            Button("OK", role: .none) {
                viewModel.solved = false
            }
        }
        .alert("You lost! 🥲", isPresented: $viewModel.lost) {
            Button("OK", role: .none) {
                viewModel.lost = false
            }
        } message: {
            Text("The word was:\n" + viewModel.solution.uppercased())
        }
        .onChange(of: viewModel.solved) { solved in
            if solved {
                vibrate(type: .success)
            }
        }
        .onChange(of: viewModel.lost) { lost in
            if lost {
                vibrate(type: .error)
            }
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
