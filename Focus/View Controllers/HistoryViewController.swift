//
//  HistoryViewController.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Cocoa

class HistoryViewController: NSViewController {

    @IBOutlet weak var historyLabel: NSTextField!
    
    var history = PomodoroHistory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        displayHistory()
    }
    
    func displayHistory(){
        var finalText = ""
        for item in history.history {
            finalText += item.toString()
        }
        historyLabel.stringValue = finalText
    }
}
