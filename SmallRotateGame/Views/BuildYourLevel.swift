import SwiftUI

struct BuildYourLevel: View {
    
    @State private var map = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
    ]
    
    @State private var elementsMap: [[LineObject]] = []
    @State var bgcolor = Color.red
    @State var isCorrect = false
    @State var changePoint = [Int]()
    @State var isButtonPushed = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [bgcolor, Color.cyan], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0.2) {
                ForEach(elementsMap.indices, id: \.self) { i in
                    HStack(spacing: 0) {
                        ForEach(elementsMap[i].indices, id: \.self) { j in
                            SingleButton(currentobj: $elementsMap[i][j], isPuched: $isButtonPushed)
                                .contextMenu {
                                    Button {
                                        changePoint = [i, j, 1]
                                    } label: {
                                        Text("Початок")
                                        Image("one")
                                    }
                                    Button {
                                        changePoint = [i, j, 2]
                                    } label: {
                                        Text("Пряма")
                                        Image("line")
                                    }
                                    Button {
                                        changePoint = [i, j, 3]
                                    } label: {
                                        Text("Кутик")
                                        Image("corner")
                                    }
                                    Button {
                                        changePoint = [i, j, 4]
                                    } label: {
                                        Text("Літера Т")
                                        Image("t")
                                    }
                                    Button {
                                        changePoint = [i, j, 5]
                                    } label: {
                                        Text("Хрест")
                                        Image("x")
                                    }
                                    Button(role:.destructive) {
                                        changePoint = [i, j, 0]
                                    } label: {
                                        Text("Нічого")
                                        Image("0")
                                    }
                                }
                        }
                    }
                }
            }
            .onChange(of: changePoint) {
                UpdateMap(&elementsMap, changePoint: changePoint)
            }
            .onChange(of: isButtonPushed, {
                checkCompleteness()
                })
            .frame(width: CGFloat(map[0].count * 50), height: CGFloat(map.count * 50))
            .onAppear {
                self.elementsMap = generateElementsMap()
            }
        }
    }
    
    func generateElementsMap() -> [[LineObject]] {
        map.map { row in
            row.map { cell in
                LineObject(number: cell, color: .white)
            }
        }
    }

    func checkCompleteness() {
        if elementsMap.allSatisfy({ $0.allSatisfy { $0.number == 0 } }) {
            // Perform actions if all elements are 0
            print("Zero elements")
        } else {
            print(">Zero elements")

            let isComplete = performCheckCompleteness(elements: elementsMap)
            print("Completeness check: \(isComplete)")
            self.isCorrect = isComplete
            withAnimation {
                self.bgcolor = isComplete ? .green : .red
            }
        }
    }
    
    func UpdateMap(_ tempMap: inout [[LineObject]], changePoint: [Int]){
        guard changePoint.count == 3 else { return }
        let (i, j, newValue) = (changePoint[0], changePoint[1], changePoint[2])
        map[i][j] = newValue
        tempMap[i][j] = LineObject(number: newValue, color: .white)
    }
}

struct SingleButton: View {
    @Binding var currentobj: LineObject
    @Binding var isPuched: Bool
    var body: some View {
        LineObj(viewModel: currentobj){
            isPuched = isPuched == true ? false : true
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 13))

    }
}

#Preview{
    BuildYourLevel()
}
