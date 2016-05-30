//
//  Tag.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/18/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
class Tag: NSObject, NSCoding
{
    
    var id: Int
    var name: String
    
    
    init(id: Int,name: String)
    {
        self.id = id
        self.name = name
    }
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        id = decoder.decodeObjectForKey("id") as! Int
        name = decoder.decodeObjectForKey("name") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(id, forKey: "id")
       
    }
}