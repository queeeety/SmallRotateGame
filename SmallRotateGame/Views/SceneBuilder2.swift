//
//  SceneBuilder2.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 05.08.2024.
//

import SwiftUI
import AVFoundation

struct SceneBuilder2: View {
    @Binding var isActive: Bool
    
    @State var map: [[Int]]!
    @State var mode: Int // 1 - typical, 2 - self levels, 3 - randoms
    
    @State private var elementsMap: [[LineObject]] = []
    
    @State var colorFalse = Color.indigo
    @State var colorTrue = Color.purple
    @State var bgcolor = Color.indigo
    @State var currentLevel : Int!
    @State var isCorrect = false
    @State var isNextLevel: Bool = false
    @State var isAlert: Bool = false
    @State var isProcessing: Bool = false  // Новий прапор для блокування дій
    @State var isHomeScreen : Bool = false
    @State var IsButtonNextLevel : Bool = false
    @State var difficulty: Int
    @State var countTaps : Int = 0
    @State var isSettingsView = false
    @State var isMusicEffectsOn = UserDefaults.standard.bool(forKey: "MusicEffects")
    let MainLevelCounter = UserDefaults.standard.integer(forKey: "CurrentLevel")
    let PlayerCreatedLevelCounter = UserDefaults.standard.integer(forKey: "PlayersLevel")
    let screenWidth = Int(UIScreen.main.bounds.width - 20)
    
    init(mode: Int, difficulty: Int = 0, isActive: Binding<Bool>) {
        // Спочатку ініціалізуємо всі необхідні властивості
        let currentLevel: Int
        let map: [[Int]]
        // Присвоюємо значення змінним перед викликом self
        if mode == 1 {
            // Завантажуємо збережений рівень тільки один раз
            currentLevel = max(MainLevelCounter, 1)
        } else if mode == 2 {
            currentLevel = max(UserDefaults.standard.integer(forKey: "PlayersLevel"), 1)
        } else {
            currentLevel = 1
        }
        
        // Генеруємо map залежно від значень
        if mode == 1 {
            map = preLoadedLevels[currentLevel - 1].map
        } else if mode == 2 {
            map = CreatedLevels[currentLevel - 1].map
        } else {
            map = MapGenerator(difficulty: difficulty)
        }
        
        _isActive = isActive
        self.mode = mode
        self.difficulty = difficulty
        self.currentLevel = currentLevel
        self.map = map
    }
    
    var body: some View {
        ZStack {
            Color(bgcolor)
                .ignoresSafeArea()
                .onChange(of: currentLevel){
                    if mode != 3 {
                        
                        saveCurrentNumber(currentLevel-1, mode: mode)
                    }
                }
                .onAppear{

                    if isMusicEffectsOn{
                        AudioServicesPlaySystemSound(1129)
                    }
                }
            
            if !isNextLevel {
                if (map == nil) {
                    Text(NSLocalizedString("NoStandartLevels", comment:""))
                        .onAppear{
                            currentLevel = mode == 1 ? MainLevelCounter : mode == 2 ? PlayerCreatedLevelCounter : 1
                            mode = mode
                            map = mode == 1 ? preLoadedLevels[currentLevel - 1].map : mode == 2 ? CreatedLevels[currentLevel - 1].map : MapGenerator(difficulty: difficulty)
                        }
                }
                else{
                    VStack(spacing: 0) {
                        ForEach(elementsMap.indices, id: \.self) { i in
                            HStack(spacing: 0) {
                                ForEach(elementsMap[i].indices, id: \.self) { j in
                                    LineObj(viewModel: elementsMap[i][j]) {
                                        if !isProcessing {
                                            countTaps += 1
                                            checkCompleteness()
                                            
                                        }
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                        if (map.count >= 13){
                            Spacer()
                        }
                    }
                    .frame(minWidth: CGFloat(screenWidth), maxWidth: CGFloat(screenWidth), idealHeight: CGFloat(75 * map.count))
                    .onAppear {
                        self.elementsMap = generateElementsMap()
                    }
                    .transition(.opacity)
                    
                }
                HStack(alignment: .bottom){
                    VStack(alignment: .center){
                        Spacer()
                        Buttons(isHome: $isActive, isNextLevel: $IsButtonNextLevel, iconsColor: $bgcolor, tapCount: $countTaps, isSettingsView: $isSettingsView)
                    }
                    Spacer()
                    
                }
                .padding()
                .overlay{
                    Group{
                        if isSettingsView{
                            SettingsView(isActive: $isSettingsView)
                                .transition(.opacity)
                        }
                    }
                }
            } else {
                Text("\(currentLevel)")
                    .font(.system(size: 150))
                    .foregroundColor(.white)
                    .transition(.opacity)
                
            }
        }
        
        
        .alert(NSLocalizedString("Greetings", comment:""), isPresented: $isAlert) {
            Button(NSLocalizedString("StartAgain", comment:""), role: .cancel) {
                isNextLevel = false
                currentLevel = 1
                saveCurrentNumber(currentLevel, mode: mode)
                uploadMap()
                
                self.elementsMap = generateElementsMap()
            }
        } message: {
            Text(NSLocalizedString("AlertDone", comment:""))
        }
        .onChange(of: IsButtonNextLevel){
            if IsButtonNextLevel {
                manualTransitionToTheNextLevel()
                IsButtonNextLevel = false
            }
        }
        .onChange(of: isSettingsView){
            isMusicEffectsOn = UserDefaults.standard.bool(forKey: "MusicEffects")
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
            map = MapGenerator(difficulty: difficulty)
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
        
        if isComplete {
            withAnimation{
                self.bgcolor = colorTrue
                if isMusicEffectsOn{
                    AudioServicesPlaySystemSound(1128)
                }
            }
            triggerNotificationFeedback(mode: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isNextLevel = isComplete
                    countTaps = 0
                }
                if mode == 1 || mode == 2 {
                    if ((mode == 1 ? preLoadedLevels : CreatedLevels).count > currentLevel) {
                        currentLevel += 1
                        saveCurrentNumber(currentLevel+1, mode: mode)
                        uploadMap()
                        self.elementsMap = generateElementsMap()
                    } else {
                        isAlert = true
                        triggerNotificationFeedback(mode: .error)
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
            countTaps = 0
        }
        if (mode == 1 || mode == 2){
            // Переходимо на наступний рівень лише тоді, коли є більше рівнів
            if ((mode == 1 ? preLoadedLevels : CreatedLevels).count > currentLevel) {
                currentLevel += 1
                saveCurrentNumber(currentLevel, mode: mode)
                uploadMap()
                self.elementsMap = generateElementsMap()
            } else {
                isAlert = true
                triggerNotificationFeedback(mode: .error)
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
    SceneBuilder2(mode: 3, difficulty: 1, isActive: .constant(true))
}
