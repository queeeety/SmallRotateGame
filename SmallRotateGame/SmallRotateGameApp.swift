//
//  SmallRotateGameApp.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 28.07.2024.
//

import SwiftUI

@main
struct SmallRotateGameApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear{
                    checkFirstLaunch()
                }
        }
        
    }
}

func checkFirstLaunch() {
    let defaults = UserDefaults.standard
    if defaults.bool(forKey: "isFirstLaunch") == false {
        createInitialLevelsFile()
        defaults.set(true, forKey: "isFirstLaunch")
    }
}

public var CurrentLevel = getCurrentNumber()
public var CurrentPlayersLevel = getCurrentNumber(mode: 2)

public var CreatedLevels : [Level] = loadLevels(from: "PlayerLevels")
public var standartLevels : [Level] = loadLevels(from: "levels")
public let preLoadedLevels = loadLevelsFromFileDirectly()
let startMap =  [[0, 0, 1, 1, 0, 0],
                [0, 0, 2, 2, 0, 0],
                [0, 0, 3, 5, 1, 0],
                [0, 0, 0, 2, 0, 0],
                [3, 3, 0, 4, 3, 0],
                [3, 3, 0, 1, 1, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]


extension AnyTransition {
    static var slideFromTop: AnyTransition {
        AnyTransition.move(edge: .top)
    }
    static var slideFromLeft: AnyTransition {
        AnyTransition.move(edge: .leading)
    }
    static var slideFromRight: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}

// Функція для створення тактильного зворотного зв'язку
func triggerHapticFeedback() {
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    impactGenerator.impactOccurred()
    
}

enum HapticTypes{
    case success
    case error
}

func triggerNotificationFeedback(mode: HapticTypes){
    let impactGenerator = UINotificationFeedbackGenerator()
    switch mode {
    case .success:
        impactGenerator.notificationOccurred(.success)
    case .error:
        impactGenerator.notificationOccurred(.error)
    }
    
}
