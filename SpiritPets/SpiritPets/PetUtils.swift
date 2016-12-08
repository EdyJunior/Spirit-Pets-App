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

//Stages of the evolution of pets. chibi is the first one and monster is the most advanced
enum PetStage: String {
    
    case chibi
    case kid
    case big
    case monster
}

//Cost is the cost of stamina. Gain is the increase in the pet's experience
struct Exercise {
    
    let cost: Int
    let gain: Int
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
