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
    @State var isSettings = false
    @State var isMainScreen = true
    @State private var currentIndex = 0 // Додано для керування екраном
    @State private var translation: CGSize = .zero

    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .indigo, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text(NSLocalizedString("Chain", comment: "game name"))
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Button {
                    withAnimation {
                        isGameScreen = true
                        isMainScreen = false
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
                Button {
                    withAnimation {
                        isRandomLevel.toggle()
                        isMainScreen = false
                    }
                } label: {
                    VStack {
                        Circle()
                            .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                            .overlay {
                                Image(systemName: "play.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 45))
                                    .fontWeight(.semibold)
                            }
                            .shadow(radius: 5)
                            .foregroundStyle(.ultraThinMaterial)
                        Text(NSLocalizedString("EndlessMode", comment: "")).foregroundColor(.white).font(.headline).lineLimit(nil)
                    }
                    .frame(width: screenWidth/3-10)
                }
                .padding(.bottom)
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            isLevelsScreen.toggle()
                            isMainScreen = false
                        }
                    } label: {
                        VStack {
                            Circle()
                                .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                .overlay {
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
                    Button {
                        withAnimation(.smooth(duration: 0.3)) {
                            isMainScreen = false
                            isCreateLevelScreen.toggle()
                        }
                    } label: {
                        VStack {
                            Circle()
                                .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                .overlay {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.white)
                                        .font(.system(size: 45))
                                        .fontWeight(.semibold)
                                }
                                .shadow(radius: 5)
                                .foregroundStyle(.ultraThinMaterial)
                            Text(NSLocalizedString("CreateLevel", comment:"")).foregroundColor(.white).font(.headline).lineLimit(nil)
                        }
                        .frame(width: screenWidth/3-10)
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            isSettings.toggle()
                            triggerHapticFeedback()
                        }
                    } label: {
                        VStack {
                            Circle()
                                .frame(minWidth: 50, idealWidth: 75, maxWidth: 80, minHeight: 50, idealHeight: 75, maxHeight: 80)
                                .overlay {
                                    Image(systemName: "gear")
                                        .foregroundColor(.white)
                                        .font(.system(size: 45))
                                        .fontWeight(.semibold)
                                }
                                .shadow(radius: 5)
                                .foregroundStyle(.ultraThinMaterial)
                            Text(NSLocalizedString("Settings", comment: "")).foregroundColor(.white).font(.headline).lineLimit(nil)
                        }
                        .frame(width: screenWidth/3-10)
                    }
                }
            }
            .onChange(of: isGameScreen,{isMainScreen = !isGameScreen})
            .onChange(of: isLevelsScreen,{isMainScreen = !isGameScreen})
            .onChange(of: isCreateLevelScreen,{isMainScreen = !isCreateLevelScreen})
            .onChange(of: isRandomLevel, {isMainScreen = !isRandomLevel})

        }// ZStack


        .overlay {
            Group {
                if isSettings {
                    SettingsView(isActive: $isSettings)
                        .transition(.opacity)
                        .animation(.easeInOut, value: isSettings) // Анімація на рівні переходу
                }
                if isGameScreen && !isLevelsScreen && !isRandomLevel{
                    SceneBuilder2(mode: 1, isActive: $isGameScreen)
                        .transition(.opacity)                        .animation(.easeInOut, value: isGameScreen) // Анімація на рівні переходу
                } else if isLevelsScreen {
                    LevelsView(isActive: $isLevelsScreen, isGame: $isGameScreen)
                        .transition(.move(edge: .leading))
                        .animation(.easeInOut, value: isLevelsScreen) // Анімація на рівні переходу

                } else if isCreateLevelScreen {
                    Group{
                        BuildYourLevel(isActive: $isCreateLevelScreen)
                            .transition(.move(edge: .trailing)) // Додано анімацію переходу
                            .animation(.easeInOut, value: isCreateLevelScreen)
                    }
                } else if isRandomLevel {
                    DifficultView(isActive: $isRandomLevel, isGame: $isGameScreen)
                        .transition(.opacity)
                        .animation(.easeInOut, value: isRandomLevel)
                }
            }
        
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    translation = value.translation
                }
                .onEnded { value in
                    if translation.width < -50 {
                        // Свайп вліво
                        print ("LEFT SWIPE DETECTED")
                        withAnimation{
                            if isMainScreen {
                                isCreateLevelScreen = true
                                isMainScreen = false
                            }
                        }
                    } else if translation.width > 50 {
                        // Свайп вправо
                        print ("RIGHT SWIPE DETECTED")
                        withAnimation{
                            if isMainScreen {
                                isLevelsScreen = true
                                isMainScreen = false
                            } else if isCreateLevelScreen{
                                isCreateLevelScreen = false
                                isMainScreen = true
                            } else if isRandomLevel {
                                isRandomLevel = false
                                isMainScreen = true
                            }
                        }
                    }
                    else if translation.height < -50 {
                        print("SHOULD BE UPPER SWIPE")
                        if isMainScreen{
                            withAnimation{
                                isSettings = true
                            }
                        }
                    }
                    else if translation.height > 50 {
                        withAnimation{
                            if isSettings {
                                isSettings = false
                            } else if isMainScreen {
                                isGameScreen = true
                                isMainScreen = false
                            }
                        }
                    }
                    translation = .zero
                }
        )
    }
}

#Preview {
    HomeView()
}
