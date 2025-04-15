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
    }
}

struct LyricsView: View {
    @State private var vm: LyricsViewModel
        
    var body: some View {
        guard let originalLyrics = vm.originalLyrics, let translatedLyrics = vm.translatedLyrics else {
            return AnyView(Text("Loading..."))
        }
        return AnyView(HStack {
            List {
                ForEach(originalLyrics.segments, id: \.self) { segment in
                    Text(segment.substring)
                }
            }
            List {
                ForEach(translatedLyrics.segments, id: \.self) { segment in
                    Text(segment.substring)
                }
            }
        })
    }
    
    init(musicUrl: URL) {
        self.vm = LyricsViewModel(musicUrl: musicUrl)
    }
}
