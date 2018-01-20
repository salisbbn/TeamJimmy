//
//  ViewController.swift
//  TeamJimmyApp
//
//  Created by Brian Salisbury on 1/19/18.
//  Copyright © 2018 Brian Salisbury. All rights reserved.
//

import UIKit
import TLSphinx
import Sphinx

class ViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!

    var decoder: TLSphinx.Decoder!

    override func viewDidLoad() {
        super.viewDidLoad()
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

        self.decoder = Decoder(config: config)
    }

    private func appendToTextView(text: String) {
        let currentText: String = textView.text.appending("\n")
        textView.text = currentText.appending(text)
    }

    @IBAction private dynamic func startRecording() {
        decoder.startDecodingSpeech { [weak self] hypothesis in
            guard let hypothesis = hypothesis else { return }

            let text = "Utterance: \(hypothesis.text) -- score: \(hypothesis.score)"
            self?.appendToTextView(text: text)
            print(text)
        }
    }

    @IBAction private dynamic func stopRecording() {
        decoder.stopDecodingSpeech()
    }
}

