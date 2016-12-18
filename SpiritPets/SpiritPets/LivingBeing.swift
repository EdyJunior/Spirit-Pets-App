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
                print("Didiset dormiu\n")
                self.disableDelegate?.disableBySleeping()
            } else {
                print("Didiset acordou\n")
                self.disableDelegate?.enableBySleeping()
            }
        }
    }
    
    var isEating: Bool {
        didSet {
            if isEating {
                print("Didiset comendo\n")
                self.disableDelegate?.disableByFeeding()
            } else {
                print("Didiset parou de comer\n")
                self.disableDelegate?.enableByFeeding()
            }
        }
    }
    
    var isExercising: Bool {
        didSet {
            if isExercising {
                print("Didiset exercitando\n")
                self.disableDelegate?.disableByExercising()
            } else {
                print("Didiset descansou\n")
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
}
