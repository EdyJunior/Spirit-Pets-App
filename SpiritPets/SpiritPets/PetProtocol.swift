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
    
    var frontImage: UIImage { get set }
    var backImage: UIImage { get set }
    
    var type: PetType { get set }
    var name: String { get set }
    
    var number: Int! { get set }
    var stage: PetStage { get set }
    
    init(dict: [String: Any])
    
    func calculateAttributes()
}
