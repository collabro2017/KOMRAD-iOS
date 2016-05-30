//
//  Chapter.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/24/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
class Chapter: NSObject, NSCoding
{
    var id : Int
    var name: String
    var passages: [Passage]?
    
    
    init(id: Int,name: String, passages: [Passage]?)
    {
        self.id = id
        self.name = name
        self.passages = passages
    }
    
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        id = decoder.decodeObjectForKey("id") as! Int
        name = decoder.decodeObjectForKey("name") as! String
        passages = decoder.decodeObjectForKey("passages") as! [Passage]?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(passages, forKey: "passages")
        
    }
    
    
}