//
//  SceneBuilder2.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 05.08.2024.
//

import SwiftUI

struct SceneBuilder2: View {
    
    @State var map: [[Int]]!
    @State var mode: Int // 1 - typical, 2 - self levels, 3 - randoms
    
    @State private var elementsMap: [[LineObject]] = []
    
    @State var colorFalse = Color.red
    @State var colorTrue = Color.green
    @State var bgcolor = Color.red
    @State var currentLevel : Int!
    @State var isCorrect = false
    @State var isNextLevel: Bool = false
    @State var isAlert: Bool = false
    @State var isProcessing: Bool = false  // Новий прапор для блокування дій
    @State var isHomeScreen : Bool = false
    @State var IsButtonNextLevel : Bool = false
    
    let screenWidth = Int(UIScreen.main.bounds.width - 20)
    
    init(mode: Int){
        self.currentLevel = mode == 1 ? CurrentLevel : mode == 2 ? CurrentPlayersLevel : 1
        self.mode = mode
        self.map = mode == 1 ? preLoadedLevels[currentLevel - 1].map : mode == 2 ? CreatedLevels[currentLevel - 1].map : MapGenerator()
    }
    var body: some View {
        if !isHomeScreen {
            ZStack {
                Color(bgcolor)
                    .ignoresSafeArea()
                    .onChange(of: currentLevel){
                        saveCurrentNumber(currentLevel-1, mode: mode)
                    }
                
                if !isNextLevel {
                    if (map == nil) {
                        Text("Ви не створили жодного рівня")
                            .onAppear{
                                currentLevel = mode == 1 ? CurrentLevel : mode == 2 ? CurrentPlayersLevel : 1
                                mode = mode
                                map = mode == 1 ? preLoadedLevels[currentLevel - 1].map : mode == 2 ? CreatedLevels[currentLevel - 1].map : MapGenerator()
                            }
                    }
                    else{
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
                    }
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading){
                            Spacer()
                            Buttons(isHome: $isHomeScreen, isNextLevel: $IsButtonNextLevel, iconsColor: $bgcolor)
                        }
                        Spacer()
                        
                    }
                    .padding()
                    
                } else {
                    Text("\(currentLevel)")
                        .font(.system(size: 150))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
            }
            .alert("Вітаю!", isPresented: $isAlert) {
                Button("Почати наново", role: .cancel) {
                    isNextLevel = false
                    currentLevel = 1
                    saveCurrentNumber(currentLevel, mode: mode)
                    uploadMap()
                    
                    self.elementsMap = generateElementsMap()
                }
            } message: {
                Text("Ви пройшли гру!")
            }
            .onChange(of: IsButtonNextLevel){
                if IsButtonNextLevel {
                    manualTransitionToTheNextLevel()
                    IsButtonNextLevel = false
                }
            }
        } // if statement
        else {
            HomeView()
                .transition(.opacity)
        }
    }
    
    func uploadMap(){
        if mode == 1 {
            map = preLoadedLevels[currentLevel - 1].map
        }
        else if mode == 2
        {
            map = CreatedLevels[currentLevel - 1].map
        }
        else if mode == 3
        {
            map = MapGenerator()
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
                if mode == 1 || mode == 2 {
                    if ((mode == 1 ? preLoadedLevels : CreatedLevels).count > currentLevel) {
                        currentLevel += 1
                        saveCurrentNumber(currentLevel, mode: mode)
                        uploadMap()
                        self.elementsMap = generateElementsMap()
                    } else {
                        isAlert = true
                    }
                }
                else{
                    currentLevel += 1
                    uploadMap()
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
        if (mode == 1 || mode == 2){
            if ((mode == 1 ? preLoadedLevels : CreatedLevels).count > currentLevel) {
                currentLevel += 1
                saveCurrentNumber(currentLevel, mode: 1)
                map = preLoadedLevels[currentLevel - 1].map
                self.elementsMap = generateElementsMap()
            } else {
                isAlert = true
            }
        }
        else {
            currentLevel += 1
            uploadMap()
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
    SceneBuilder2(mode: 1)
}