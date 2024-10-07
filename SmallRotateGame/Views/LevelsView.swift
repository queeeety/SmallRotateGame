//
//  LevelsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 31.07.2024.
//

import SwiftUI

struct LevelsView: View {
    let screenWidth = UIScreen.main.bounds.width
    @State private var isLevel = false
    @State private var isCustomLevel = false
    
    @Binding var isActive: Bool
    @Binding var isGame : Bool
    @State private var isRegularLevels = true
    
    @State private var iconsColor = Color.indigo
    @State private var levels = CreatedLevels
    
    @State private var translation : CGSize = .zero
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        if isLevel {
            SceneBuilder2(mode: 1, isActive: $isGame)
                .transition(.opacity)
                .onAppear {
                    isGame = true
                }
                .onChange(of:isGame){
                    if !isGame{
                        withAnimation{
                            isActive = false
                        }
                    }
                }
        } else if isCustomLevel {
            SceneBuilder2(mode: 2, isActive: $isGame)
                .transition(.opacity)
                .onAppear {
                    isGame = true
                }
                .onChange(of:isGame){
                    if !isGame{
                        withAnimation{
                            isActive = false
                        }
                    }
                }
        } else {
            ZStack {
                LinearGradient(colors: [.purple,.indigo,.indigo], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    if isRegularLevels {
                        if (standartLevels.count <= 1) {
                            Text(NSLocalizedString("NoStandartLevels", comment:""))
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
                                                UserDefaults.standard.set(level + 1, forKey:"CurrentLevel")
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
                        if (CreatedLevels.isEmpty) {
                            Text(NSLocalizedString("NoPlayersLevels", comment:""))
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .transition(.move(edge: .trailing))
                                .animation(.smooth, value: !isRegularLevels)
                                .frame(maxWidth: .infinity)

                        } else {
                            ScrollView {
                                VStack{
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(levels.indices, id: \.self) {level in
                                        let color = Color.purple
                                        Button {
                                            withAnimation {
                                                UserDefaults.standard.set(level + 1, forKey:"PlayersLevel")
                                                isCustomLevel.toggle()
                                            }
                                        } label: {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(height: 100)
                                                .foregroundColor(color)
                                                .shadow(radius: 10)
                                                .overlay{
                                                    Text("\(level+1)")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.white)
                                                }
                                                .contextMenu {
                                                    Button(role:.destructive) {
                                                        CustomLevelsDeletion(mode:2, level: level)
                                                    } label: {
                                                        Text(NSLocalizedString("Delete", comment:""))
                                                    }
                                                }
                                        }
                                        .transition(.opacity)
                                        .onAppear{
                                            print("\(level): \(levels[level].isSolved)")
                                        }
                                    }
                                }
                                .onAppear{
                                    levels = CreatedLevels
                                }
                                .padding([.trailing, .leading], 10)
                                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LevelsUpdated"))) { _ in
                                    withAnimation{
                                        levels = CreatedLevels
                                    }
                                }
                                .padding([.trailing, .leading], 10)
                                Button(){
                                    CustomLevelsDeletion(mode:1)
                                    
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 40)
                                            .foregroundStyle(.white.opacity(0.4))
                                            .shadow(radius: 10)
                                            .overlay{
                                                HStack{
                                                    Image(systemName: "delete.right.fill")
                                                        .foregroundStyle(.white)
                                                    Text(NSLocalizedString("DeleteAll", comment:""))
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                    }
                                }
                                // Button delete all
                                .frame(width: 200, height: 50)
                                .padding(.top, 20)
                            }
                            } .transition(.move(edge: .trailing))
                                .animation(.smooth, value: isRegularLevels)
                                
                        }
                    }
                }
                    
                    
                    VStack { // кнопочки
                        Spacer()
                        ZStack{
                            Rectangle()
                                .foregroundStyle(
                                    LinearGradient(colors: [.indigo.opacity(0.2), .indigo.opacity(0.9)], startPoint: .top, endPoint: .bottom))
                                .blur(radius: 10)
                                .frame(height: screenWidth * 0.3)
                                
                            HStack(spacing: 30) {
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
                                Button {
                                    withAnimation {
                                        isActive.toggle()
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
                            }
                            
                        } // Buttons HStack
                        
                    }// Buttons VStack
                    .ignoresSafeArea(.all)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                    }
                    .onEnded { value in
                        if translation.width < -50 {
                            // Свайп вліво
                            print ("LEFT SWIPE IN LEVELS DETECTED")
                            withAnimation{
                                if isRegularLevels {
                                    isRegularLevels = false
                                }
                                else {
                                    isActive = false
                                }
                            }
                        } else if translation.width > 50 {
                            // Свайп вправо
                            print ("RIGHT SWIPE IN LEVELS DETECTED")
                            withAnimation{
                                if !isRegularLevels {
                                    isRegularLevels = true
                                }
                            }
                        }
                        translation = .zero
                    }
            )

        } // else cloasure
        }
}

#Preview {
    LevelsView(isActive: .constant(true), isGame: .constant(false))
}
