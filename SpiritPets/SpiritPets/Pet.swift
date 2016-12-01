//
//  Pet.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 30/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

protocol Pet {
    
    var battleAtt: BattleAttributes { get set }
    var baseBattleAtr: BattleAttributes { get set }
    var growthAtt: GrowthAttributes { get set }
    var image: UIImage { get set }
    var type: PetType { get set }
    
    init(type: PetType)
    
    func calculateAttributes()
    
    func calculateOffensivePower() -> Int
    
    func calculateDamageReceived(enemysOffensive offensive: Int) -> Int
    
    func add(toHp: Int, theValue value: Int) -> Int
}
