//
//  SmallRotateGameApp.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 28.07.2024.
//

import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    @Published var isPlaying = UserDefaults.standard.bool(forKey: "isMusicPlaying"){
        didSet{
            if isPlaying{
                audioPlayer?.play()
            }
            else{
                audioPlayer?.pause()
            }
        }
    }
    @Published var volume: Float = UserDefaults.standard.float(forKey: "BGVolume") { // Діапазон від 0.0 до 1.0
        didSet {
            audioPlayer?.volume = volume
        }
    }

    init() {
        configureAudioSession()
        playMusic()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func playMusic() {
        guard let url = Bundle.main.url(forResource: "EndlessLoop", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Play indefinitely
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to initialize audio player: \(error)")
        }
    }
    func pause(){
        guard let player = audioPlayer else { return }
        player.pause()
        isPlaying = false
        UserDefaults.standard.set(true, forKey: "isMusicPlaying")
    }
    func play(){
        guard let player = audioPlayer else { return }
        player.play()
        isPlaying = true
        UserDefaults.standard.set(true, forKey: "isMusicPlaying")
    }
    func togglePlayPause() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
        UserDefaults.standard.set(isPlaying, forKey: "isMusicPlaying")

    }
}



@main
struct SmallRotateGameApp: App {
    @StateObject private var audioManager = AudioManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear{
                    checkFirstLaunch()
                }
                .environmentObject(audioManager)
        }
        
    }
}

func checkFirstLaunch() {
    let defaults = UserDefaults.standard
    if defaults.bool(forKey: "isFirstLaunch") == false {
        defaults.set(true, forKey: "isFirstLaunch")
        UserDefaults.standard.set(true, forKey: "isMusicPlaying")
        UserDefaults.standard.set(0.5, forKey: "BGVolume")
        UserDefaults.standard.set(true, forKey: "Haptic")
        UserDefaults.standard.set(1, forKey: "CurrentLevel")
        UserDefaults.standard.set(1, forKey: "PlayersLevel")
        UserDefaults.standard.set(true, forKey: "MusicEffects")
    }
}

public var CreatedLevels : [Level] = loadLevels(from: "PlayerLevels")
public var standartLevels : [Level] = loadLevelsFromFileDirectly()
public let preLoadedLevels = loadLevelsFromFileDirectly()
let startMap =  [[0, 0, 1, 1, 0, 0],
                [0, 0, 2, 2, 0, 0],
                [0, 0, 3, 5, 1, 0],
                [0, 0, 0, 2, 0, 0],
                [3, 3, 0, 4, 3, 0],
                [3, 3, 0, 1, 1, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]




extension AnyTransition {
    static var slideFromTop: AnyTransition {
        AnyTransition.move(edge: .top)
    }
    static var slideFromLeft: AnyTransition {
        AnyTransition.move(edge: .leading)
    }
    static var slideFromRight: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}

// Функція для створення тактильного зворотного зв'язку
func triggerHapticFeedback(ignoreRules: Bool = false) {
    let ifHapticOn = UserDefaults.standard.bool(forKey: "Haptic")
    if (ifHapticOn || ignoreRules){
        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactGenerator.impactOccurred()
    }
    
}

enum HapticTypes{
    case success
    case error
}

func triggerNotificationFeedback(mode: HapticTypes){
    let ifHapticOn = UserDefaults.standard.bool(forKey: "Haptic")
    if (ifHapticOn){
        let impactGenerator = UINotificationFeedbackGenerator()
        switch mode {
        case .success:
            impactGenerator.notificationOccurred(.success)
        case .error:
            impactGenerator.notificationOccurred(.error)
        }
    } 
}

