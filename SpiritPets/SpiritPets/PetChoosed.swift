//
//  PetChoosed.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 02/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetChoosed: LivingBeing, Pet {

    var battleAtt: BattleAttributes
    var baseBattleAtr: BattleAttributes
    
    var frontImage: UIImage
    var backImage: UIImage
    
    var type: PetType
    var name: String
    
    required init(name: String) {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "PetsAttributes", ofType: "json")
            else { fatalError("Can't find PetsAttributes JSON resource.") }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : Any]]
        
        let pet = json.filter { (petJson) -> Bool in
            if let petName = petJson["name"] as? String {
                if petName == name {
                    return true
                }
            }
            return false
        }
        
        let choosed = pet.first!
        self.name = name
        self.baseBattleAtr = choosed["baseBattleAtr"] as! BattleAttributes
        self.type = typeDict[choosed["type"] as! String]!
        self.frontImage = UIImage(named: choosed["frontImage"] as! String)!
        self.backImage = UIImage(named: choosed["backImage"] as! String)!
        
        self.battleAtt = BattleAttributes(value: 0)
        
        super.init(fed: 100, awake: 100, stamina: 100)

        calculateAttributes()
        print("pet = \(self)")
    }
    
    func calculateAttributes() {
        
//        self.battleAtt = BattleAttributes(hp: baseBattleAtr.hp  + Int(1 + arc4random_uniform(UInt32(baseBattleAtr.rdm * baseBattleAtr.rdm))),
//                                          atk: baseBattleAtr.atk + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
//                                          dfs: baseBattleAtr.dfs + Int(arc4random_uniform(UInt32(baseBattleAtr.rdm))),
//                                          rdm: baseBattleAtr.rdm,
//                                          lv: 1,
//                                          xp: 0)
//        self.growthAtt = GrowthAttributes(fed: 100, awake: 100, stamina: 100)
    }
    
    func calculateOffensivePower() -> Int {
        return (battleAtt.atk + 2 * Int(battleAtt.rdm))
    }
    
    func calculateDamageReceived(enemysOffensive offensive: Int) -> Int {
        
        let dano = (offensive - (battleAtt.dfs + 2 * Int(battleAtt.rdm)))
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
        
        self.battleAtt.lv += 1
        self.battleAtt.atk += self.baseBattleAtr.atk + Int(arc4random_uniform(self.baseBattleAtr.rdm) / 2)
    }
    
    func xpUp(xp: Int) {
        
    }
}

extension UInt32 {
    
    mutating func sqr() -> UInt32 {
        return self * self
    }
}
