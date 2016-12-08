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

class LivingBeing: NSObject {
    
    var growthAtt: GrowthAttributes
    var languishDelegate: LanguishProtocol? = nil
    var disableDelegate: DisableButtonsProtocol? = nil
    
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
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LivingBeing.updateStatus), userInfo: nil, repeats: true)
    }

    func tryFeed(duration: Int) {

        if !isSleeping && !isExercising {
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
        
        self.growthAtt.fed += lunch
        if self.growthAtt.fed > 100 {
            self.growthAtt.fed = 100
        }
    }

    func trySleep() {
        
        if !isEating && !isExercising {
            self.isSleeping = true
            sleepTask = DispatchWorkItem(block: {
                self.wakeUp()
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: sleepTask)
        }
    }

    func wakeUp() {
        
        self.isSleeping = false
        sleepTask.cancel()
    }
    
    func tryExercise(typeOfExercise exer: Exercise) -> Int {

        if !isSleeping && self.growthAtt.stamina > exer.cost && !isEating {
            isExercising = true
            self.growthAtt.stamina -= exer.cost
            let task = DispatchWorkItem {
                self.isExercising = false
                print("descançou")
            }
            print("Exercitando por \(exer.cost / 2) segundos")
            let time = DispatchTimeInterval.seconds(exer.cost / 2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: task)
            return exer.gain
        }
        return 0
    }
    
    func updateStatus() {
        
        var starving = false
        var sleepy = false

        growthAtt.fed -= (isSleeping ? 1 : 3)
        growthAtt.awake -= (isSleeping ? -2 : 3)
        
        if growthAtt.fed < 25 {
            starving = true
            if growthAtt.fed < 0 {
                growthAtt.fed = 0
            }
        }
        if growthAtt.awake < 25 {
            sleepy = true
            if growthAtt.awake < 0 {
                growthAtt.awake = 0
            }
        } else if growthAtt.awake > 100 {
            growthAtt.awake = 100
        }
        if starving && sleepy {
            isLanguishing = true
        }
        print("fed = \(growthAtt.fed) e awake = \(growthAtt.awake)")
        
        NotificationCenter.default.post(name: Notification.Name("UpdateStatusNotification"), object: nil, userInfo: nil)
    }    
}
