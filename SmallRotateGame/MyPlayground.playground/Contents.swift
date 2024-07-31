import UIKit
import SwiftCSV






func ConvertAndWriteToCSV(data: [[Int]]) {
    var csvString = ""
    
    // Add the data rows
    for row in data {
        let rowStr = row.map { String($0) }
        let values = rowStr.joined(separator: " ")
        csvString += values + ","
    }
    csvString += "\n"

    do {
        // Get the document directory for the app
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Create the full file path
            let fileURL = documentsDirectory.appendingPathComponent("levels.csv")
            
            // Write the CSV string to the file
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved at: \(fileURL.path)")
        }
    } catch {
        print("Error writing CSV file: \(error)")
    }
}


let startMap2 =  [[0, 0, 1, 1, 0, 0],
                [0, 0, 2, 2, 0, 0],
                [0, 0, 3, 5, 1, 0],
                [0, 0, 0, 2, 0, 0],
                [3, 3, 0, 4, 3, 0],
                [3, 3, 0, 1, 1, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]



ConvertAndWriteToCSV(data: startMap2)

