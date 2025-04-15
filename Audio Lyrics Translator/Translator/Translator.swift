//
//  Translator.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import Translation

enum Translator {
    static let configuration = TranslationSession.Configuration(source: .init(languageCode: .japanese), target: .init(languageCode: .chinese))
}
