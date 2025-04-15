//
//  Recogizer.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import Speech

enum Recogizer {
    static func generateTranscript(musicUrl: URL) -> AsyncStream<SFTranscription> {
        AsyncStream { continuation in
            guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP")), recognizer.isAvailable else {
                continuation.finish()
                return
            }

            let request = SFSpeechURLRecognitionRequest(url: musicUrl)
            let task = recognizer.recognitionTask(with: request) { result, error in
                if let error = error {
                    print("Error recognizing speech: \(error)")
                    continuation.finish()
                } else if let result = result {
                    print("Transcription result: \(result.bestTranscription.formattedString)")
                    continuation.yield(result.bestTranscription)
                    if result.isFinal {
                        continuation.finish()
                    }
                }
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
