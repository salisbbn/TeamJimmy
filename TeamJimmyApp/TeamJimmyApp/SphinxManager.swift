//
//  SphinxManager.swift
//  TeamJimmyApp
//
//  Created by Demetri Miller on 1/20/18.
//  Copyright © 2018 Brian Salisbury. All rights reserved.
//

import Foundation
import Sphinx
import TLSphinx

extension Notification.Name {
    enum Sphinx {
        static let didStartDecoding = Notification.Name("sphinxDidStartDecoding")
        static let didStopDecoding = Notification.Name("sphinxDidStopDecoding")
        static let hypothesisUpdate = Notification.Name(rawValue: "sphinxHypothesisUpdate")
    }

}

class SphinxManager {
    static let shared = SphinxManager()

    var ignoreDecoderInput = false {
        didSet {
            decoder.shouldIgnoreInput = ignoreDecoderInput
        }
    }
    private(set) var isDecoding: Bool = false
    private var decoder: TLSphinx.Decoder!

    init() {
        setupDecoder()
    }

    private func setupDecoder() {
        let sphinxBundle = Bundle(for: TLSphinx.Decoder.self)
        let modelPath = sphinxBundle.path(forResource: "en-us", ofType: nil)!
        let hmm = modelPath.appending("/en-us")
        let lm = modelPath.appending("/en-us.lm.dmp")
        let dict = modelPath.appending("/cmudict-en-us.dict")

        guard let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict)) else {
            fatalError("Can't run test without a valid config")
        }

        config.showDebugInfo = false
        decoder = Decoder(config: config)
    }

    // MARK: - Playback interface
    func start() {
        guard !isDecoding else { return }

        decoder.startDecodingSpeech { hypothesis in
            guard let hypothesis = hypothesis else { return }

            let text = "Utterance: \(hypothesis.text) -- score: \(hypothesis.score)"
            print(text)
            NotificationCenter.default.post(name: Notification.Name.Sphinx.hypothesisUpdate, object: hypothesis)
        }

        isDecoding = true
        NotificationCenter.default.post(name: Notification.Name.Sphinx.didStopDecoding, object: nil)
    }

    func stop() {
        guard isDecoding else { return }
        decoder.stopDecodingSpeech()

        isDecoding = false
        NotificationCenter.default.post(name: Notification.Name.Sphinx.didStopDecoding, object: nil)
    }
}
