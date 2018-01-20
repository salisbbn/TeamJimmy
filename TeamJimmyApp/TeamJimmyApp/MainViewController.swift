//
//  MainViewController.swift
//  TeamJimmyApp
//
//  Created by Demetri Miller on 1/20/18.
//  Copyright © 2018 Brian Salisbury. All rights reserved.
//

import Foundation
import TLSphinx
import UIKit


class MainViewController: UIViewController {
    @IBOutlet private weak var lastSpokenLabel: UILabel!
    private var lastHypothesisTimestamp: TimeInterval = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSpokenLabel.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(hypothesisUpdate(note:)), name: Notification.Name.Sphinx.hypothesisUpdate, object: nil)
    }

    @objc private dynamic func hypothesisUpdate(note: Notification) {
        guard let hypothesis = note.object as? Hypothesis else { return }

        lastHypothesisTimestamp = Date.timeIntervalSinceReferenceDate
        animateDisplayOfText(text: hypothesis.text, score: hypothesis.score, timestampValidator: lastHypothesisTimestamp)
    }

    private func animateDisplayOfText(text: String, score: Int, timestampValidator: TimeInterval) {
        lastSpokenLabel.text = ""

        var delay: Float = 0    // milliseconds
        for character in text {
            if timestampValidator != self.lastHypothesisTimestamp {
                break
            }

            let time = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay))
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.lastSpokenLabel.text = self.lastSpokenLabel.text?.appending(String(character))
            }

            delay += 50
        }
    }


}
