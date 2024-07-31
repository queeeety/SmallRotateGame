//
//  Levels.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 30.07.2024.
//

import Foundation
import SwiftCSV

public struct Level: Codable{
    let map : [[Int]]
    var isSolved: Bool
}




func saveLevel(_ level: Level, to fileName: String) {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let url = Bundle.main.url(forResource: fileName, withExtension: "json") ?? getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
    
    // Ініціалізуємо порожній масив, який буде містити всі рівні
    var levels = [Level]()
    
    // Спробуємо прочитати поточний вміст файлу
    if let data = try? Data(contentsOf: url),
       let existingLevels = try? decoder.decode([Level].self, from: data) {
        levels = existingLevels
    }
    
    // Додаємо новий рівень до масиву
    levels.append(level)
    
    // Кодуємо оновлений масив рівнів
    if let newData = try? encoder.encode(levels) {
        try? newData.write(to: url)
        print("Done to \(url)")
    }
}

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func loadLevels(from fileName: String) -> [Level] {
    let url = Bundle.main.url(forResource: "levels", withExtension: "json") ?? getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let levels = try decoder.decode([Level].self, from: data)
        return levels
    } catch {
        print("Помилка при завантаженні даних: \(error)")
        return [Level(map: [], isSolved: false)]
    }
}


func printLevelsAdded(){
    let l = loadLevels (from: "levels")
    if l.count > 1 {
        for level in l {
            print(level.map)
        }
    }
}

func saveCurrentNumber(_ number: Int) {
    
    let url = Bundle.main.url(forResource: "CurrentLevel", withExtension: "json") ?? getDocumentsDirectory().appendingPathComponent("CurrentLevel").appendingPathExtension("json")
    let newData = try! JSONEncoder().encode(number)
    try? newData.write(to: url)
    print("Done \(number) to \(url)")
}

func getCurrentNumber() -> Int {
    let url = Bundle.main.url(forResource: "CurrentLevel", withExtension: "json", subdirectory: nil, localization: nil) ?? getDocumentsDirectory().appendingPathComponent("CurrentLevel").appendingPathExtension("json")
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let number = try decoder.decode(Int.self, from: data)
        return number
    }
    catch {
        return 0
    }
}
