//
//  PetUtils.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 30/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation

//Types of pet. For now types won't influentiate the playability.
enum PetType: String {
    
    case light
    case dark
}

//Types of exercises. First value of array is the cost of stamina. Second value is the increase in the pet's experience
struct Exercise {
    
    let basicHP = [5, 5]
    let basicAtk = [5, 5]
    let basicDfs = [5, 5]
}

//Types of lunch. Each value is related to the increase in fed status of the pet
struct Lunch {
    
    let hamburguer = 20
    let soda = 10
    let steak = 40
}

//Variables related to battle
struct BattleAttributes {
    
    var  hp: Int
    var atk: Int
    var dfs: Int
    var rdm: UInt32
    var  lv: Int
    var  xp: Int
}

struct StateOfAttributes {
    
    var previous: BattleAttributes
    var current: BattleAttributes
}

//Variables related to growth
struct GrowthAttributes {
    
    var fed: Int
    var awake: Int
    var stamina: Int
}

let defaults = UserDefaults.standard
