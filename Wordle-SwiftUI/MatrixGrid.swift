import SwiftUI

struct MatrixGrid<Content: View>: View {
    
    typealias GridItemFactory = (_ row: Int, _ column: Int) -> Content
    
    let width: Int
    let height: Int
    let spacing: CGFloat
    let gridItemFactory: GridItemFactory
    
    private var columns: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: width)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: spacing) {
            ForEach(0..<height, id: \.self) { row in
                ForEach(0..<width, id: \.self) { column in
                    gridItemFactory(row, column)
                        .id("MatrixGrid_Item_\(row)x\(column)")
                }
            }
        }
    }
}

struct MatrixGrid_Previews: PreviewProvider {
    static var previews: some View {
        MatrixGrid(width: 5, height: 6, spacing: 8) { row, column in
            LetterBox(letter: "A", evaluation: nil)
        }
        .padding()
    }
}
