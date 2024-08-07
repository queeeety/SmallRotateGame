import Foundation

public struct Queue<T> {
    private var elements: [T] = []
    
    public init() {}
    
    public mutating func enqueue(_ element: T) {
        elements.append(element)
    }
    
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : elements.removeFirst()
    }
    
    public func peek() -> T? {
        return elements.first
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
}




let CONNECTIONS: [Int: [[String]]] = [
    1: [["up"], ["down"], ["left"], ["right"]],
    2: [["up", "down"], ["left", "right"]],
    3: [["up", "right"], ["right", "down"], ["down", "left"], ["left", "up"]],
    4: [["up", "right", "down"], ["right", "down", "left"], ["down", "left", "up"], ["left", "up", "right"]],
    5: [["up", "down", "left", "right"]]
]
let DIRECTION_OFFSETS: [String: (Int, Int)] = [
    "up": (-1, 0),
    "down": (1, 0),
    "left": (0, -1),
    "right": (0, 1)
]
let DIRECTIONS_CONNECTIONS: [String: String] = [
    "up": "down",
    "down": "up",
    "left": "right",
    "right": "left"
]




func generateMap(sizes: [[Int]] = [[3, 10], [3, 10]]) -> ([[Int]], [[[String]]]) {
    var connectionsQueue = Queue<(Int, Int)>()
    var level_map_int: [[Int]] = [[]]
    var level_map_connections: [[[String]]] = [[]]

    var deadEnds: [(Int, Int)] = []
    let horisontalSize = Int.random(in: sizes[1][0]..<sizes[1][1])
    let verticalSize = Int.random(in: sizes[0][0]..<sizes[0][1])
    level_map_int = Array(repeating: Array(repeating: 0, count: horisontalSize), count: verticalSize)
    level_map_connections = Array(repeating: Array(repeating: [""], count: horisontalSize), count: verticalSize)
    
    connectionsQueue = Queue<(Int, Int)>()
    let first_Point_horizontal_Position = horisontalSize / 2
    var first_Point_Vertical_Position = Int.random(in: 1..<verticalSize-1)
    var first_element_pos = (first_Point_Vertical_Position, first_Point_horizontal_Position)
    var count_zeros = level_map_int.flatMap { $0 }.filter { $0 == 0 }.count
    
    while count_zeros > level_map_int.count * level_map_int[0].count / 3 * 2 {
        while level_map_int[first_element_pos.0][first_element_pos.1] != 0 || deadEnds.contains(where: { $0 == first_element_pos }) {
            first_Point_Vertical_Position = Int.random(in: 0..<verticalSize)
            first_element_pos = (first_Point_Vertical_Position, Int.random(in: 0..<horisontalSize))
        }
        
        let possibleDictionary = requiredConnections(position: first_element_pos, level_map_int: level_map_int, level_map_connections: level_map_connections)
        if possibleDictionary == [0: []] {
            deadEnds.append(first_element_pos)
            continue
        }
        
        let randomKey = possibleDictionary.keys.randomElement()!
        level_map_int[first_element_pos.0][first_element_pos.1] = randomKey
        let current_Connection = possibleDictionary[randomKey]!.randomElement()!
        level_map_connections[first_element_pos.0][first_element_pos.1] = current_Connection
        
        for direction in current_Connection {
            connectionsQueue.enqueue((first_element_pos.0 + DIRECTION_OFFSETS[direction]!.0, first_element_pos.1 + DIRECTION_OFFSETS[direction]!.1))
        }
        while !connectionsQueue.isEmpty {
            let current_Point = connectionsQueue.dequeue()!
            if level_map_int[current_Point.0][current_Point.1] != 0 { continue }

            let possibleConnections = requiredConnections(position: current_Point, level_map_int: level_map_int, level_map_connections: level_map_connections)
            if possibleConnections.isEmpty { continue }
            
            let randomKey = possibleConnections.keys.randomElement()!
            let randomConnection = possibleConnections[randomKey]!.randomElement()!

            level_map_int[current_Point.0][current_Point.1] = randomKey
            level_map_connections[current_Point.0][current_Point.1] = randomConnection

            for direction in randomConnection {
                let nextPoint = (current_Point.0 + DIRECTION_OFFSETS[direction]!.0, current_Point.1 + DIRECTION_OFFSETS[direction]!.1)
                if level_map_int[nextPoint.0][nextPoint.1] == 0 {
                    connectionsQueue.enqueue(nextPoint)
                }
            }
        }
        count_zeros = level_map_int.flatMap { $0 }.filter { $0 == 0 }.count
    }
    return (level_map_int,level_map_connections)

}


