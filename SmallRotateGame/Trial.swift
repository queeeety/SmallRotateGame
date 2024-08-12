//
//  Trial.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 12.08.2024.
//

import SwiftUI
import AVFoundation

struct Trial: View {
    var body: some View {
        List{
            ForEach(1000...1335, id: \.self){ number in
                Button("\(number)"){
                    AudioServicesPlaySystemSound(SystemSoundID(number))
                }
                    
            }
        }
    }
}

#Preview {
    Trial()
}

//1104 
