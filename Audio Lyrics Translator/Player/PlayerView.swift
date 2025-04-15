//
//  PlayerView.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import SwiftUI
import AVFoundation

@Observable class PlayerViewModel {
    var currentPlayTime: TimeInterval = 0
    let musicUrl: URL
    
    @ObservationIgnored lazy var player: AVAudioPlayer = {
        var player: AVAudioPlayer?

        // Start accessing the security-scoped resource
        if musicUrl.startAccessingSecurityScopedResource() {
            defer { musicUrl.stopAccessingSecurityScopedResource() }
            do {
                player = try AVAudioPlayer(contentsOf: musicUrl)
                player?.prepareToPlay()
            } catch {
                print("Failed to initialize AVAudioPlayer:", error)
            }
        } else {
            print("Couldn't access security scoped resource.")
        }

        return player ?? AVAudioPlayer() // fallback
    }()
    
    init(musicUrl: URL) {
        self.musicUrl = musicUrl
    }
}

struct PlayerView: View {
    @State private var vm: PlayerViewModel
    
    var body: some View {
        VStack {
            Text("\(vm.musicUrl.lastPathComponent)")
            HStack {
                Button(action: {
                    if vm.player.isPlaying {
                        vm.player.pause()
                    } else {
                        vm.player.play()
                    }
                }) {
                    Text(vm.player.isPlaying ? "Pause" : "Play")
                }
                Slider(value: Binding(get: {
                    vm.currentPlayTime
                }, set: { newValue in
                    vm.currentPlayTime = newValue
                    vm.player.currentTime = newValue
                }), in: 0...vm.player.duration)
            }
        }
    }
    
    init(musicUrl: URL) {
        self.vm = PlayerViewModel(musicUrl: musicUrl)
    }
}

