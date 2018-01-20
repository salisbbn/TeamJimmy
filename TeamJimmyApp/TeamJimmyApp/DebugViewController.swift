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

class DebugViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!

    var decoder: TLSphinx.Decoder!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(hypothesisUpdate(note:)), name: Notification.Name.Sphinx.hypothesisUpdate, object: nil)
    }

    @objc private dynamic func hypothesisUpdate(note: Notification) {
        guard let hypothesis = note.object as? Hypothesis else { return }

        let text = "Utterance: \(hypothesis.text) -- score: \(hypothesis.score)"
        appendToTextView(text: text)
    }

    private func appendToTextView(text: String) {
        let currentText: String = textView.text.appending("\n")
        textView.text = currentText.appending(text)
    }

    @IBAction private dynamic func startRecording() {
        SphinxManager.shared.start()
    }

    @IBAction private dynamic func stopRecording() {
        SphinxManager.shared.stop()
    }
}

