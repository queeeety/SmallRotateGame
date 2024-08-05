//
//  LevelsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI

struct LevelsView: View {
    let screenWidth = UIScreen.main.bounds.width
    @State private var isHomeScreen = false
    @State private var isLevel = false
    @State private var isCustomLevel = false
    @State private var isRegularLevels = true
    @State private var iconsColor = Color.indigo
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
                    if isRegularLevels {
                        if (standartLevels.count <= 1) {
                            Text("Жодного рівня немає")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .transition(.move(edge: .leading))
                                .animation(.smooth, value: isRegularLevels)
                                .frame(maxWidth: .infinity) // Використання maxWidth замість width
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(standartLevels.indices, id: \.self) { level in
                                        let color = standartLevels[level].isSolved ? Color.purple.opacity(0.7) : standartLevels[level-1].isSolved ? Color.purple : Color.purple.opacity(0.3)
                                        Button {
                                            if color == Color.purple || color == Color.purple.opacity(0.7){ //Checking the availability
                                                CurrentLevel = level + 1
                                                withAnimation {
                                                    isLevel.toggle()
                                                }
                                            }
                                        } label: {
                                            ZStack {
                                                
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(height: 100)
                                                    .foregroundColor(color/*.opacity(0.5)*/)
                                                    .shadow(radius: 10)
                                                
                                                Text("\(level+1)")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .onAppear{
                                            print("\(level): \(standartLevels[level].isSolved)")
                                        }
                                    }
                                }
                                .padding([.trailing, .leading], 10)
                                
                            } .transition(.move(edge: .leading))
                                .animation(.smooth, value: isRegularLevels)
                        }
                    }
                    else {
                        if (CreatedLevels.count <= 1) {
                            Text("Жодного рівня немає")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .transition(.move(edge: .trailing))
                                .animation(.smooth, value: !isRegularLevels)
                                .frame(maxWidth: .infinity)

                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(CreatedLevels.indices, id: \.self) { level in
                                        let color = Color.purple
                                        Button {
                                            withAnimation {
                                                isCustomLevel.toggle()
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(height: 100)
                                                    .foregroundColor(color/*.opacity(0.5)*/)
                                                    .shadow(radius: 10)
                                                
                                                Text("\(level+1)")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .onAppear{
                                            print("\(level): \(standartLevels[level].isSolved)")
                                        }
                                    }
                                }
                                .padding([.trailing, .leading], 10)
                                
                            } .transition(.move(edge: .trailing))
                                .animation(.smooth, value: isRegularLevels)
                        }
                    }
                }
                
                VStack { // кнопочки
                    Spacer()
                    HStack(spacing: 30) {
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
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(iconsColor)
                                        .bold()
                                }
                        }
                        Button {
                            withAnimation {
                                isRegularLevels = true
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "flag.2.crossed.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding()
                                        .foregroundStyle(isRegularLevels ? .white :iconsColor)
                                        .bold()
                                }
                        }
                        Button {
                            CreatedLevels = loadLevels(from: "PlayerLevels")
                            withAnimation {
                                isRegularLevels = false
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: screenWidth * 0.18, height: screenWidth * 0.18)
                                .opacity(0.8)
                                .shadow(radius: 5)
                                .overlay {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .padding()
                                        .foregroundStyle(isRegularLevels ? iconsColor : Color.white)
                                        .bold()
                                }
                        }
                    } // Buttons HStack
                }// Buttons VStack
                
                if isHomeScreen {
                    HomeView()
                        .transition(.opacity)
                }
            }
        } // else cloasure
        }
}

#Preview {
    LevelsView()
}
