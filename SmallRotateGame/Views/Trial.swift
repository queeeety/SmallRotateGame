////
////  Trial.swift
////  SmallRotateGame
////
////  Created by Тимофій Безверхий on 29.07.2024.
////
////
//import SwiftUI
//
//struct Trial: View {
//    var map = [[0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],
//               [0,0,0,0,0,0],]
//
//    @State private var elementsMap: [[LineObject]] = []
//
//    @State var bgcolor = Color.red
//    @State var isCorrect = false
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(colors: [bgcolor, Color.cyan], startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
//
//            VStack(spacing: 1) {
//                ForEach(elementsMap.indices, id: \.self) { i in
//                    HStack(spacing: 0) {
//                        ForEach(elementsMap[i].indices, id: \.self) { j in
//                            LineObj(viewModel: elementsMap[i][j]) {
//                                checkCompleteness()
//                            }
////                            .frame(width: 100, height: 100)
//                            .background(.ultraThinMaterial)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(0.1)
//                            .contextMenu{
//                                Button(action: {
//                                    map[i][j] = 1
//                                }, label: {
//                                    Text("one")
//                                })
//                            }
////                            .contextMenu{
////                                Button{
////                                    map[i][j] = 1
////                                    elementsMap[i][j]
////                                } label: {
////                                    Text("Початок")
////                                    Image("one")
////                                }
////                                Button{
////                                    map[i][j] = 2
////                                } label: {
////                                    Text("Пряма")
////                                    Image("line")
////                                }
////                            }
//
//                        }
//                    }
//                }
//            }
//            .frame(width: CGFloat(map[0].count * 50), height: CGFloat(map.count * 50))
//            .onAppear {
//                self.elementsMap = generateElementsMap()
//            }
//        }
//
//    }
//
//    func generateElementsMap() -> [[LineObject]] {
//        map.map { row in
//            row.map { cell in
//                LineObject(number: cell, color: .white)
//            }
//        }
//    }
//
//    func checkCompleteness() {
//        let isComplete = performCheckCompleteness(elements: elementsMap)
//        print("Completeness check: \(isComplete)")
//        self.isCorrect = isComplete
//        withAnimation{
//            self.bgcolor = isComplete ? .green : .red
//        }
//    }
//
//    func performCheckCompleteness(elements: [[LineObject]]) -> Bool {
//        let rows = elements.count
//        let cols = elements[0].count
//
//        let oppositeDirection: [String: String] = [
//            "up": "down",
//            "down": "up",
//            "left": "right",
//            "right": "left"
//        ]
//
//        for i in 0..<rows {
//            for j in 0..<cols {
//                let currentDirections = elements[i][j].directions
//                for direction in currentDirections {
//                    var hasNeighbor = false
//
//                    switch direction {
//                    case "up":
//                        if i > 0 {
//                            hasNeighbor = elements[i-1][j].directions.contains(oppositeDirection[direction]!)
//                        }
//                    case "down":
//                        if i < rows - 1 {
//                            hasNeighbor = elements[i+1][j].directions.contains(oppositeDirection[direction]!)
//                        }
//                    case "left":
//                        if j > 0 {
//                            hasNeighbor = elements[i][j-1].directions.contains(oppositeDirection[direction]!)
//                        }
//                    case "right":
//                        if j < cols - 1 {
//                            hasNeighbor = elements[i][j+1].directions.contains(oppositeDirection[direction]!)
//                        }
//                    default:
//                        break
//                    }
//
//                    if !hasNeighbor {
//                        print("Element at (\(i), \(j)) with direction \(direction) has no neighbor")
//                        return false
//                    }
//                }
//            }
//        }
//        return true
//    }
//}
//#Preview {
//    Trial()
//}
