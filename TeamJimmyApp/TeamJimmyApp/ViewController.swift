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

    var decoder: TLSphinx.Decoder!

    override func viewDidLoad() {
        super.viewDidLoad()
        let sphinxBundle = Bundle(for: TLSphinx.Decoder.self)
        let modelPath = sphinxBundle.path(forResource: "en-us", ofType: nil)!
        let hmm = modelPath.appending("/en-us")
        let lm = modelPath.appending("/en-us.lm.dmp")
        let dict = modelPath.appending("/cmudict-en-us.dict")

        guard let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict)) else {
            fatalError("Can't run test without a valid config")
        }

        config.showDebugInfo = true

        self.decoder = Decoder(config: config)
    }

    @IBAction private dynamic func startRecording() {
        try! decoder.startDecodingSpeech {
            print("Utterance: \(($0?.text ?? "none"))")
        }
    }

    @IBAction private dynamic func stopRecording() {
        decoder.stopDecodingSpeech()
    }
}

