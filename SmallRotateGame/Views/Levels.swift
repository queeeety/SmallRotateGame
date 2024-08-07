import Foundation

public struct Level: Codable {
    let map: [[Int]]
    var isSolved: Bool
}

public let mainURL = getDocumentsDirectory().appendingPathComponent("levels").appendingPathExtension("json")

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func saveLevel(_ level: Level, to fileName: String) -> Bool {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let url = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
    
    var levels = [Level]()
    
    if let data = try? Data(contentsOf: url),
       let existingLevels = try? decoder.decode([Level].self, from: data) {
        levels = existingLevels
    }
    
    levels.append(level)
    
    if let newData = try? encoder.encode(levels) {
        try? newData.write(to: url)
        print("Done to \(url)")
        
    }
    else {
        return false
    }
    return true
}

func loadLevels(from fileName: String) -> [Level] {
    let url = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
    print("LoadLevels done \(url)")
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let levels = try decoder.decode([Level].self, from: data)
        return levels
    } catch {
        print("Помилка при завантаженні даних: \(error)")
        return [Level(map: startMap, isSolved: false)]
    }
}

func loadLevelsFromFileDirectly()->[Level]{
    let url = Bundle.main.url(forResource: "levels", withExtension: "json")!
    do{
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let levels = try! decoder.decode([Level].self, from: data)
        return levels
    }
    catch {
        print ("Error \(error)")
        return ([Level(map: startMap, isSolved: false)])
    }
    
}

func saveCurrentNumber(_ number: Int, mode: Int = 1) {
    let names = [1: "CurrentLevel",
        2: "CurrentPlayerLevel"]
    let url = getDocumentsDirectory().appendingPathComponent(names[mode]!).appendingPathExtension("json")
    let newData = try! JSONEncoder().encode(number)
    try? newData.write(to: url)
    if mode == 1 {
        changeLevelReachability(numberOfLevelDone: number)
    }
    updateVariablesWithLevels(mode: mode)
    
}

func getCurrentNumber(mode: Int = 1) -> Int {
    let names = [1: "CurrentLevel",
        2: "CurrentPlayerLevel"]
    let url = getDocumentsDirectory().appendingPathComponent(names[mode]!).appendingPathExtension("json")
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let number = try decoder.decode(Int.self, from: data)
        return number
    } catch {
        return 1
    }
}

func changeLevelReachability(numberOfLevelDone: Int) {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var levels = [Level]()
    if let data = try? Data(contentsOf: mainURL),
       let existingLevels = try? decoder.decode([Level].self, from: data) {
        levels = existingLevels
        levels[numberOfLevelDone - 1].isSolved = true
        
        if let newData = try? encoder.encode(levels) {
            try? newData.write(to: mainURL)
            print("Done to \(mainURL)")
        }
    }
}

func createInitialLevelsFile() {
    let url = getDocumentsDirectory().appendingPathComponent("levels").appendingPathExtension("json")
    if !FileManager.default.fileExists(atPath: url.path) {
        saveCurrentNumber(1)
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "levels", withExtension: "json")!)
            let decoder = JSONDecoder()
            let levels = try decoder.decode([Level].self, from: data)
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(levels) {
                try? data.write(to: url)
                print("Initial levels file created at \(url)")
            }
        } catch {
            print("Помилка при завантаженні даних: \(error)")
        }
        
    }
}

func updateVariablesWithLevels(mode: Int = 1){
    switch mode {
        
    case 1:
        CurrentLevel = getCurrentNumber()
        standartLevels = loadLevels(from: "levels")
    case 2:
        CurrentPlayersLevel = getCurrentNumber(mode: 2)
        CreatedLevels = loadLevels(from: "PlayerLevels")
    default:
        break
    }
}

func CustomLevelsDeletion(mode: Int = 1, level: Int = 0) // mode: 1 - full deletion, 2 - 1 level deletion
{
    let encoder = JSONEncoder()
    let filePath = getDocumentsDirectory().appendingPathComponent("PlayerLevels").appendingPathExtension("json")

    if mode == 1 {
        CreatedLevels.removeAll()
        do {
            let data = try JSONSerialization.data(withJSONObject: [], options: .prettyPrinted)
            if let jsonString = String(data: data, encoding: .utf8) {
                try jsonString.write(to: filePath, atomically: true, encoding: .utf8)
                print("Файл успішно перезаписано")
            }
        } catch {
            print("Помилка при перезаписанні файлу: \(error.localizedDescription)")
        }
    }
    else {
        CreatedLevels.remove(at: level)
        if let newData = try? encoder.encode(CreatedLevels) {
            try? newData.write(to: filePath)
            print("File was rewritten to \(mainURL)")
        }
    }
    NotificationCenter.default.post(name: Notification.Name("LevelsUpdated"), object: nil)
}
