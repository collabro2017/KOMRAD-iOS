//
//  Passage.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/12/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation
import Parse
class PFPassage : PFObject, PFSubclassing
{
    @NSManaged var title: String
    @NSManaged var name: String
    @NSManaged var passageId: Int
    @NSManaged var chapter: PFChapter
    
    override class func initialize() {
            struct Static {
                static var onceToken : dispatch_once_t = 0;
            }
            dispatch_once(&Static.onceToken) {
                self.registerSubclass()
            }
        }
        
        static func parseClassName() -> String {
            return "Passage"
        }
}
    
