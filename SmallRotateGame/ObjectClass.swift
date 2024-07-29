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
    let picture: String
    let id: Int
    var number: Int = 0

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
        self.number = self.directions.count
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

