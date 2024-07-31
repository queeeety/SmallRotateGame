////
////  LevelsSwitch.swift
////  SmallRotateGame
////
////  Created by Тимофій Безверхий on 31.07.2024.
////
//
//import SwiftUI
//
//struct LevelsSwitch: View {
//    @State var isCompleted: Bool = false
//    @State var currentLevelObjMap: [[Int]] = []
//    @State private var showSceneBuilder = false
//
//    var body: some View {
//        ZStack {
//            if showSceneBuilder {
//                SceneBuilder(map: currentLevelObjMap, isNextLevel: $isCompleted)
//                    .transition(.opacity)
//            } else {
//                RadialGradient(colors: [.purple, .indigo], center: .top, startRadius: 10, endRadius: 500)
//                    .ignoresSafeArea()
//                    .transition(.opacity)
//            }
//        }
//        .onAppear {
//            currentLevelObjMap = standartLevels[CurrentLevel - 1].map
//            showSceneBuilder = true
//        }
//        .onChange(of: isCompleted) { newValue in
//            if newValue {
//                if CurrentLevel < standartLevels.count {
//                    CurrentLevel += 1
//                    currentLevelObjMap = standartLevels[CurrentLevel - 1].map
//                    withAnimation {
//                        showSceneBuilder = false
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        withAnimation {
//                            showSceneBuilder = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    LevelsSwitch()
//}
