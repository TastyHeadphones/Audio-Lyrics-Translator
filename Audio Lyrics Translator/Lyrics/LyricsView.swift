//
//  Lyrics.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import Speech
import SwiftUI

@Observable class LyricsViewModel {
    var currentPlayTime: TimeInterval = 0
    let musicUrl: URL
    
    var originalLyrics: SFTranscription?
    var translatedLyrics: SFTranscription?
    
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
        HStack {
            if let originalLyrics = vm.originalLyrics {
                List {
                    ForEach(originalLyrics.segments, id: \.self) { segment in
                        Text(segment.substring)
                    }
                }
            } else {
                Text("Loading original lyrics...")
            }
            if let translatedLyrics = vm.translatedLyrics {
                List {
                    ForEach(translatedLyrics.segments, id: \.self) { segment in
                        Text(segment.substring)
                    }
                }
            } else {
                Text("Loading translated lyrics...")
            }
        }
    }
    
    init(musicUrl: URL) {
        self.vm = LyricsViewModel(musicUrl: musicUrl)
    }
}
