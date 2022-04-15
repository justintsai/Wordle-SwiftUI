import Foundation

struct AnswerProvider {
    static let answers: [String] = ["Happy", "Hello", "Chair", "Table", "Stair", "Angel", "Devil", "Squad", "Squid", "Black", "White", "Green", "Today", "Swift", "Quick", "Train"]
    
    static func generateAnswer() -> String {
        self.answers.randomElement()!
    }
}
