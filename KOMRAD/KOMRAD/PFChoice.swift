//
//  PFChoice.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/17/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse
class PFChoice : PFObject, PFSubclassing
{
    @NSManaged var choiceId: Int
    @NSManaged var name: String
    @NSManaged var storyVariable: PFStoryVariable?
    @NSManaged var storyVariableValue: String?
    @NSManaged var passage: PFPassage
    @NSManaged var passagePath: PFPath
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Choice"
    }
    
    
    
    
}