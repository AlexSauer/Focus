//
//  Pomodoro.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Foundation

struct Pomodoro {
    var startTime: Date?
    var endTime: Date
    var duration: TimeInterval
   
    init(_ timer: GeneralTimer){
        startTime = timer.startTime
        endTime = timer.stopTime ?? Date.now
        duration = timer.duration
    }
    
    init(start: Date?, end: Date, d: TimeInterval){
        startTime = start
        endTime = end
        duration = d
    }
    
    func toString() -> String {
        return "\(startTime!); \(endTime); \(Int(duration / 60))"
    }
}
