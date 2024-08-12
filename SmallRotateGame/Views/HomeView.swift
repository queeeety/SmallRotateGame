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
    @State var isRandomLevel = false
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            RadialGradient(colors: [.purple,.indigo], center: .top, startRadius: 10, endRadius: 500)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text(NSLocalizedString("Chain", comment: "game name"))
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
                        .overlay(Text(NSLocalizedString("Play", comment: "Start game"))
                            .foregroundColor(.white).font(.title))
                        .shadow(radius: 5)
                        .foregroundStyle(.ultraThinMaterial)
                }
                Spacer()
                Spacer()
                HStack(alignment: .top){
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
                            Text(NSLocalizedString("LevelMap", comment: "")).foregroundColor(.white).font(.headline).lineLimit(nil)
                        }
                        .frame(width: screenWidth/3-10)

                        
                    }
                    Spacer()
                    Button{
                        withAnimation(.smooth(duration: 0.3)){
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
                            Text(NSLocalizedString("CreateLevel", comment:"")).foregroundColor(.white).font(.headline).lineLimit(nil)
                        }.frame(width: screenWidth/3-10)
                    }
                    Spacer()
                    Button{
                        withAnimation{
                            isRandomLevel.toggle()
                        }
                    } label:{
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
                            Text(NSLocalizedString("EndlessMode", comment: "")).foregroundColor(.white).font(.headline).lineLimit(nil)
                        }.frame(width: screenWidth/3-10)
                    }
                    
                }
            }
            if isGameScreen{
                SceneBuilder2(mode: 1)
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
            else if isRandomLevel {
                DifficultView()
                    .transition(.opacity)
            }
        }//ZStack
    }
}

#Preview {
    HomeView()
}
