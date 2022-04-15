import SwiftUI

struct LetterBox: View {
    let letter: Character?
    let evaluation: LetterEvaluation?
    
    var body: some View {
        ZStack {
            RoundedRectangle (cornerRadius: 4)
                .style(withStroke: Color.black, lineWidth: 1, fill: boxColor)
                .aspectRatio(1, contentMode: .fit)
            if let letter = letter {
                Text(String(letter))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
            }
        }
    }
    
    private var boxColor: Color {
        guard let evaluation = evaluation else {
            return Color("LetterBoxBackground")
        }
        return evaluation.color
    }
}

struct LetterBox_Previews: PreviewProvider {
    static var previews: some View {
        LetterBox(letter: .init("A"), evaluation: nil)
            .previewLayout(.fixed(width: 100, height: 100))
            .environment(\.colorScheme, .light)
        LetterBox(letter: .init("B"), evaluation: .notIncluded)
            .previewLayout(.fixed(width: 100, height: 100))
            .environment(\.colorScheme, .dark)
    }
}



private extension LetterEvaluation {
    var color: Color {
        switch self {
        case .notIncluded:
            return Color(.systemGray5)
        case .included:
            return Color(.systemYellow)
        case .match:
            return Color(.systemGreen)
        }
    }
}
