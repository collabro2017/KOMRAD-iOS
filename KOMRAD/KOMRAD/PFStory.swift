//
//  Story.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/15/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse
class PFStory : PFObject, PFSubclassing
{
    @NSManaged var storyId: Int
    @NSManaged var author: String
    @NSManaged var subtitle: String
    @NSManaged var version: Int
    @NSManaged var title: String
    //TODO: make and array of storyVariables
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Story"
    }
}