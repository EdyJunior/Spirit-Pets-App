//
//  PetManager.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
 
class PetManager: NSObject {

    static let sharedInstance = PetManager()
    
    var petChoosed: PetChoosed!
    var historyOfAtt: [BattleAttributes] = []
    
    struct TimeController {
        
        var interval: TimeInterval
        var timer: Timer?
    }
    
    var feedController = TimeController(interval: 0, timer: nil)
    var exerciseController = TimeController(interval: 0, timer: nil)
    var sleepController = TimeController(interval: 0, timer: nil)
    
    private override init() {
        
        super.init()
        
        Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(PetManager.updateStatus), userInfo: nil, repeats: true)
    }
    
    func decreaseTimeEating() {
        
        feedController.interval -= 1
        print("eating = \(feedController.interval)")
        if feedController.interval < 1 {
            feedController.timer?.invalidate()
            petChoosed.isEating = false
            print("Parou de Comer")
        }
    }
    
    func feed(with lunch: Lunch) {
        
        if !petChoosed.isSleeping {
            petChoosed.isEating = true
            print("Comendo por \(lunch.time) segundos")
            feedController.interval = lunch.time
            feedController.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PetManager.decreaseTimeEating), userInfo: nil, repeats: true)
        }
    }
    
    func updateStatus() {
        
        var starving = false
        var sleepy = false
        
        petChoosed.growthAtt.fed = petChoosed.growthAtt.fed - (petChoosed.isSleeping ? hungerLowRate : hungerHighRate)
        petChoosed.growthAtt.awake = petChoosed.growthAtt.awake + (petChoosed.isSleeping ? sleepnessUpRate : sleepnessDownRate)
        petChoosed.growthAtt.stamina =  petChoosed.growthAtt.stamina + (petChoosed.isSleeping ? staminaHighRate : staminaLowRate)
        
        if petChoosed.growthAtt.fed < hungerWarningValue {
            petChoosed.careDelegate?.hungerMessage()
            if petChoosed.growthAtt.fed < hungerDangerousValue {
                starving = true
                if petChoosed.growthAtt.fed < 1 {
                    petChoosed.growthAtt.fed = 0
                }
            }
        } else {
            petChoosed.careDelegate?.removeHunger()
        }

        if petChoosed.growthAtt.awake < sleepnessWarningValue {
            petChoosed.careDelegate?.sleepnessMessage()
            if petChoosed.growthAtt.awake < sleepnessDangerousValue {
                sleepy = true
                if petChoosed.growthAtt.awake < 1 {
                    petChoosed.growthAtt.awake = 0
                }
            }
        } else if petChoosed.growthAtt.awake >= sleepnessWarningValue && petChoosed.growthAtt.awake <= 100 {
            petChoosed.careDelegate?.removeSleepness()
        } else {
            petChoosed.growthAtt.awake = 100
        }
        
        if petChoosed.growthAtt.stamina > 100 {
            petChoosed.growthAtt.stamina = 100
        } else if petChoosed.growthAtt.stamina > staminaMinDecentValue {
            petChoosed.careDelegate?.removeTiredness()
        }
        if (starving && sleepy) || (petChoosed.growthAtt.awake < sleepnessMortalValue) || (petChoosed.growthAtt.fed < hungerMortalValue) {
            petChoosed.isLanguishing = true
        } else {
            petChoosed.isLanguishing = false
        }
        print("\(petChoosed.growthAtt)")
        
        NotificationCenter.default.post(name: Notification.Name("UpdateStatusNotification"), object: nil, userInfo: nil)
    }
}
