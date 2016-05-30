//
//  PassageP.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/15/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse


class PassageP : PFObject, PFSubclassing
{
    @NSManaged var passageId : String
    @NSManaged var name : String
    @NSManaged var title : String
    @NSManaged var storyId : String
    
    
        override class func initialize() {
            struct Static {
                static var onceToken : dispatch_once_t = 0;
            }
            dispatch_once(&Static.onceToken) {
                self.registerSubclass()
            }
        }
        
        static func parseClassName() -> String {
            return "PassageP"
        }
  
    
    
    
}