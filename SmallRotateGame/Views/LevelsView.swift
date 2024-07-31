//
//  LevelsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI

struct LevelsView: View {
    @State var levels = loadLevels(from: "levels.json")
    var body: some View {
        ZStack{
            RadialGradient(colors: [.purple,.indigo], center: .top, startRadius: 10, endRadius: 500)
                .ignoresSafeArea()
            if (levels == nil){
                Text("Жодного рівня немає")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.white)
                
            }else{
                ScrollView{
                    ForEach(levels!.indices, id: \.self){ level in
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 80)
                                .foregroundColor(.white.opacity(0.5))
                           
                                
                        }
                    }
                }.onAppear{
                    levels = loadLevels(from: "levels.json")
                }
            }
        }
    }
}

#Preview {
    LevelsView()
}
