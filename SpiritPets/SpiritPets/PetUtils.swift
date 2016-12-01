//
//  PetUtils.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 30/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation

enum PetType {
    case light
    case dark
}

struct BattleAttributes {
    
    var  hp: Int
    var atk: Int
    var dfs: Int
    var rdm: Int
    var  lv: Int
    var  xp: Int
}

struct GrowthAttributes {
    
    var fed: Int
    var awake: Int
    var stamina: Int
}
