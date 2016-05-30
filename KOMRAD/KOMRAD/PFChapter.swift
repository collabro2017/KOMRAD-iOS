//
//  PFChapter.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/24/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse
class PFChapter : PFObject, PFSubclassing
{
    @NSManaged var chapterId: Int
    @NSManaged var name: String
    @NSManaged var story: PFStory
    
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Chapter"
    }
}