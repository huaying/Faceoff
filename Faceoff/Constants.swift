//
//  Constants.swift
//  BTtest
//
//  Created by Huaying Tsai on 11/14/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Character {
        static let MaxOfCandidateNumber = 3
    }
    
    struct MainScene {
        static let Background = "mainscene_backgound.jpg"
        static let Slot = "mainscene_slot.png"
        static let MainSlot = "mainscene_mainslotwithoutplus.png"
        static let StartButton = "mainscene_start_button.png"
        static let CharacterList = "mainscene_character_list.png"
        static let CharacterSelect = "mainscene_character_select.png"
        static let Plus = "mainscene_plus.png"
        static let DeleteButton = "mainscene_delete.png"
        
        static let SlotSize = 80.0
    }
    
    struct PlayModeScene {
        static let Background = "playermodescene_background" //Atlas
        static let BackButton = "playermodescene_back_button.png"
        static let StoryButton = "playermodescene_story_button.png"
        static let VersusButton = "playermodescene_versus_button.png"
    }
    
    struct CharacterManager {
        static let maxOfCandidateNumber = 3
    }
    
    struct GameScene {
        
        static let Character = "character"
        static let Fire = "fire"
        static let PoweredFire = "poweredfire"
        static let EnemyFire = "enemyfire"
        static let Enemy = "enemy"
        static let EnemyPoweredFire = "enemypoweredfire"
        
        struct Bitmask {
            static let SceneEdge: UInt32 = 0x1 << 0
            static let Character: UInt32 = 0x1 << 1
            static let Enemy: UInt32 = 0x1 << 2
            static let Fire: UInt32 = 0x1 << 3
            static let EnemyFire: UInt32 = 0x1 << 4
        }
    }
    
    struct Weapon {
        
        
        //For Select
        struct WeaponType {
            static let Bullet = "Missel"
            static let IceBullet = "Frozen"
            static let FireBullet = "Fire"
            static let MultiBullet = "Shotgun"
            static let BonusBullet = "DoubleBonus"
            static let Laser = "Ultimate"
            static let Invisibility = "Invisibility_Cloak"
            static let Heal = "Heal"
            static let Detect = "Detect"
        }
        
        //For Shooting
        struct WeaponImage {
            static let Bullet = "Missel"
            static let IceBullet = "Frozen"
            static let FireBullet = "Fire"
            static let MultiBullet = "Missel"
            static let BonusBullet = "DoubleBonus"
            static let Laser = "Ultimate"
            static let Invisibility = "Invisibility_Cloak"
            static let Heal = "Heal"
            static let Detect = "Detect"
        }
        
        static let Sets = [
            WeaponType.FireBullet,
            WeaponType.IceBullet,
            WeaponType.MultiBullet,
            WeaponType.Invisibility,
            WeaponType.Heal,
            WeaponType.Detect
        ]
        static let SetsDescription = [
            "Keeps opponent blame and deducts him 30 point",
            "Slow down opponent for 50%",
            "Shot 3 bullets every shot",
            "Let yourself invisible",
            "Add 20 points to yourself",
            "Find opponent even he has heal"
        ]
    }
    
}