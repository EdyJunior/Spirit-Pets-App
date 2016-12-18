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
                self.disableDelegate?.disableBySleeping()
            } else {
                self.disableDelegate?.enableBySleeping()
            }
        }
    }
    
    var isEating: Bool {
        didSet {
            if isEating {
                self.disableDelegate?.disableByFeeding()
            } else {
                self.disableDelegate?.enableByFeeding()
            }
        }
    }
    
    var isExercising: Bool {
        didSet {
            if isExercising {
                self.disableDelegate?.disableByExercising()
            } else {
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

    init(fed: Int, awake: Int, stamina: Int) {
        
        self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
        self.isLanguishing = false
        self.isSleeping = false
        self.isEating = false
        self.isExercising = false
        
        super.init()
    }
}
