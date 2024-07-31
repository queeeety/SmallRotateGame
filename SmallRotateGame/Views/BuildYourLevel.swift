import SwiftUI

struct BuildYourLevel: View {

   @State private var map = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0],
    ]
    
    @State private var elementsMap: [[LineObject]] = []
    @State var bgcolor = Color.purple
    @State var isCorrect = false
    @State var changePoint = [Int]()
    @State var isButtonPushed = false
    let screenWidth = Int(UIScreen.main.bounds.width-20)
    var body: some View {
        ZStack {
            LinearGradient(colors: [bgcolor, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Побудуй свій рівень")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding([.top, .bottom], 20)
                Spacer()
                ScrollView{
                    VStack(spacing: 0.2) {
                        ForEach(elementsMap.indices, id: \.self) { i in
                            HStack(spacing: 0) {
                                ForEach(elementsMap[i].indices, id: \.self) { j in
                                    SingleButton(currentobj: $elementsMap[i][j], isPuched: $isButtonPushed)
                                        .contextMenu {
                                            Button {
                                                changePoint = [i, j, 1]
                                            } label: {
                                                Text("Початок")
                                                Image("one")
                                            }
                                            Button {
                                                changePoint = [i, j, 2]
                                            } label: {
                                                Text("Пряма")
                                                Image("line")
                                            }
                                            Button {
                                                changePoint = [i, j, 3]
                                            } label: {
                                                Text("Кутик")
                                                Image("corner")
                                            }
                                            Button {
                                                changePoint = [i, j, 4]
                                            } label: {
                                                Text("Літера Т")
                                                Image("t")
                                            }
                                            Button {
                                                changePoint = [i, j, 5]
                                            } label: {
                                                Text("Хрест")
                                                Image("x")
                                            }
                                            Button(role:.destructive) {
                                                changePoint = [i, j, 0]
                                            } label: {
                                                Text("Нічого")
                                                Image("0")
                                            }
                                        }
                                        .aspectRatio(1, contentMode: .fit)

                                }
                            }
                        }
                    }
                    .frame(minWidth:CGFloat(screenWidth),maxWidth: CGFloat(screenWidth), idealHeight: CGFloat(75*map.count), alignment: .top)
                    .onChange(of: changePoint) {
                        UpdateMap(&elementsMap, changePoint: changePoint)
                    }
                    .onChange(of: isButtonPushed, {
                        checkCompleteness()
                    })
                    .onAppear {
                        self.elementsMap = generateElementsMap()
                    }
                } // мапа
                .padding([.leading, .trailing], 10)

                Spacer()
                
                HStack(spacing: 10){
                    Button{
                        if (map.count <= 10) {
                            for i in 0...map.count-1{
                                self.map[i].append(0)
                            }
                            self.elementsMap = generateElementsMap()
                            checkCompleteness()
                        }
                    } label: {
                        Circle()
                            .frame(maxWidth: 75)
                            .opacity(0.5)
                            .foregroundStyle(.background)
                            .overlay(Image(systemName: "increase.quotelevel").font(.largeTitle))
                    }
                    Button{
                        if (map[0].count <= 10) {
                            map.append(Array(repeating: 0, count: map[0].count))
                            self.elementsMap = generateElementsMap()
                            checkCompleteness()
                        }
                    } label: {
                        Circle()
                            .frame(maxWidth: 75)
                            .opacity(0.5)
                            .foregroundStyle(.background)
                            .overlay(Image(systemName: "increase.quotelevel").font(.largeTitle).rotationEffect(.degrees(90)))
                    }
                    //decreasing
                    Button{
                        if (map.count > 1){
                            map.removeLast()
                            self.elementsMap = generateElementsMap()
                            checkCompleteness()
                        }
                    } label: {
                        Circle()
                            .frame(maxWidth: 75)
                            .opacity(0.5)
                            .foregroundStyle(.background)
                            .overlay(Image(systemName: "decrease.quotelevel").font(.largeTitle).rotationEffect(.degrees(90)))
                            
                    }
                    
                    Button{
                        if (map[0].count > 1){
                            for i in 0...map.count-1{
                                self.map[i].removeLast()
                            }
                            self.elementsMap = generateElementsMap()
                            checkCompleteness()
                        }
                    } label: {
                        Circle()
                            .frame(maxWidth: 75)
                            .opacity(0.5)
                            .foregroundStyle(.background)
                            .overlay(Image(systemName: "decrease.quotelevel").font(.largeTitle))
                            
                    }
                    Spacer()
                    
                    
                    Button{
                        for i in 0...map.count-1{
                            for j in 0...map[i].count-1{
                                self.map[i][j] = 0
                            }
                        }
                        self.elementsMap = generateElementsMap()
                        checkCompleteness()
                    } label: {
                        Circle()
                            .frame(maxWidth: 75)
                            .opacity(0.5)
                            .foregroundStyle(.background)
                            .overlay(Image(systemName: "xmark").font(.largeTitle).foregroundStyle(Color.red))
                            
                    }
                }
                .padding([.trailing, .leading]) // actionButtons
                
                Button(){
                    saveLevel(Level(map: map, isSolved: false), to: "PlayerLevels")
                    } label:{
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white.opacity(0.5))
                            Text("Зберегти рівень")
                                .font(.title2)
                        }
                        .frame(height: 70)
                        .padding(10)
                    }
                    .disabled(!isCorrect)
                
            }//VStack
        }
    }
    
    func generateElementsMap() -> [[LineObject]] {
        map.map { row in
            row.map { cell in
                LineObject(number: cell, color: .white)
            }
        }
    }

    func checkCompleteness() {
        if elementsMap.allSatisfy({ $0.allSatisfy { $0.number == 0 } }) {
            // Perform actions if all elements are 0
            print("Zero elements")
        } else {
            print(">Zero elements")

            let isComplete = performCheckCompleteness(elements: elementsMap)
            print("Completeness check: \(isComplete)")
            self.isCorrect = isComplete
            withAnimation {
                self.bgcolor = isComplete ? .green : .purple
            }
        }
    }
    
    func UpdateMap(_ tempMap: inout [[LineObject]], changePoint: [Int]){
        guard changePoint.count == 3 else { return }
        let (i, j, newValue) = (changePoint[0], changePoint[1], changePoint[2])
        map[i][j] = newValue
        tempMap[i][j] = LineObject(number: newValue, color: .white)
    }
}

struct SingleButton: View {
    @Binding var currentobj: LineObject
    @Binding var isPuched: Bool
    var body: some View {
        LineObj(viewModel: currentobj){
            isPuched = isPuched == true ? false : true
        }
        .aspectRatio(1, contentMode: .fit)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .frame(maxWidth: 75, maxHeight: 75)

    }
}

#Preview{
    BuildYourLevel()
}



