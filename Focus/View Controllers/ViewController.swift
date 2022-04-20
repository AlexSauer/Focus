//
//  ViewController.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var historyButton: NSButton!
    
    var pomodoroTimer = PomodoroTimer()
    var soundplayer: AVAudioPlayer?
    var prefs = Preferences()
    var history = PomodoroHistory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        pomodoroTimer.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - Buttons
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if pomodoroTimer.isPaused {
            pomodoroTimer.resumeTimer()
        } else {
            pomodoroTimer.duration = prefs.selectedTime
            pomodoroTimer.startTimer()
        }
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        pomodoroTimer.stopTimer()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        history.append(Pomodoro(pomodoroTimer))
        pomodoroTimer.resetTimer()
        updateDisplay(for: prefs.selectedTime)
    }
    
    @IBAction func historyButtonClicked(_ sender: Any) {
    }
    
}


// MARK: - PomodoroTimerProtocol

extension ViewController: PomodoroTimerProtocol {
    func timeReminingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: PomodoroTimer) {
        updateDisplay(for: 0)
        playSound()
        resetButtonClicked(self)
    }
}

// MARK: - Display

extension ViewController{
    
    func updateDisplay(for timeRemaining: TimeInterval){
        timeLeftField.stringValue = textToDisplay(timeRemaining)
    }
    
    private func textToDisplay(_ time: TimeInterval) -> String{
        if time == 0{
            return "Done!"
        }
        
        let minutes = floor(time / 60)
        let seconds = time - 60 * minutes
        let secondsDisplay = String(format: "%02d", Int(seconds))
        let timeRemainingDisplay = "\(Int(minutes)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
        
}

// MARK: - Audio

extension ViewController {
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            return
            
        }
        do {
            soundplayer = try AVAudioPlayer(contentsOf: audioFileUrl)
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundplayer?.play()
    }
}

// MARK: - Preferences

extension ViewController {
    func setupPrefs() {
        updateDisplay(for: prefs.selectedTime)
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) {
            (notification) in
            self.updateFromPrefs()
        }
    }
    
    func updateFromPrefs() {
        self.pomodoroTimer.duration = self.prefs.selectedTime
        self.resetButtonClicked(self)
    }
}
