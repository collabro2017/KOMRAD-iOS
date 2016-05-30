//
//  PFLine.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/17/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse

class PFLine : PFObject, PFSubclassing
{
    @NSManaged var passageLineId: Int
    @NSManaged var type: String
    @NSManaged var content: String
    @NSManaged var passage: PFPassage
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "PassageLine"
    }
}