func requiredConnections(position: (Int, Int), level_map_int: [[Int]], level_map_connections: [[[String]]]) -> [Int: [[String]]] {
    var mandatoryConnections: [String] = []
    var impossibleConnections: [String] = []
    var possibleConnections: [Int: [[String]]] = [:]

    let (x, y) = position
    if x != level_map_int.count - 1 {
        if level_map_connections[x + 1][y].contains("up") {
            mandatoryConnections.append("down")
        } else if level_map_int[x + 1][y] != 0 {
            impossibleConnections.append("down")
        }
    } else {
        impossibleConnections.append("down")
    }

    if x != 0 {
        if level_map_connections[x - 1][y].contains("down") {
            mandatoryConnections.append("up")
        } else if level_map_int[x - 1][y] != 0 {
            impossibleConnections.append("up")
        }
    } else {
        impossibleConnections.append("up")
    }

    if y != level_map_int[0].count - 1 {
        if level_map_connections[x][y + 1].contains("left") {
            mandatoryConnections.append("right")
        } else if level_map_int[x][y + 1] != 0 {
            impossibleConnections.append("right")
        }
    } else {
        impossibleConnections.append("right")
    }

    if y != 0 {
        if level_map_connections[x][y - 1].contains("right") {
            mandatoryConnections.append("left")
        } else if level_map_int[x][y - 1] != 0 {
            impossibleConnections.append("left")
        }
    } else {
        impossibleConnections.append("left")
    }

    if x == 0 && y == 0 {
        impossibleConnections.append(contentsOf: ["up", "left"])
    } else if x == 0 && y == level_map_int[0].count - 1 {
        impossibleConnections.append(contentsOf: ["up", "right"])
    } else if x == level_map_int.count - 1 && y == 0 {
        impossibleConnections.append(contentsOf: ["down", "left"])
    } else if x == level_map_int.count - 1 && y == level_map_int[0].count - 1 {
        impossibleConnections.append(contentsOf: ["down", "right"])
    }

    for (key, value) in CONNECTIONS {
        for connection in value {
            if Set(mandatoryConnections).isSubset(of: connection) && Set(impossibleConnections).isDisjoint(with: connection) {
                if possibleConnections[key] != nil {
                    possibleConnections[key]!.append(connection)
                } else {
                    possibleConnections[key] = [connection]
                }
            }
        }
    }
    
    if possibleConnections.isEmpty {
        return [0: []]
    }
    
    return possibleConnections
}

func factChecking(level_map_int: [[Int]], level_map_connections: [[[String]]]) -> Bool {
    for i in 0..<level_map_int.count {
        for j in 0..<level_map_int[i].count {
            if level_map_connections.isEmpty { continue }
            for conn in level_map_connections[i][j] {
                if conn.isEmpty { continue }
                if i == level_map_int.count - 1 && conn == "down" { return false }
                if i == 0 && conn == "up" { return false }
                if j == level_map_int[i].count - 1 && conn == "right" { return false }
                if j == 0 && conn == "left" { return false }
                
                let new_i = i + DIRECTION_OFFSETS[conn]!.0
                let new_j = j + DIRECTION_OFFSETS[conn]!.1
                if new_i < 0 || new_i >= level_map_int.count || new_j < 0 || new_j >= level_map_int[0].count {
                    continue
                }
                if !level_map_connections[new_i][new_j].contains(DIRECTIONS_CONNECTIONS[conn]!) {
                    return false
                }
            }
        }
    }
    print("All is good")
    return true
}
    

func MapGenerator(difficulty: Int) -> [[Int]]{
    let difficultiesSizeMap: [Int: [[Int]]] = [
        1: [[3,4], [3,4]],
        2: [[5, 6], [5,6]],
        3: [[7, 8], [7, 8]],
        4: [[9, 10], [7,8]],
        5: [[11,14], [8, 10]]
    ]
    let sizes = difficultiesSizeMap[difficulty]!
    
    while true {
        let maps = generateMap(sizes: sizes)
        if factChecking(level_map_int:maps.0, level_map_connections: maps.1) {
            print (maps.0)
        } else {
            continue
        }
        return maps.0
    }
}
