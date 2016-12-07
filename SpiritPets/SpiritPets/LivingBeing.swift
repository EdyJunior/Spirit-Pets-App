//
//  LivingBeing.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 03/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

protocol languishProtocol {
    func languish()
}

class LivingBeing: NSObject {
    
    var growthAtt: GrowthAttributes
    var isSleeping = false
    var delegate: languishProtocol? = nil
    var isLanguishing: Bool {
        didSet {
            if isLanguishing {
                self.delegate?.languish()
            }
        }
    }

    init(fed: Int, awake: Int, stamina: Int) {
        
        self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
        self.isLanguishing = false

        super.init()
        
        Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(LivingBeing.updateStatus), userInfo: nil, repeats: true)
    }
    
    func feed(lunch: Int) {
        
        self.growthAtt.fed += lunch
        if self.growthAtt.fed > 100 {
            self.growthAtt.fed = 100
        }
    }
    
    func sleep() {
        self.isSleeping = true
    }
    
    func wakeUp() {
        self.isSleeping = false
    }
    
    func exercise(doing: [Int]) -> Int {
        
        self.growthAtt.stamina -= doing[0]
        return doing[1]
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
    }    
}
