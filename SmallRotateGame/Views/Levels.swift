import Foundation

public struct Level: Codable {
    let map: [[Int]]
    var isSolved: Bool
}

public let mainURL = getDocumentsDirectory().appendingPathComponent("levels").appendingPathExtension("json")

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func saveLevel(_ level: Level, to fileName: String, numberOfLevelDone: Int = 0) {
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

func saveCurrentNumber(_ number: Int) {
    let url = getDocumentsDirectory().appendingPathComponent("CurrentLevel").appendingPathExtension("json")
    let newData = try! JSONEncoder().encode(number)
    try? newData.write(to: url)
    changeLevelReachability(numberOfLevelDone: number)

}

func getCurrentNumber() -> Int {
    let url = getDocumentsDirectory().appendingPathComponent("CurrentLevel").appendingPathExtension("json")
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

