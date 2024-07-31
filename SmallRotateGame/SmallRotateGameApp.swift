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
                    printLevelsAdded()
                    saveCurrentNumber(1)
                }
        }
        
    }
}
public var CurrentLevel = getCurrentNumber()
    
public let standartLevels = loadLevels (from: "levels")
let startMap =  [[0, 0, 1, 1, 0, 0],
                [0, 0, 2, 2, 0, 0],
                [0, 0, 3, 5, 1, 0],
                [0, 0, 0, 2, 0, 0],
                [3, 3, 0, 4, 3, 0],
                [3, 3, 0, 1, 1, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]
