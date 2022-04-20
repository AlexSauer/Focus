//
//  GeneralTimer.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Foundation


protocol GeneralTimerProtocol {
    func timeReminingOnTimer(_ timer: GeneralTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: GeneralTimer)
}

enum Mode{
    case pomodoro
    case pause
}


class GeneralTimer {
    var timer: Timer? = nil
    var startTime: Date?
    var stopTime: Date?
    var duration: TimeInterval = 25*60
    var elapsedTime: TimeInterval = 0
    var mode: Mode = Mode.pomodoro
    var durationBreak: TimeInterval = 5 * 60
    
    var delegate: GeneralTimerProtocol?
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    func getDuration() -> TimeInterval {
        switch mode {
        case .pomodoro:
            return duration
        case .pause:
            return durationBreak
        }
    }
    
    func changeMode() -> Void {
        switch mode {
        case .pomodoro:
            mode = .pause
        case .pause:
            mode = .pomodoro
        }
    }
    
    
    func timerAction(){
        guard let startTime = startTime else {
            return
        }
        
        var secondsRemaining = getDuration() + startTime.timeIntervalSinceNow   // Seconds reamining is duration - elapsedTime
        if secondsRemaining <= 0 {
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeReminingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        stopTime = nil
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
        stopTime = Date.now
        timer?.invalidate()
        timer = nil
        
        timerAction()
    }
    
    func resetTimer(){
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        stopTime = nil
        elapsedTime = 0
        
        timerAction()
    }
}
