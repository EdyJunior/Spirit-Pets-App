//
//  PetChoosed.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 02/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetChoosed: NSObject, Pet {

    var battleAtt: BattleAttributes
    var baseBattleAtr = BattleAttributes(hp: 10, atk: 8, dfs: 4, rdm: 5, lv: 0, xp: 0)
    var growthAtt: GrowthAttributes
    
    var image: UIImage
    var type: PetType
    
    required init(type: PetType) {
        
        self.type = type
        self.image = #imageLiteral(resourceName: "Parlepus")
        
        self.battleAtt = BattleAttributes(hp: baseBattleAtr.hp  + Int(1 + arc4random_uniform(UInt32(baseBattleAtr.rdm * baseBattleAtr.rdm))),
                                          atk: baseBattleAtr.atk + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
                                          dfs: baseBattleAtr.dfs + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
                                          rdm: baseBattleAtr.rdm,
                                          lv: 1,
                                          xp: 0)
        self.growthAtt = GrowthAttributes(fed: 100, awake: 100, stamina: 100)
        
        super.init()
        
        //calculateAttributes()
    }
    
    func calculateAttributes() {
        
        self.battleAtt = BattleAttributes(hp: baseBattleAtr.hp  + Int(1 + arc4random_uniform(UInt32(baseBattleAtr.rdm * baseBattleAtr.rdm))),
                                          atk: baseBattleAtr.atk + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
                                          dfs: baseBattleAtr.dfs + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
                                          rdm: baseBattleAtr.rdm,
                                          lv: 1,
                                          xp: 0)
        self.growthAtt = GrowthAttributes(fed: 100, awake: 100, stamina: 100)
    }
    
    func calculateOffensivePower() -> Int {
        return (battleAtt.atk + 2 * battleAtt.rdm)
    }
    
    func calculateDamageReceived(enemysOffensive offensive: Int) -> Int {
        
        let dano = (offensive - (battleAtt.dfs + 2 * battleAtt.rdm))
        return dano > 0 ? dano : 1
    }
    
    func add(toHp: Int, theValue value: Int) -> Int {
        
        var hp = toHp + value
        if hp < 0 {
            hp = 0
        } else if hp > battleAtt.hp {
            hp = battleAtt.hp
        }
        return hp
    }
    
    func lvlUp() {
        
    }
    
    func fed() {
        
    }
    
    func sleep() {
        
    }
    
    func wakeUp() {
        
    }
    
    func excercise() {
        
    }
}
