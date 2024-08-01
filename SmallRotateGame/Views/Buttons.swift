//
//  Buttons.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 01.08.2024.
//

import SwiftUI

struct Buttons: View {
    @Binding var isHome : Bool
    @Binding var isNextLevel : Bool
    @Binding var iconsColor : Color
    @State var MainButtonImage = "gear"
    @State var isMainButtonPressed = false
    
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if isMainButtonPressed {
                        Button(action: {
                            withAnimation{
                                isHome = true
                            }
                        }) {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .bold()

                                }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } //first button
                    
                    Spacer()
                }
                Spacer()
                HStack(alignment: .bottom){
                    Button{
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isMainButtonPressed.toggle()
                            MainButtonImage = isMainButtonPressed ? "xmark" : "gear"
                        }
                    }label: {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                            .shadow(radius: 5)
                            .overlay {
                                Image(systemName: MainButtonImage)
                                    .resizable()
                                    .padding()
                                    .foregroundStyle(iconsColor)
                                    .rotationEffect(.degrees(isMainButtonPressed ? 180 : 0))
                            }
                    } // MainButton
                    Spacer()
                    if isMainButtonPressed{
                        Button{
                            isNextLevel = true
                        } label: {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay{
                                    Image(systemName: "arrowshape.backward.fill")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .rotationEffect(.degrees(isMainButtonPressed ? 180 : 0))
                                        .bold()
                                }
                            
                        }.transition(.move(edge: .leading).combined(with: .opacity))

                        // exit
                    } //third button
                }//HStack
            }
        }
        .frame(width: screenWidth/2, height: screenWidth/2)
    }
}

#Preview {
    @State var isHomeScreen = false
    @State var IsButtonNextLevel = false
    @State var bgcolor = Color.red
    
    Buttons(isHome: $isHomeScreen, isNextLevel: $IsButtonNextLevel, iconsColor: $bgcolor)}
