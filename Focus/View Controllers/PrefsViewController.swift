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
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func popupValueChanged(_ sender: Any) {
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
    @IBAction func okButtonClicked(_ sender: Any) {
    }
    
}
