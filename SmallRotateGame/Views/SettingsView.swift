//
//  SettingsView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 12.08.2024.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @EnvironmentObject var audioManager: AudioManager

    @Binding var isActive : Bool
    @State var musicVolume : Float = UserDefaults.standard.float(forKey: "BGVolume")
    @State var isBGVolumeEditing : Bool = false
    @State var isMuted : Bool = !UserDefaults.standard.bool(forKey: "isMusicPlaying")
    @State var isHapticOn : Bool = UserDefaults.standard.bool(forKey: "Haptic")
    @State var isMusicEffectsOn : Bool = UserDefaults.standard.bool(forKey: "MusicEffects")
    var volumeImageName: String {
        switch musicVolume {
        case 0:
            return "speaker.slash.fill"
        case 0..<0.3:
            return "speaker.wave.1.fill"
        case 0.3..<0.7:
            return "speaker.wave.2.fill"
        default:
            return "speaker.wave.3.fill"
        }
    }
    var body: some View {
        ZStack{            
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea(.all)
                .blur(radius: 10)
                .onTapGesture {
                    withAnimation{
                        isActive = false
                        triggerHapticFeedback()
                    }
                }

            VStack{
                Text(NSLocalizedString("Settings", comment: ""))
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
                
                Button{
                    isMuted.toggle()
                    UserDefaults.standard.set(!isMuted, forKey: "isMusicPlaying")
                    audioManager.isPlaying.toggle()
                    triggerHapticFeedback(ignoreRules: true)
                } label:{
                    Image(systemName: isMuted ? "speaker.slash.fill" : volumeImageName)
                        .font(.title)
                        .foregroundStyle(isBGVolumeEditing ? .purple : .white)
                        .padding(5)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: musicVolume)
                    
                } // Volume button
                .frame(width: 50, height: 50)
                withAnimation{
                    Slider(value: $musicVolume, in: 0...1, step:0.1, onEditingChanged: { editing in
                        withAnimation{
                            isBGVolumeEditing = editing
                            isMuted = false
                            audioManager.isPlaying = true
                        }
                    })// sounds on/off
                    .accentColor(isMuted ? .gray : .purple)
                    .padding([.leading,.trailing])
                } // slider
                .onChange(of: musicVolume, {
                    UserDefaults.standard.set(musicVolume != 0, forKey: "isMusicPlaying")
                    UserDefaults.standard.set(musicVolume, forKey: "BGVolume")
                    
                    audioManager.isPlaying = musicVolume != 0
                    audioManager.volume = musicVolume
                })
                HStack{
                    Button{
                        isHapticOn.toggle()
                        UserDefaults.standard.set(isHapticOn, forKey: "Haptic")
                        triggerHapticFeedback(ignoreRules: true)
                        
                    } label: {
                        HStack{
                            Image(systemName: "wave.3.backward")
                                .font(.title)
                                .foregroundStyle(isHapticOn ? .purple : .gray)
                            Image(systemName: "wave.3.forward")
                                .font(.title)
                                .foregroundStyle(isHapticOn ? .purple : .gray)
                        }
                    } // Haptic on/off
                    .frame(width: 50, height: 50)
                    .padding()
                    
                    Button {
                        isMusicEffectsOn.toggle()
                        UserDefaults.standard.set(isMusicEffectsOn, forKey: "MusicEffects")
                        if isMusicEffectsOn {
                            triggerHapticFeedback(ignoreRules: true)
                            AudioServicesPlaySystemSound(1128)
                        }
                        else {
                            AudioServicesPlaySystemSound(1129)

                        }
                    } label: {
                        Image(systemName: "music.note")
                            .foregroundStyle(isMusicEffectsOn ? .purple : .gray)
                            .font(.largeTitle)
                    }
                    .frame(width: 50, height: 50)
                    .padding()
                }
//                        Button("printAll"){
//                            print("Чи грає музика")
//                            print(UserDefaults.standard.bool(forKey: "isMusicPlaying"))
//                            print("Яка гучність")
//                            print(UserDefaults.standard.float(forKey: "BGVolume"))
//                            print("Який хаптік")
//                            print(UserDefaults.standard.bool(forKey: "Haptic"))
//                        }
                    }
                    .background(Color(red: 40/255, green: 0, blue: 70/255).opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding([.leading, .trailing])
                    .shadow(radius: 10)
                    
        }
    }
}


#Preview {
    @Previewable @State var isClose = false
    SettingsView(
        isActive: $isClose)
}
