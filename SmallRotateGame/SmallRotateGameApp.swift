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
                    if let fileURL = Bundle.main.url(forResource: "levels", withExtension: "json") {
                        print("File URL: \(fileURL)")
                    }
                    printLevelsAdded()
                }
        }
        
    }
}

let startMap =  [[0, 0, 1, 1, 0, 0],
                [0, 0, 2, 2, 0, 0],
                [0, 0, 3, 5, 1, 0],
                [0, 0, 0, 2, 0, 0],
                [3, 3, 0, 4, 3, 0],
                [3, 3, 0, 1, 1, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]
