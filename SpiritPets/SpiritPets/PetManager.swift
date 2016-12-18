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
        var add: Int?
    }
    
    var feedController = TimeController(interval: 0, timer: nil, add: nil)
    var exerciseController = TimeController(interval: 0, timer: nil, add: 0)
    var sleepController = TimeController(interval: 0, timer: nil, add: nil)
    
    var exercise = Exercise(cost: 0, gain: 0, time: 0)
    var cost: Int = 0
    
    private override init() {
        
        super.init()
        
        Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(PetManager.updateStatus), userInfo: nil, repeats: true)
    }
    
    func countingTimeEating() {
        
        feedController.interval -= 1
        petChoosed.growthAtt.fed! += 1
        print("eating = \(feedController.interval)")
        if feedController.interval < 1.0 || petChoosed.growthAtt.fed! > 99 {
            petChoosed.isEating = false
            feedController.timer!.invalidate()
            
            print("Parou de Comer")
        }
    }
    
    func feed(with lunch: Lunch) {
        
        if !petChoosed.isSleeping {
            petChoosed.isEating = true
            print("Comendo por \(lunch.time) segundos")
            
            feedController = TimeController(interval: lunch.time,
                                            timer: Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PetManager.countingTimeEating), userInfo: nil, repeats: true), add: nil)
        }
    }
    
    func countingTimeExercising() {
        
        exerciseController.interval -= 1
        if cost < exercise.cost {
            cost += 1
            petChoosed.growthAtt.stamina! -= 1
        }
        print("exercising = \(exerciseController.interval)")
        if exerciseController.interval < 1.0 {
            if exercise.cost > Int(exercise.time) {
                petChoosed.growthAtt.stamina! -= (exercise.cost - Int(exercise.time))
            }
            
            petChoosed.isExercising = false
            petChoosed.xpUp(xp: exerciseController.add!)
            exerciseController.timer!.invalidate()
            
            print("Parou de Treinar")
        }
    }
    
    func exercise(typeOfExercise exer: Exercise) {
        
        if !petChoosed.isSleeping {
            if petChoosed.growthAtt.stamina > exer.cost {
                exercise = exer
                petChoosed.isExercising = true
                cost = 0
                print("Exercitando por \(exer.time) segundos\n")
                
                exerciseController = TimeController(interval: exer.time,
                                                    timer: Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PetManager.countingTimeExercising), userInfo: nil, repeats: true), add: exer.gain)
            } else {
                petChoosed.careDelegate?.tirednessMessage()
            }
        }
    }

    func languishInstantaniously(basedOn time: TimeInterval) {

        for _ in 0...Int(time / updateInterval) {
            petChoosed.xpDown(xp: depletionRate)
        }
    }

    func updateStatus() {

        var starving = false
        var sleepy = false

        if !petChoosed.isEating {
            petChoosed.growthAtt.fed! -= (petChoosed.isSleeping ? hungerLowRate : hungerHighRate)
        }
        petChoosed.growthAtt.awake! += (petChoosed.isSleeping ? sleepnessUpRate : sleepnessDownRate)
        if !petChoosed.isExercising && !petChoosed.isLanguishing {
            petChoosed.growthAtt.stamina! += (petChoosed.isSleeping ? staminaHighRate : staminaLowRate)
        }
    
        if petChoosed.growthAtt.fed < hungerWarningValue {
            petChoosed.careDelegate?.hungerMessage()
            if petChoosed.growthAtt.fed < hungerDangerousValue {
                starving = true
            }
        } else if petChoosed.growthAtt.fed >= hungerWarningValue && petChoosed.growthAtt.fed <= 100 {
            petChoosed.careDelegate?.removeHunger()
        }

        if petChoosed.growthAtt.awake < sleepnessWarningValue {
            petChoosed.careDelegate?.sleepnessMessage()
            if petChoosed.growthAtt.awake < sleepnessDangerousValue {
                sleepy = true
            }
        } else if petChoosed.growthAtt.awake >= sleepnessWarningValue && petChoosed.growthAtt.awake <= 100 {
            petChoosed.careDelegate?.removeSleepness()
        }
        
        if petChoosed.growthAtt.stamina > staminaMinDecentValue {
            petChoosed.careDelegate?.removeTiredness()
        }
        if (starving && sleepy) || (petChoosed.growthAtt.awake < sleepnessMortalValue) || (petChoosed.growthAtt.fed < hungerMortalValue) {
            petChoosed.isLanguishing = true
        } else {
            petChoosed.isLanguishing = false
        }
        print("\(petChoosed.growthAtt)\n")
        
        NotificationCenter.default.post(name: Notification.Name("UpdateStatusNotification"), object: nil, userInfo: nil)
    }
}
