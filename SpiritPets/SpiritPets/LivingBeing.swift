//
//  LivingBeing.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 03/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

protocol LanguishProtocol {
    func languish()
}

protocol DisableButtonsProtocol {
    
    func disableBySleeping()
    
    func enableBySleeping()
    
    func disableByFeeding()
    
    func enableByFeeding()
    
    func disableByExercising()
    
    func enableByExercising()
}

protocol TimeToTakeCareProtocol {
    
    var messages: Set <UIImage> {get set}
    
    func hungerMessage()
    
    func sleepnessMessage()
    
    func tirednessMessage()
    
    func removeHunger()
    
    func removeSleepness()
    
    func removeTiredness()
}

class LivingBeing: NSObject {
    
    var growthAtt: GrowthAttributes
    var languishDelegate: LanguishProtocol? = nil
    var disableDelegate: DisableButtonsProtocol? = nil
    var careDelegate: TimeToTakeCareProtocol? = nil
    
    var isSleeping: Bool {
        didSet {
            if isSleeping {
                print("Didiset dormiu")
                self.disableDelegate?.disableBySleeping()
            } else {
                print("Didiset acordou")
                self.disableDelegate?.enableBySleeping()
            }
        }
    }
    
    var isEating: Bool {
        didSet {
            if isEating {
                print("Didiset comendo")
                self.disableDelegate?.disableByFeeding()
            } else {
                print("Didiset parou de comer")
                self.disableDelegate?.enableByFeeding()
            }
        }
    }
    
    var isExercising: Bool {
        didSet {
            if isExercising {
                print("Didiset exercitando")
                self.disableDelegate?.disableByExercising()
            } else {
                print("Didiset descansou")
                self.disableDelegate?.enableByExercising()
            }
        }
    }
    
    var isLanguishing: Bool {
        didSet {
            if isLanguishing {
                self.languishDelegate?.languish()
            }
        }
    }
    var sleepTask = DispatchWorkItem { }

    init(fed: Int, awake: Int, stamina: Int) {
        
        self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
        self.isLanguishing = false
        self.isSleeping = false
        self.isEating = false
        self.isExercising = false
        
        super.init()
        
        sleepTask = DispatchWorkItem(block: {
            self.wakeUp()
        })
        
        Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(LivingBeing.updateStatus), userInfo: nil, repeats: true)
    }

    func tryFeed(duration: Int) {

        if !isSleeping {
            isEating = true
            print("Comendo por \(duration) segundos")
            
            let task = DispatchWorkItem {
                self.isEating = false
                print("Parou de Comer")
            }
            let time = DispatchTimeInterval.seconds(duration)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: task)
        }
    }
    
    func feedUp(lunch: Int) {
        
        self.growthAtt.fed = lunch + self.growthAtt.fed
        if self.growthAtt.fed > 100 {
            self.growthAtt.fed = 100
        } else if self.growthAtt.fed >= 50 {
            careDelegate?.removeHunger()
        }
    }

    func sleep() {
        
        self.isSleeping = true
        sleepTask = DispatchWorkItem(block: {
            self.wakeUp()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sleepInterval, execute: sleepTask)
    }

    func wakeUp() {
        
        self.isSleeping = false
        sleepTask.cancel()
    }
    
    func tryExercise(typeOfExercise exer: Exercise) -> Int {

        if !isSleeping {
            if self.growthAtt.stamina > exer.cost {
            isExercising = true
            let task = DispatchWorkItem {
                self.isExercising = false
                self.growthAtt.stamina = self.growthAtt.stamina - exer.cost
                print("descançou")
            }
            print("Exercitando por \(exer.time) segundos")
            let time = DispatchTimeInterval.seconds(5)//exer.time)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: task)
            return exer.gain
            } else {
                careDelegate?.tirednessMessage()
            }
        }
        return 0
    }
    
    func updateStatus() {

        var starving = false
        var sleepy = false
        
        growthAtt.fed = growthAtt.fed - (isSleeping ? 1 : 10)//2)
        growthAtt.awake = growthAtt.awake - (isSleeping ? -50/*-1*/ : 5)//1)
		growthAtt.stamina =  growthAtt.stamina - (isSleeping ? -4 : -2)
        
        if growthAtt.fed < 50 {
            careDelegate?.hungerMessage()
            if growthAtt.fed < 30 {
                starving = true
                if growthAtt.fed < 1 {
                    growthAtt.fed = 0
                }
            }
        } else {
            careDelegate?.removeHunger()
        }
        
        if growthAtt.awake < 50 {
            careDelegate?.sleepnessMessage()
            if growthAtt.awake < 30 {
                sleepy = true
                if growthAtt.awake < 1 {
                    growthAtt.awake = 0
                }
            }
        } else if growthAtt.awake >= 50 && growthAtt.awake <= 100 {
            careDelegate?.removeSleepness()
        } else {
            growthAtt.awake = 100
        }
        
        if growthAtt.stamina > 100 {
            growthAtt.stamina = 100
        } else if growthAtt.stamina > 10 {
            careDelegate?.removeTiredness()
        }
        if (starving && sleepy) || (growthAtt.awake < 10) || (growthAtt.fed < 10) {
            isLanguishing = true
        } else {
            isLanguishing = false
        }
        print("\(growthAtt)")

        NotificationCenter.default.post(name: Notification.Name("UpdateStatusNotification"), object: nil, userInfo: nil)
    }
}
