//
//  PFPath.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/18/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse
class PFPath : PFObject, PFSubclassing
{
    @NSManaged var passagePathId: Int
     @NSManaged var lastPassage: PFPassage?
     @NSManaged var passage: PFPassage?
     @NSManaged var nextPassage: PFPassage?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "PassagePath"
    }
}
