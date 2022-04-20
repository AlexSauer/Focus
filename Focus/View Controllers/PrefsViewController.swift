//
//  PrefsViewController.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var presetsPopup: NSPopUpButton!
    @IBOutlet weak var customLengthField: NSTextField!
    @IBOutlet weak var customSlider: NSSlider!
    @IBOutlet weak var breakField: NSTextField!
    @IBOutlet weak var breakSlider: NSSlider!
    @IBOutlet weak var tickAutomatic: NSButtonCell!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
    @IBAction func popupValueChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom"{
            customSlider.isEnabled = true
            return
        }
        
        let newTimerDuration = sender.selectedTag()
        customSlider.integerValue = newTimerDuration
        showSliderValueAsText()
        customSlider.isEnabled = false
    }
    
    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    
    @IBAction func breakSliderChanged(_ sender: Any) {
        showBreakSliderValueAsText()
    }
    
    @IBAction func tickAutomaticChanged(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    
    
    func showExistingPrefs() {
        // Pomodoro Time
        let selectedTimeinMinutes = Int(prefs.selectedTime) / 60
        
        presetsPopup.selectItem(withTitle: "Custom")
        customSlider.isEnabled = true
        
        for item in presetsPopup.itemArray {
            if item.tag == selectedTimeinMinutes {
                presetsPopup.select(item)
                customSlider.isEnabled = false
                break
            }
        }
        customSlider.integerValue = selectedTimeinMinutes
        showSliderValueAsText()
        
        // Break Time
        breakSlider.integerValue = Int(prefs.breakTime) / 60
        showBreakSliderValueAsText()
        
        // Automatic breaks
        tickAutomatic.state = prefs.automaticBreak ? NSControl.StateValue.on : NSControl.StateValue.off
        }
    
    func showSliderValueAsText() {
        let newTimerDuration = customSlider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        customLengthField.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
    func showBreakSliderValueAsText() {
        let curValue = breakSlider.integerValue
        let minutesDescription = (curValue == 1) ? "minute" : "minutes"
        breakField.stringValue = "\(curValue) \(minutesDescription)"
    }
    
    func saveNewPrefs() {
        prefs.selectedTime = Double(customSlider.integerValue) * 60
        prefs.breakTime = Double(breakSlider.integerValue) * 60
        prefs.automaticBreak = tickAutomatic.state == NSControl.StateValue.on
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"), object: nil)
    }
}




