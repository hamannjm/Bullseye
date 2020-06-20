//
//  ViewController.swift
//  Bullseye
//
//  Created by James Hamann on 6/6/20.
//  Copyright © 2020 James Hamann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var roundState = GameRound()
    var disposables = DisposeBag()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var targeLabel: UILabel!
    
    var roundCount = 0
    var totalScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startNewRound()
    }
    
    private func startNewRound() {
        roundState = GameRound()
        observeRoundState(obs: roundState.beginEmittingValue())
        targeLabel.text = roundState.targetValue
        roundCount += 1
        roundLabel.text = String(roundCount)
    }
    
    private func observeRoundState(obs: Observable<Int>) {
        obs.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { (value: Int) -> Float in
                return Float.init(value) }
            .bind(to: slider.rx.value)
            .disposed(by: disposables)
    }
    
    @IBAction func newRound() {
        startNewRound()
    }
    
    @IBAction func guessMade() {
        let score = roundState.makeGuess()
        displayScore(roundScore: score)
        calculateNewTotal(roundScore: score)
    }
    
    private func displayScore(roundScore: Int) {
        let message = "You scored a \(roundScore)!"
        let alert = UIAlertController(title: "Score",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Woohoo!", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func calculateNewTotal(roundScore: Int) {
        totalScore += roundScore
        scoreLabel.text = String(totalScore)
    }
}

