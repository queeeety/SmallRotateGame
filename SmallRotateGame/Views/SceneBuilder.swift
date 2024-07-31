import SwiftUI

struct SceneBuilder: View {
    @State var map: [[Int]] = standartLevels[CurrentLevel - 1].map
    @State private var elementsMap: [[LineObject]] = []
    @State var colorFalse = Color.red
    @State var colorTrue = Color.green
    @State var bgcolor = Color.red
    @State var isCorrect = false
    @State var isRegularPlay: Bool
    @State var isNextLevel: Bool = false
    @State var isAlert: Bool = false
    @State var isProcessing: Bool = false  // Новий прапор для блокування дій
    let screenWidth = Int(UIScreen.main.bounds.width - 20)

    var body: some View {
        ZStack {
            Color(bgcolor)
                .ignoresSafeArea()

            if !isNextLevel {
                VStack(spacing: 0) {
                    ForEach(elementsMap.indices, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(elementsMap[i].indices, id: \.self) { j in
                                LineObj(viewModel: elementsMap[i][j]) {
                                    if !isProcessing {
                                        checkCompleteness()
                                    }
                                }
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
                .frame(minWidth: CGFloat(screenWidth), maxWidth: CGFloat(screenWidth), idealHeight: CGFloat(75 * map.count))
                .onAppear {
                    self.elementsMap = generateElementsMap()
                }
                .transition(.opacity)
            } else {
                Text("\(CurrentLevel)")
                    .font(.system(size: 150))
                    .foregroundColor(.white)
                    .transition(.opacity)
            }
        }
        .alert("Вітаю!", isPresented: $isAlert) {
            Button("Почати наново", role: .cancel) {
                isNextLevel = false
                CurrentLevel = 1
                saveCurrentNumber(CurrentLevel)
                map = standartLevels[CurrentLevel - 1].map
                self.elementsMap = generateElementsMap()
            }
        } message: {
            Text("Ви пройшли гру!")
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
        guard !isProcessing else { return } // Перевірка, чи не виконується зараз дія
        isProcessing = true // Блокуємо дії

        let isComplete = performCheckCompleteness(elements: elementsMap)
        self.isCorrect = isComplete
        withAnimation {
            self.bgcolor = isComplete ? colorTrue : colorFalse
        }

        if isComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isNextLevel = isComplete
                }
                if (standartLevels.count > CurrentLevel) {
                    CurrentLevel += 1
                    saveCurrentNumber(CurrentLevel)
                    map = standartLevels[CurrentLevel - 1].map
                    self.elementsMap = generateElementsMap()
                } else {
                    isAlert = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        bgcolor = colorFalse
                        isNextLevel = false
                    }
                    isProcessing = false // Дозволяємо дії знову
                }
            }
        } else {
            isProcessing = false // Якщо не завершено, дозволяємо дії знову
        }
    }
}

#Preview {
    SceneBuilder(isRegularPlay: true)
}
