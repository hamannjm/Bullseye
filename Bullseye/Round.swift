//
//  Round.swift
//  Bullseye
//
//  Created by James Hamann on 6/6/20.
//  Copyright © 2020 James Hamann. All rights reserved.
//

import Foundation
import RxSwift

class GameRound {
    private var finished = false
    private var currentValue = 1
    private var _targetValue = 1
    private let maxValue = 100
    var targetValue: String {
        get {
            String(_targetValue)
        }
    }
    
    private let valueSubject = PublishSubject<Int>()
    var observeCurrentValue: Observable<Int> {
        get {
            valueSubject.asObservable()
        }
    }
    
    init() {
        _targetValue = Int.random(in: 1...100)
    }
    
    func beginEmittingValue() -> Observable<Int> {
        return Observable.create { observer in
            var increasing = true
            while !self.finished {
                sleep(1)
                if increasing {
                    self.currentValue += 1
                    if self.currentValue == 100 {
                        increasing = false
                    }
                } else {
                    self.currentValue -= 1
                    if self.currentValue == 1 {
                        increasing = true
                    }
                }
                observer.onNext(self.currentValue)
            }
            return Disposables.create {

            }
        }
    }
    
    func makeGuess() -> Int {
        finished = true
        valueSubject.onCompleted()
        return calculateScore()
    }
    
    private func calculateScore() -> Int {
        let difference = abs(_targetValue - currentValue)
        return maxValue - difference
    }
}
