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
    
    func disable()
    
    func enable()
}

class LivingBeing: NSObject {
    
    var growthAtt: GrowthAttributes
    var isEating = false
    var isExercising = false
    var languishDelegate: LanguishProtocol? = nil
    var disableDelegate: DisableButtonsProtocol? = nil
    
    var isSleeping: Bool {
        didSet {
            if isSleeping {
                print("Didiset dormiu")
                self.disableDelegate?.disable()
            } else {
                print("Didiset acordou")
                self.disableDelegate?.enable()
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
        
        super.init()
        
        sleepTask = DispatchWorkItem(block: {
            self.wakeUp()
        })
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LivingBeing.updateStatus), userInfo: nil, repeats: true)
    }

    func feed(lunch: Int) {

        if !isSleeping && !isEating && !isExercising {
            isEating = true
            self.growthAtt.fed += lunch
            if self.growthAtt.fed > 100 {
                self.growthAtt.fed = 100
            }
            let task = DispatchWorkItem { self.isEating = false }
            let time = DispatchTimeInterval.seconds(lunch / 2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: task)
            //Timer.scheduledTimer(timeInterval: TimeInterval(lunch / 2), target: self, selector: #selector(LivingBeing.stopFeeding), userInfo: nil, repeats: false)
        }
    }

//    @objc private func stopFeeding() {
//        isEating = false
//    }
    
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
    
    func exercise(typeOfExercise exer: Exercise) -> Int {

        if !isSleeping && self.growthAtt.stamina > exer.cost && !isEating {
            isExercising = true
            self.growthAtt.stamina -= exer.cost
            let task = DispatchWorkItem { self.isExercising = false }
            let time = DispatchTimeInterval.seconds(exer.gain / 2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: task)
            //Timer.scheduledTimer(timeInterval: TimeInterval(exer.gain / 2), target: self, selector: #selector(LivingBeing.rest), userInfo: nil, repeats: false)
            return exer.gain
        }
        return -1
    }
    
//    @objc private func rest() {
//        isExercising = false
//    }

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
    }    
}

/* S
 
 let task = DispatchWorkItem { print("do something") }
 
 // execute task in 2 seconds
 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: task)
 
 // optional: cancel task
 task.cancel()
 
 */
