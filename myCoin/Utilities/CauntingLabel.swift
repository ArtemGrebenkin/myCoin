//
//  CauntingLabel.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/26/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//
import UIKit

class CauntingLabel: UILabel {
    
    var startNumber = 0
    var endNumber = 0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    var addStr = ""
    
    var timer: Timer?
    
    
    func count(fromValue: Int, to toValue: Int, withDuration duration: TimeInterval, addStr: String) {

        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        self.addStr = addStr

        invalidateTimer()
        
        if duration == 0 {
             self.text = addStr + String(toValue)
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CauntingLabel.updateValue), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate) //плюсуем timeInterval до duration
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        self.text = addStr + (currentCounterValue < 10 ? "0" + String(currentCounterValue) : String(currentCounterValue))
    }
    
    
    var currentCounterValue: Int {
        if progress >= duration {
            return endNumber
        }
        let percentage = progress / duration
        let outcome = percentage * Double(endNumber - startNumber)
        
        return startNumber + Int(outcome)
    }
    
   //func updateText(value: Int16) {
   //     //self.text = String(format: "%.2f", value)
   //     self.text = String(value)
    //}
    func updateCounter(counterValue: Double) -> Double {
        return counterValue
        //return powf(counterValue, 3.0)
        //return 1 - (1 - counterValue, 3)
    }
    
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
   
    
    
}
