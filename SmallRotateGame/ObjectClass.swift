//
//  ObjectClass.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 28.07.2024.
//

import Foundation
import SwiftUI

class LineObject: ObservableObject {
    @Published var left: Bool = false
    @Published var right: Bool = false
    @Published var down: Bool = false
    @Published var up: Bool = false
    @Published var angle: Angle = .zero
    let picture: String
    let number: Int

    init(number: Int) {
        self.number = number
        switch number {
        case 1:
            self.picture = "one"
            self.up = true
        case 2:
            self.picture = "line"
            self.left = true
            self.right = true
        case 3:
            self.picture = "corner"
            self.up = true
            self.right = true
        case 4:
            self.picture = "t"
            self.up = true
            self.left = true
            self.right = true
        case 5:
            self.picture = "x"
            self.up = true
            self.left = true
            self.right = true
            self.down = true
        default:
            self.picture = "0"
        }
    }

    func rotate() {
        angle += .degrees(90)
        // Rotate properties
        let tempRight = self.up
        let tempDown = self.right
        let tempLeft = self.down
        let tempUp = self.left
        self.up = tempLeft
        self.right = tempUp
        self.down = tempRight
        self.left = tempDown
    }
}

struct LineObj: View{
    
    @StateObject private var viewModel: LineObject

     init(number: Int) {
         _viewModel = StateObject(wrappedValue: LineObject(number: number))
     }

     var body: some View {
         Button(action: {
             viewModel.rotate()
         }) {
             Image(viewModel.picture)
                 .resizable()
                 .scaledToFit()
                 .rotationEffect(viewModel.angle)
         }
     }

}
