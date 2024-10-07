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
    @Binding var tapCount : Int
    @State var isMainButtonPressed = false
    @Binding var isSettingsView : Bool
    
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack(alignment:.bottom, spacing: 25){
                    if isMainButtonPressed {
                        Button(action: {
                            withAnimation{
                                isHome.toggle()
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
                                        .foregroundStyle(iconsColor)
                                        .bold()
                                        .padding()

                                    
                                }
                        }
//                        .padding([.leading, .trailing], screenWidth*0.005)

                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        // home button
                        Button(action: {
                            withAnimation{
                                isSettingsView.toggle()
                                isMainButtonPressed.toggle()
                            }
                        }) {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .bold()
                                    
                                }
                        }// settings
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .leading)
                                    .combined(with: .move(edge: .bottom)).combined(with: .opacity),
                                removal: .move(edge: .leading)
                                    .combined(with: .move(edge: .bottom)).combined(with: .opacity)
                            )
                        )

                    }
                    
                    Spacer()
                }
                Spacer()
                HStack(alignment: .bottom, spacing: 25){
                    Button{
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isMainButtonPressed.toggle()
                            triggerHapticFeedback()
                        }
                    }label: {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .frame(width:
                                    isMainButtonPressed ? screenWidth * 0.18: screenWidth * 0.2, height: isMainButtonPressed ? screenWidth * 0.18: screenWidth * 0.2)
                            .shadow(radius: 5)
                            .overlay {
                                Image(systemName: "circle.circle")
                                    .resizable()
                                    .padding()
                                    .foregroundStyle(iconsColor)
                                    .scaleEffect(isMainButtonPressed ? 1.1 : 1)
                            }
                    } // MainButton
                    
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
                        ZStack{
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.40, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .overlay{
                                    VStack{
                                        Text(NSLocalizedString("CountTaps", comment: ""))
                                            .lineLimit(.max)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                        Text("\(tapCount)")
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                }
                        }.transition(.move(edge: .leading).combined(with: .opacity))
                        
                    } //second button
                    else {
                        Spacer()
                    }
                    
                }//HStack
            }
        }
        .frame(width: screenWidth-40, height: screenWidth/2)
        .padding([.leading, .trailing], 10)
    }
}

#Preview {
    @Previewable @State var isHomeScreen = false
    @Previewable @State var IsButtonNextLevel = false
    @Previewable @State var bgcolor = Color.red
    @Previewable @State var taps = 0
    
    Buttons(isHome: $isHomeScreen, isNextLevel: $IsButtonNextLevel, iconsColor: $bgcolor, tapCount: $taps, isSettingsView: .constant(true))}
