//
//  LivingBeing.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 03/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class LivingBeing: NSObject {
    
    var growthAtt: GrowthAttributes
    var isSleeping = false

    init(fed: Int, awake: Int, stamina: Int) {
        
        self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
        
        super.init()
    }
    
    func fed(lunch: Int) {
        
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
}
