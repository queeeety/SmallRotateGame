//
//  SwiftUIView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI

struct HomeView: View {
    @State var isGameScreen = false
    @State var isLevelsScreen = false
    @State var isCreateLevelScreen = false
    var body: some View {
        ZStack{
            if isGameScreen{
                SceneBuilder(isRegularPlay: true)
                    .transition(.opacity)
            }
            else if isLevelsScreen {
                LevelsView()
                    .transition(.opacity)
            }
            else if isCreateLevelScreen {
                BuildYourLevel()
                    .transition(.opacity)
            }
            else{
                    ZStack{
                        RadialGradient(colors: [.purple,.indigo], center: .top, startRadius: 10, endRadius: 500)
                            .ignoresSafeArea()
                        VStack{
                            Spacer()
                            Text("Ланцюжок")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                            Button(){
                                withAnimation{
                                    isGameScreen = true
                                }
                            } label: {
                                Circle()
                                    .frame(minWidth: 75, idealWidth: 100, maxWidth: 125, minHeight: 75, idealHeight: 100, maxHeight: 125)
                                    .overlay(Text("Грати").foregroundColor(.white).font(.title))
                                    .shadow(radius: 5)
                                    .foregroundStyle(.ultraThinMaterial)
                            }
                            Spacer()
                            Spacer()
                            HStack(alignment: .bottom){
                                Spacer()
                                Button{
                                    withAnimation{
                                        isLevelsScreen.toggle()
                                    }
                                }label:{
                                    VStack{
                                        Circle()
                                            .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                            .overlay{
                                                Image(systemName: "map.circle")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 45))
                                                    .fontWeight(.semibold)
                                            }
                                            .shadow(radius: 5)
                                            .foregroundStyle(.ultraThinMaterial)
                                        Text("Доступні").foregroundColor(.white).font(.headline)
                                    }
                                    
                                }
                                Spacer()
                                Button{
                                    withAnimation{
                                        isCreateLevelScreen.toggle()
                                    }
                                }label:{
                                    VStack{
                                        Circle()
                                            .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                            .overlay{
                                                Image(systemName: "plus.circle")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 45))
                                                    .fontWeight(.semibold)
                                            }
                                            .shadow(radius: 5)
                                            .foregroundStyle(.ultraThinMaterial)
                                        Text("Створити").foregroundColor(.white).font(.headline)
                                    }
                                }
                                Spacer()
                                Button{} label:{
                                    VStack{
                                        Circle()
                                            .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                            .overlay{
                                                Image(systemName: "play.circle")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 45))
                                                    .fontWeight(.semibold)
                                            }
                                            .shadow(radius: 5)
                                            .foregroundStyle(.ultraThinMaterial)
                                        Text("хз шо").foregroundColor(.white).font(.headline)
                                    }
                                }
                                Spacer()
                                
                            }
                        }
                    }
            }
        }//ZStack
    }
}

#Preview {
    HomeView()
}
