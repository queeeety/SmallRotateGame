//
//  Trial.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 12.08.2024.
//

import SwiftUI

struct Trial: View {
    @State private var musicVolume: Double = 0.5
    @State private var isEditing: Bool = false

    var volumeImageName: String {
        switch musicVolume {
        case 0:
            return "speaker.slash.fill"
        case 0..<0.3:
            return "speaker.wave.1.fill"
        case 0.3..<0.7:
            return "speaker.wave.2.fill"
        default:
            return "speaker.wave.3.fill"
        }
    }

    var body: some View {
        HStack {
            Slider(value: $musicVolume, in: 0...1, step: 0.1, onEditingChanged: { editing in
                withAnimation {
                    isEditing = editing
                }
            })
            .accentColor(.purple)
            .frame(width: 200) // Задайте фіксовану ширину для основи слайдера

            ZStack {

                
                // Анімоване зображення на основі значення слайдера
                Image(systemName: volumeImageName)
                    .resizable()
                    .foregroundStyle(isEditing ? .purple : .white)
                    .scaledToFit()
//                    .frame(width: 40, height: 80)
                    .padding(5)
                    .transition(.opacity) // Анімація зміни іконки
                    .animation(.easeInOut(duration: 0.3), value: musicVolume) // Анімація при зміні значення
            }
        }
    }
}

#Preview{
    Trial()
}
