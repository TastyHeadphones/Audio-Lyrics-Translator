//
//  Lyrics.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import Translation
import Speech
import SwiftUI

@Observable class LyricsViewModel {
    var currentPlayTime: TimeInterval = 0
    let musicUrl: URL
    
    var originalLyrics: SFTranscription?
    var translatedLyricsDict : [String: String] = [:]
    
    init(musicUrl: URL) {
        self.musicUrl = musicUrl
        Task {
            for await transcript in Recogizer.generateTranscript(musicUrl: musicUrl) {
                await MainActor.run {
                    self.originalLyrics = transcript
                }
            }
        }
    }
}

struct LyricsView: View {
    @State private var vm: LyricsViewModel
    
    var body: some View {
        List {
            if let originalLyrics = vm.originalLyrics {
                ForEach(originalLyrics.segments, id: \.self) { segment in
                    HStack {
                        Text(segment.substring)
                            .translationTask(Translator.configuration) { session in
                                if vm.translatedLyricsDict[segment.substring] != nil { return }
                                do {
                                    let translatedText = try await session.translate(segment.substring).targetText
                                    vm.translatedLyricsDict[segment.substring] = translatedText
                                } catch {
                                    print("Error translate speech: \(error)")
                                }
                            }
                        Spacer()
                        Text(vm.translatedLyricsDict[segment.substring] ?? "No")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    init(musicUrl: URL) {
        self.vm = LyricsViewModel(musicUrl: musicUrl)
    }
}
