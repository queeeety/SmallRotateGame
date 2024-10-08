import SwiftUI

struct SceneBuilder: View {
    @State var map: [[Int]] = preLoadedLevels[CurrentLevel - 1].map
    @State private var elementsMap: [[LineObject]] = []
    @State var colorFalse = Color.red
    @State var colorTrue = Color.green
    @State var bgcolor = Color.red
    @State var isCorrect = false
    @State var isNextLevel: Bool = false
    @State var isAlert: Bool = false
    @State var isProcessing: Bool = false  // Новий прапор для блокування дій
    @State var isHomeScreen : Bool = false
    @State var IsButtonNextLevel : Bool = false
    let screenWidth = Int(UIScreen.main.bounds.width - 20)

    var body: some View {
        if !isHomeScreen {
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
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading){
                            Spacer()
                            Buttons(isHome: $isHomeScreen, isNextLevel: $IsButtonNextLevel, iconsColor: $bgcolor)
                        }
                        Spacer()
                            
                    }
                    .padding()
                    
                } else {
                    Text("\(CurrentLevel)")
                        .font(.system(size: 150))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
            }
            .alert(NSLocalizedString("Greetings", comment:""), isPresented: $isAlert) {
                Button(NSLocalizedString("StartAgain", comment:""), role: .cancel) {
                    isNextLevel = false
                    CurrentLevel = 1
                    saveCurrentNumber(CurrentLevel)
                    map = preLoadedLevels[CurrentLevel - 1].map
                    self.elementsMap = generateElementsMap()
                }
            } message: {
                Text(NSLocalizedString("StartAgaing", comment:""))
            }
            .onChange(of: IsButtonNextLevel){
                if IsButtonNextLevel {
                    manualTransitionToTheNextLevel()
                    IsButtonNextLevel = false
                }
            }
            .sensoryFeedback(.success, trigger: IsButtonNextLevel)
        } // if statement
        else {
            HomeView()
                .transition(.opacity)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isNextLevel = isComplete
                }
                if (preLoadedLevels.count > CurrentLevel) {
                    CurrentLevel += 1
                    saveCurrentNumber(CurrentLevel)
                    map = preLoadedLevels[CurrentLevel - 1].map
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
    
    func manualTransitionToTheNextLevel(){
        withAnimation {
            isNextLevel = true
        }
        if (preLoadedLevels.count > CurrentLevel) {
            CurrentLevel += 1
            saveCurrentNumber(CurrentLevel)
            map = preLoadedLevels[CurrentLevel - 1].map
            self.elementsMap = generateElementsMap()
        } else {
            isAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                bgcolor = colorFalse
                isNextLevel = false
            }
            isProcessing = false
        }
    }
}

#Preview {
    SceneBuilder()
}
