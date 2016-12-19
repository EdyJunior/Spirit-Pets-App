//
//  PetManager.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import WatchConnectivity

class PetManager: NSObject, WCSessionDelegate {

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
    var sleepTask = DispatchWorkItem { }

    private override init() {
        
        super.init()
        
        sleepTask = DispatchWorkItem(block: {
            self.wakeUp()
        })
        
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
    
    func countingTimeSleeping() {
        
        sleepController.interval -= 1
        print("sleeping = \(sleepController.interval)")
        if sleepController.interval < 1.0 {
            petChoosed.isSleeping = false
            wakeUp()
            sleepController.timer!.invalidate()
            print("Parou de Dormir")
        }
    }
    
    func sleep(during secondes: TimeInterval) {
        
        petChoosed.isSleeping = true
        print("Dormindo por \(secondes) segundos\n")
        
        sleepController = TimeController(interval: secondes,
                                            timer: Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PetManager.countingTimeSleeping), userInfo: nil, repeats: true), add: nil)
//        sleepTask = DispatchWorkItem(block: {
//            self.wakeUp()
//        })
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sleepInterval, execute: sleepTask)
    }
    
    func wakeUp() {
        
        petChoosed.isSleeping = false
        sleepTask.cancel()
    }

    func languishInstantaniously(basedOn time: TimeInterval) {

        for _ in 0..<Int(time / updateInterval) {
            petChoosed.xpDown(xp: depletionRate)
        }
    }
    
    func evolving() {
        
        
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
        
        send(message: buildMessage())
    }
    
    // MARK: instant message ULTRA TRETA - building iPhone message
    
    func buildMessage() -> [String : Any] {
        var message: [String : Any] = [:]
        
        let fed = petChoosed.growthAtt.fed
        let awake = petChoosed.growthAtt.awake
        let stamina = petChoosed.growthAtt.stamina
        let experience = petChoosed.battleAtt.xp
        let nextLevel = petChoosed.baseBattleAtt.xp * petChoosed.battleAtt.lv
        let level = petChoosed.battleAtt.lv
        
        message["fed"] = fed
        message["awake"] = awake
        message["stamina"] = stamina
        message["experience"] = experience
        message["nextLevel"] = nextLevel
        message["level"] = level
        
        return message
    }
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
        print("\nrecebendo iPhone\n\(data)\n")
        
        if data.keys.first == "command" {
            let cmd = data["command"] as! Int
            switch cmd {
            case 1:
                let lunch = Lunch(gain: 10, time: 10) //60
                PetManager.sharedInstance.feed(with: lunch)
            case 2:
                // sleep
                //PetManager.sharedInstance.sleep(with: )
                break
            case 3:
                let exercise = Exercise(cost: 30, gain: 30, time: 15) //3600
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            default:
                print("O debug tá bom demais!")
            }
        }
    }
    
    let session = WCSession.default()
    
    func startConnectivity() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func send(message: [String : Any]) {
        if session.isReachable {
            print("\nenviando iPhone\n")
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.uploadingChanges(message)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
}
