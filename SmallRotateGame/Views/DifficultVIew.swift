import SwiftUI

struct DifficultView: View {

    @State var buttonStatus = [false, false, false, false, false]
    @State var whatButtonPressed: Int = 0
    
    @Binding var isActive : Bool
    @Binding var isGame : Bool
    let screenWidth = UIScreen.main.bounds.width
    let pictures = ["questionmark", "moon", "figure", "bolt.heart.fill", "crown.fill", "trophy"] // Переконайтесь, що тут вказані правильні назви іконок

    var body: some View {
        ZStack {
            RadialGradient(colors: [.purple, .indigo], center: .top, startRadius: 10, endRadius: 500)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack{
                    Button{
                        withAnimation{
                            isActive = false
                        }
                    }label:{
                        Image(systemName: "chevron.backward")
                            .font(.title)
                            .foregroundStyle(.white)
                            .bold()
                            .shadow(radius: 5)
                    }
                    Text(NSLocalizedString("ChooseDiff", comment:""))
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: pictures[whatButtonPressed])
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 100)
                    .transition(.opacity)
                
                Spacer()
                
                ForEach(1...2, id: \.self) { x in
                    HStack {
                        ForEach(1...2, id: \.self) { y in
                            let number = x == 1 ? x * y : x + y
                            
                            Button {
                                let lastMode = buttonStatus[number - 1]
                                buttonStatus = buttonStatus.map { _ in false }
                                buttonStatus[number - 1] = !lastMode
                                withAnimation {
                                    whatButtonPressed = lastMode ? 0 : number
                                }
                            } label: {
                                DifficultyButtonsLabel(isPressed: $buttonStatus[number - 1], difNumber: number)
                            }
                            .frame(width: screenWidth / 2 - 10, height: 100)
                        }
                    }
                }
                
                Button {
                    let lastMode = buttonStatus[4]
                    buttonStatus = buttonStatus.map { _ in false }
                    buttonStatus[4] = !lastMode
                    withAnimation {
                        whatButtonPressed = lastMode ? 0 : 5
                    }
                } label: {
                    DifficultyButtonsLabel(isPressed: $buttonStatus[4], difNumber: 5)
                }
                .frame(width: screenWidth / 2 - 10, height: 100)
                
                Spacer()
                
                Button (){
                    if whatButtonPressed != 0 {
                        withAnimation{
                            isGame.toggle()
                        }
                    }
                }label:{
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(RadialGradient(colors: whatButtonPressed != 0 ? [.purple] : [.purple.opacity(0.4)], center: .center, startRadius: 0, endRadius: 800))
                            .frame(width: .infinity, height: 100)
                        Text(NSLocalizedString("Play", comment:""))
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundColor((whatButtonPressed != 0) ? .white : .purple)
                    }
                }.padding([.leading, .trailing, .bottom], 5)
            }
            .onChange(of: isGame)
            {
                isActive = !isActive ? false : isActive
            }
            
            if isGame {
                SceneBuilder2(mode: 3, difficulty: whatButtonPressed, isActive: $isGame)
                    .transition(.opacity)
            }

            
            
        }
    }
}

#Preview {
    DifficultView(isActive: .constant(true), isGame: .constant(true))
}

struct DifficultyButtonsLabel: View {
    @Binding var isPressed: Bool
    var difNumber: Int
    let dictionaryLevels = [
        1: NSLocalizedString("VeryEasy", comment:""),
        2: NSLocalizedString("Easy", comment:""),
        3: NSLocalizedString("Medium", comment:""),
        4: NSLocalizedString("Hard", comment:""),
        5: NSLocalizedString("VeryHard", comment:"")
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(RadialGradient(colors: isPressed ? [.purple] : [.purple.opacity(0.4)], center: .center, startRadius: 0, endRadius: 800))
                .shadow(radius: isPressed ? 0 : 10)

            Text(dictionaryLevels[difNumber] ?? "")
                .foregroundStyle(.white)
                .font(.title2)
                .bold(isPressed)
        }
    }
}
