//
//  Path.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/18/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
class Path : NSObject, NSCoding
{
    var id: Int
    var lastPassageId: Int?
    var passageId: Int
    var nextPassageId:Int?

    init(id: Int,lastPassageId: Int?, passageId: Int, nextPassageId: Int?)
    {
        self.id = id
        self.lastPassageId = lastPassageId
        self.passageId = passageId
        self.nextPassageId = nextPassageId
    }
    
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        
        id = decoder.decodeObjectForKey("id") as! Int
        lastPassageId = decoder.decodeObjectForKey("lastPassageId") as! Int
        passageId = decoder.decodeObjectForKey("passageId") as! Int
        nextPassageId = decoder.decodeObjectForKey("nextPassageId") as! Int
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(lastPassageId, forKey: "lastPassageId")
        coder.encodeObject(passageId, forKey: "passageId")
        coder.encodeObject(nextPassageId, forKey: "nextPassageId")
    }
    
}
