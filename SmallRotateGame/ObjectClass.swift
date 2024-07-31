//
//  ObjectClass.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 28.07.2024.
//

import Foundation
import SwiftUI
import SwiftSVG

class LineObject: ObservableObject {
    @Published var directions: [String] = []

    @Published var angle: Angle = .degrees(0)
    let fgcolor: Color
    var picture: String
    let id: Int
    var number: Int = 0
    var UIPicture : UIView = UIView()
    
    init(number: Int, color: Color) {
        self.fgcolor = color 
        self.id = number
        switch number {
        case 1:
            self.picture = "one"
            self.directions = ["down"]
        case 2:
            self.picture = "line"
            self.directions = ["up", "down"]
        case 3:
            self.picture = "corner"
            self.directions = ["down", "right"]
        case 4:
            self.picture = "t"
            self.directions = ["up", "down", "right"]
        case 5:
            self.picture = "x"
            self.directions = ["up", "left", "down", "right"]
        default:
            self.picture = "0"
        }
//        changeSVGColor(assetName: self.picture, color: UIColor(self.fgcolor))
        
        self.number = self.directions.count
        startRandomRotate()
    }

    func rotate(completion: @escaping () -> Void) {
        withAnimation {
            angle += .degrees(90)
            let transitionMap = ["up": "right", "down": "left", "left": "up", "right": "down"]
            let newDirections = directions.map { transitionMap[$0] ?? $0 }
            directions = newDirections
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // assuming the animation takes 0.3 seconds
            completion()
        }
    }

    func startRandomRotate() {
        let randomNumber = Int.random(in: 0...3)
        for _ in 0...randomNumber {
            rotate() {}
        }
    }
    
//    func changeSVGColor(assetName: String, color: UIColor) {
//        // Завантаження SVG з assets
//        if let url = Bundle.main.url(forResource: assetName, withExtension: "svg") {// Створення UIView для відображення SVG
//            let svgView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            
//            // Зміна кольору та рендеринг SVG
//            let svgLayer = CALayer(svgURL: url) { layer in
//                layer.fillColor = color.cgColor
//            }
//            svgView.layer.addSublayer(svgLayer)
//            svgLayer.frame = svgView.bounds
//            
//            self.UIPicture = svgView
//        }
//        else {
//            print("Не вдалося знайти SVG файл з назвою \(assetName) у assets")
//        }

        
//    }
}

struct LineObj: View {
    @ObservedObject var viewModel: LineObject
    var onTap: (() -> Void)?
    
    init(viewModel: LineObject, onTap: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
    }

    var body: some View {
        Button(action: {
            viewModel.rotate {
                onTap?()
            }
        }) {
            Image(viewModel.picture)
                .resizable()
                .rotationEffect(viewModel.angle)
                .foregroundColor(viewModel.fgcolor)
            
        }
    }
}


func performCheckCompleteness(elements: [[LineObject]]) -> Bool {
    let rows = elements.count
    let cols = elements[0].count

    let oppositeDirection: [String: String] = [
        "up": "down",
        "down": "up",
        "left": "right",
        "right": "left"
    ]

    for i in 0..<rows {
        for j in 0..<cols {
            let currentDirections = elements[i][j].directions
            for direction in currentDirections {
                var hasNeighbor = false

                switch direction {
                case "up":
                    if i > 0 {
                        hasNeighbor = elements[i-1][j].directions.contains(oppositeDirection[direction]!)
                    }
                case "down":
                    if i < rows - 1 {
                        hasNeighbor = elements[i+1][j].directions.contains(oppositeDirection[direction]!)
                    }
                case "left":
                    if j > 0 {
                        hasNeighbor = elements[i][j-1].directions.contains(oppositeDirection[direction]!)
                    }
                case "right":
                    if j < cols - 1 {
                        hasNeighbor = elements[i][j+1].directions.contains(oppositeDirection[direction]!)
                    }
                default:
                    break
                }

                if !hasNeighbor {
                    return false
                }
            }
        }
    }
    return true
}
