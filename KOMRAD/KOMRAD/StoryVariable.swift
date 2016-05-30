//
//  StoryVariable.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/25/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
class StoryVariable: NSObject, NSCoding
{
    var id : Int
    var name: String
    var initialValue: String
    var detail: String?
    var story: Story?
    
    init(id: Int,name: String, initialValue: String, detail: String?)
    {
        self.id = id
        self.name = name
        self.initialValue = initialValue
        self.detail = detail
    }
    
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        id = decoder.decodeObjectForKey("id") as! Int
        name = decoder.decodeObjectForKey("name") as! String
        initialValue = decoder.decodeObjectForKey("initialValue") as! String
        detail = decoder.decodeObjectForKey("detail") as! String?
        story = decoder.decodeObjectForKey("story") as! Story?
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(initialValue, forKey: "initialValue")
        coder.encodeObject(detail, forKey: "detail")
        coder.encodeObject(story, forKey: "story")
        
    }
}

