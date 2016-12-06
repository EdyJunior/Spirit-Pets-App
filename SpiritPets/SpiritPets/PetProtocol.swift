//
//  Pet.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 30/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

protocol PetProtocol {
    
    var battleAtt: BattleAttributes { get set }
    var baseBattleAtt: BattleAttributes { get set }
    var historyOfAtt: [BattleAttributes] { get set }
    
    var frontImage: UIImage { get set }
    var backImage: UIImage { get set }
    
    var type: PetType { get set }
    var name: String { get set }
    
    init(name: String)
    
    func calculateAttributes()
    
    func calculateOffensivePower() -> Int
    
    func calculateDamageReceived(enemysOffensive offensive: Int) -> Int
    
    func add(toHp: Int, theValue value: Int) -> Int
}
