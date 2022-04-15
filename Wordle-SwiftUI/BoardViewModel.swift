import Foundation

enum LetterEvaluation {
    case notIncluded    //Not included in the solution word
    case included       //Included, but wrong position
    case match          //Included and correct position
}

class BoardViewModel: ObservableObject {
    let width: Int
    let height: Int
    
    @Published var solved: Bool = false
    @Published var lost: Bool = false
    @Published var letters: [[Character?]]
    @Published var evaluations: [[LetterEvaluation?]] = []
    @Published var string: String = "" {
        didSet {
            mapStringToLetters(string)
        }
    }
    
    var solution: String = "HAPPY"
    
    private var activeRow: Int = 0
    
    init(width: Int = 5, height: Int = 6) {
        self.width = width
        self.height = height
        letters = Array(repeating: .init(repeating: nil, count: width), count: height)
        evaluations = Array(repeating: .init(repeating: nil, count: width), count: height)
        newGame()
    }
    
    func newGame() {
        activeRow = 0
        string = ""
        evaluations = evaluations.map{ $0.map { _ in nil}}
        solution = AnswerProvider.generateAnswer()
    }
    
    private func mapStringToLetters(_ string: String) {
        for row in 0..<height {
            for column in 0..<width {
                let index = row * width + column
                if index < string.count {
                    letters[row][column] = [Character](string)[index]
                } else {
                    letters[row][column] = nil
                }
            }
        }
    }
    
    private func guessedWord() -> String? {
        let finishedFullWord = string.count - activeRow * width == width
        guard finishedFullWord else {
            return nil
        }
        return String(string.suffix(width))
    }
    
    private func isValidInput(_ string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        return string.unicodeScalars.allSatisfy(allowedCharacters.contains)
    }
    
    private func validateAllowedCharacters(_ string: String, previousString: String) -> String {
        guard isValidInput(string) else {
            return previousString
        }
        return string
    }
    
    func validateString(_ newString: String, previousString: String) {
        // 1️⃣ Validate newString and modify if necessary
        let validatedString = newString
            .uppercased()
            .transform { string in
                validateAllowedCharacters(string, previousString: previousString)
            }
            .transform { string in
                validateActiveRowEdit(string, previousString: previousString)
            }
        // 2️⃣ Assign the validated string back to the hidden text field
        string = validatedString
        if let word = guessedWord() {
            evaluateWord(word)
        }
        // ❌ 3️⃣ Map the validated string to the letter boxes
    }
    
    private func validateActiveRowEdit(_ string: String, previousString: String) -> String {
        let startIndex = activeRow * width
        let endIndex = startIndex + width - 1
        guard string.count <= endIndex + 1 else {
            // string flows into the next row:
            // → Keep old string in previous rows,
            //   use new string in current row,
            //   discard subsequent rows
            return String(previousString.prefix(startIndex))
                 + string.prefix(endIndex + 1).suffix(width)
        }
        guard string.count >= startIndex else {
            // string is now shorter and doesn't reach the current row:
            // → Keep old string in previous rows, discard new string
            return String(previousString.prefix(endIndex))
        }
        return string
    }
    
    private func evaluateWord(_ word: String) {
        let solution = Array(solution.uppercased())
        let rowEvaluation: [LetterEvaluation] = word
            .uppercased()
            .enumerated()
            .map { index, character in
                if character == solution[index] {
                    return .match
                } else if solution.contains(character) {
                    return .included
                } else {
                    return .notIncluded
                }
            }
        evaluations[activeRow] = rowEvaluation
        checkWinOrLose(rowEvaluation)
        activeRow += 1
    }
    
    private func checkWinOrLose(_ rowEvaluation: [LetterEvaluation]) {
        if rowEvaluation.solved {
            solved = true
        } else if activeRow == height - 1 {
            lost = true
        }
    }
}

extension String {
    func transform(_ transform: (String) -> String) -> String {
        transform(self)
    }
}

extension Array where Element == LetterEvaluation {
    var solved: Bool {
        allSatisfy { $0 == .match }
    }
}
