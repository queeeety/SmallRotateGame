//
//  LevelsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI
struct LevelsView: View {
    @State private var playerLevels = loadLevels(from: "PlayerLevels")

    var body: some View {
        ZStack{
            RadialGradient(colors: [.purple,.indigo], center: .top, startRadius: 10, endRadius: 500)
                .ignoresSafeArea()
            if (standartLevels.count <= 1){
                Text("Жодного рівня немає")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.white)
                
            }else{
                ScrollView{
                    ForEach(standartLevels.indices, id: \.self){ level in
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 80)
                                .foregroundColor(.white.opacity(0.5))
                           
                                
                        }
                    }
                }.onAppear{
                    playerLevels = loadLevels(from: "PlayerLevels")
                }
            }
        }
    }
}

#Preview {
    LevelsView()
}
