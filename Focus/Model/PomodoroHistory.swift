//
//  PomodoroHistory.swift
//  Focus
//
//  Created by Alexander Sauer on 19/04/2022.
//

import Foundation

class PomodoroHistory {
    
    let historyFileName = "history.csv"
    var history: [Pomodoro] = []
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ" // "yyyy-MM-dd HH:mm:ss"
        history = loadHistory()
        
    }
    
    func append(_ item: Pomodoro) {
        if item.startTime == nil{
            return
        }
        history.append(item)
        
        // Add the new entry to the csv file
        if history.count == 1 {
            saveEntireHistory()
        } else {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(historyFileName)
                do {
                    if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                        try fileHandle.seekToEnd()
                        guard let data = (item.toString() + "\n").data(using: String.Encoding.utf8) else { return }
                        fileHandle.write(data)
                        try fileHandle.close()
                    }
                }
                catch {print("Error occured while appending to the csv history file: \(error)")}
            } else {
                print("Append to csv failed!")
            }
        }
    }
    
    func mostRecent() -> Pomodoro? {
        if history.count > 0{
            return history.last!
        } else {
            return nil
        }
    }
    
    
    func historyToString() -> String {
        var finalString = ""
        for entry in history {
            finalString += (entry.toString() + "\n")
        }
        return finalString
    }
    
    func saveEntireHistory() {
        let historyString = historyToString()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(historyFileName)
            do {
                try historyString.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {print("Error occured! \(error)")}
        }
    }
    
    func loadHistory() -> [Pomodoro] {
        var historyString: String = ""
        var updated_history: [Pomodoro] = []
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(historyFileName)
            do {
                historyString = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch{
                print("File could not be read! \(error)")
            }
        }
        
        if historyString.isEmpty {
            return []
        }
        
        let entryStrings = historyString.split(whereSeparator: \.isNewline)
        for entry in entryStrings {
            var atts = entry.components(separatedBy: ";")
            for i in 0..<atts.count {
                atts[i] = atts[i].trimmingCharacters(in: .whitespaces)
            }
            let cur_pomodoro = Pomodoro(start: dateFormatter.date(from:atts[0])!,
                                        end: dateFormatter.date(from:atts[1])!,
                                        d: Double(atts[2])! )
            updated_history.append(cur_pomodoro)
        }
        return updated_history
    }
    
}
