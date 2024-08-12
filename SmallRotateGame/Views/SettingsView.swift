//
//  SettingsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 12.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isClose : Bool
    var body: some View {
        ZStack{


                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.8)
                    .ignoresSafeArea(.all)
                    .blur(radius: 10)
                    .onTapGesture {
                        withAnimation{
                            isClose = false
                        }
                    }
                RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.ultraThinMaterial)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.7)
            }

    }
}

#Preview {
   
                 @Previewable @State var isClose : Bool = true
    SettingsView(isClose: $isClose)
}
