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
    
}