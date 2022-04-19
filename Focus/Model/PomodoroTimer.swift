//
//  PomodoroTimer.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Foundation


protocol PomodoroTimerProtocol {
    func timeReminingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: PomodoroTimer)
}


class PomodoroTimer {
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 25*60
    var elapsedTime: TimeInterval = 0
    
    var delegate: PomodoroTimerProtocol?
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    func timerAction(){
        guard let startTime = startTime else {
            return
        }
        elapsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = duration - elapsedTime
        
        if secondsRemaining <= 0 {
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeReminingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.timerAction()
        }
        timerAction()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.timerAction()
        }
        timerAction()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        
        timerAction()
    }
    
    func resetTimer(){
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        duration = 25*60
        elapsedTime = 0
        
        timerAction()
    }
}
