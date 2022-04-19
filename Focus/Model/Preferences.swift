//
//  Preferences.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Foundation

struct Preferences {
    var selectedTime: TimeInterval{
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            } else {
                return 25 * 60
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
}
