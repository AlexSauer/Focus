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
   
    var pomodoroTimer = PomodoroTimer()
    var soundplayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layer?.backgroundColor = CGColor(red: 1.0, green: 1, blue: 0, alpha: 1.0)
        self.view.wantsLayer = true
        pomodoroTimer.delegate = self
    }
    
// Changing the view controller appearance to dark aqua solved the color problem
//    override func awakeFromNib() {
//
//        if self.view.layer != nil {
//            let color : CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
//            self.view.layer?.backgroundColor = color
//
//            let textcolor = NSColor.white
//            let buttonAttributes = [NSAttributedString.Key.foregroundColor: textcolor]
//            timeLeftField.textColor = textcolor
//            startButton.attributedTitle = NSAttributedString(
//                string: "Start", attributes: buttonAttributes)
//            stopButton.attributedTitle = NSAttributedString(
//                string: "Stop", attributes: buttonAttributes)
//            resetButton.attributedTitle = NSAttributedString(
//                string: "Reset", attributes: buttonAttributes)
//        }
//    }

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
            pomodoroTimer.duration = 25*60
            pomodoroTimer.startTimer()
        }
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        pomodoroTimer.stopTimer()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        pomodoroTimer.resetTimer()
        updateDisplay(for: 25*60)
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





