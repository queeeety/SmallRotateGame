//
//  LevelsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI

struct LevelsView: View {
    let screenWidth = UIScreen.main.bounds.width
    @State private var playerLevels = loadLevels(from: "levels")
    @State private var isHomeScreen = false
    @State private var isLevel = false
    @State private var iconsColor = LinearGradient(colors: [.indigo], startPoint: .leading, endPoint: .bottomTrailing)
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        checkFirstLaunch()
    }
    
    var body: some View {
        if isLevel {
            SceneBuilder(isRegularPlay: true)
                .transition(.opacity)
        } else {
            ZStack {
                RadialGradient(colors: [.purple, .indigo], center: .top, startRadius: 10, endRadius: 500)
                    .ignoresSafeArea()
                VStack {
                    
                    if (standartLevels.count <= 1) {
                        Text("Жодного рівня немає")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.white)
                        
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(standartLevels.indices, id: \.self) { level in
                                    let color = playerLevels[level].isSolved ? Color.purple.opacity(0.7) : playerLevels[level-1].isSolved ? Color.purple : Color.purple.opacity(0.3)
                                    Button {
                                        if color == Color.purple || color == Color.purple.opacity(0.7){ //Checking the availability
                                            CurrentLevel = level + 1
                                            withAnimation {
                                                isLevel.toggle()
                                            }
                                        }
                                    } label: { ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(height: 100)
                                            .foregroundColor(color/*.opacity(0.5)*/)
                                            .shadow(radius: 10)
                                        
                                        Text("\(level+1)")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                    }
                                    }
                                }
                            }
                            .padding([.trailing, .leading], 10)
                        }

                    }
                }
                VStack { // кнопочки
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                isHomeScreen.toggle()
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "arrowshape.backward.fill")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .bold()
                                }
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        
                        Button {
                            withAnimation {
                                self.playerLevels = loadLevels(from: "levels")
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "arrow.circlepath")
                                        .resizable()
                                        .bold()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .bold()
                                }
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    } // Buttons HStack
                }// Buttons VStack
                
                
                if isHomeScreen {
                    HomeView()
                        .transition(.opacity)
                }
            } // ZStack
        }//else closure
    }
}

#Preview {
    LevelsView()
}
