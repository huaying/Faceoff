//
//  Constants.swift
//  BTtest
//
//  Created by Huaying Tsai on 11/14/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import CoreGraphics

struct Constants {
    
    static let Font = "Copperplate"
    
    struct Audio {
        static let TransButton = "button.wav"
        static let CameraButton = "button.wav"
        static let SelectWeaponButton = "button.wav"
        static let WeaponSwift = "button.wav"
        static let WeaponEnlarge = "button.wav"
        static let SelectOpponent = "button.wav"
        static let Preparebackground = "button.wav"
        static let GameBackground = "button.wav"
        
        static let SelecWeaponInGame = "button.wav"
        static let Help = "button.wav"
        
        static let BulletFire = "button.wav"
        static let IceBulletFire = "button.wav"
        static let FireBulletFire = "button.wav"
        static let MultiBulletFire = "button.wav"
        static let BonusBulletFire = "button.wav"
        static let LaserFire = "button.wav"
        static let InvisibilityFire = "button.wav"
        static let HealFire = "button.wav"
        static let DetectFire = "button.wav"
        static let ArmorFire = "button.wav"
        
        static let BulletFireFromEnemy = "button.wav"
        static let IceBulletFireFromEnemy = "button.wav"
        static let FireBulletFireFromEnemy = "button.wav"
        static let MultiBulletFireFromEnemy = "button.wav"
        static let BonusBulletFireFromEnemy = "button.wav"
        static let LaserFireFromEnemy = "button.wav"
        static let InvisibilityFireFromEnemy = "button.wav"
        static let HealFireFromEnemy = "button.wav"
        static let DetectFireFromEnemy = "button.wav"
        static let ArmorFireFromEnemy = "button.wav"
    }
    
    
    
    
    struct Character {
        static let MaxOfCandidateNumber = 3
    }
    
    struct Scene {
        static let BackButtonSizeWidth = 184.0
        static let BackButtonSizeHeight = 57.0
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
    
    struct CameraScene {
        static let Interface = "camerascene_interface_test.png"
        static let Button = "camerascene_button.png"
        static let BackButton = "camerascene_back_button.png"
    }
    
    struct PlayModeScene {
        static let Background = "playermodescene_background" //Atlas
        static let BackButton = "playermodescene_back_button.png"
        static let StoryButton = "playermodescene_story_button.png"
        static let VersusButton = "playermodescene_versus_button.png"
    }
    struct BuildConnectionScene {
        static let Background = "buildconnectionscene_background.jpg"
        static let PlayerList = "buildconnectionscene_player_list.png"
        static let BackButton = "buildconnectionscene_back_button.png"
    }
    
    struct SelectWeaponScene {
        static let Background = "selectweaponscene_background.jpg"
        static let WeaponSelect = "selectweaponscene_weapon_select.png"
        static let LeftButton = "selectweaponscene_left_button.png"
        static let RightButton = "selectweaponscene_right_button.png"
        static let CenterBlock = "selectweaponscene_center_block.png"
        static let Slot = "selectweaponscene_slot.png"
        static let centerBlockZ = -5
    }
    
    struct CharacterManager {
        static let maxOfCandidateNumber = 3
    }
    
    struct GameScene {
        
        static let Background = "gamescene_background.jpg"
        static let StatusBar = "gamescene_status.png"
        static let Hp = "gamescene_hp.png"
        static let Mp = "gamescene_mp.png"
        static let HpBar = "gamescene_hp_bar.png"
        static let MpBar = "gamescene_mp_bar.png"
        static let MpLast = "gamescene_mp_last.png"
        static let WeaponSlot = "gamescene_weapon_slot.png"
        static let EnemySlot = "gamescene_enemy_slot.png"
        static let EnemyMark = "gamescene_enemy_mark.png"
        
        
        static let Velocity = 500.0
        static let SelfStatusPanel = "SelfStatusPanel"
        static let EnemyStatusPanel = "EnemyStatusPanel"
        
        //about contact detection
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
            static let pauseMask: UInt32 = 0x1 << 4
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
            static let Armor = "armor"
            static let LightBullet = "lightbullet"
            static let AddMp = "AddMp"
        }
        
        //For Shooting
        struct WeaponImage {
            static let Bullet = "Missel"
            static let IceBullet = "ice_bullet.png"
            static let FireBullet = "fire_bullet.png"
            static let MultiBullet = "Missel"
            static let BonusBullet = "DoubleBonus"
            static let Laser = "Ultimate"
            static let Invisibility = "Invisibility_Cloak"
            static let Heal = "Heal"
            static let Detect = "Detect"
            static let Armor = "armor"
            static let LightBullet = "light_bullet.png"
        }
        
        static let Sets = [
            
            WeaponType.FireBullet:"Keeps opponent flame and deducts him 2 hp/sec",
            WeaponType.IceBullet:"Freezes opponent for 3 sec",
            WeaponType.MultiBullet:"Shot 3 bullets every shot",
            WeaponType.Invisibility:"Let yourself invisible for 8 sec",
            WeaponType.Heal:"Add 20 hp to yourself",
            WeaponType.Armor:"Give yourself an armor and Deducts 70% damage",
            WeaponType.AddMp:"Add 30 mp to yourself"
        ]
        
        struct Effect {
            static let Fire = "fire_effect.png"
            static let Ice = "freeze"
        }
    }
    
}