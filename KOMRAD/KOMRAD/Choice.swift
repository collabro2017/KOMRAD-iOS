//
//  Choice.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/12/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation

class Choice: NSObject, NSCoding
{
    var id: Int?
    var text: String?
    var passage: Passage?
    var passagePath: Path?
    var storyVariable: StoryVariable?
    var storyValue: String?

    
    
    var wasTaken: Bool?
   
    
    init(id: Int,text: String?,passage: Passage,passagePath: Path?, wasTaken: Bool? = false)
    {
        self.id = id
        self.text = text
        self.passagePath = passagePath
        self.passage = passage
        self.wasTaken = wasTaken
    }
    
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        text = decoder.decodeObjectForKey("text") as! String
        id = decoder.decodeObjectForKey("id") as! Int
        passagePath = decoder.decodeObjectForKey("passagePath") as! Path?
        passage = decoder.decodeObjectForKey("passage") as! Passage?
        wasTaken = decoder.decodeObjectForKey("wasTaken") as! Bool
        storyVariable = decoder.decodeObjectForKey("storyVariable") as! StoryVariable?
        storyValue = decoder.decodeObjectForKey("storyValue") as! String?
        
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(text, forKey: "text")
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(passagePath, forKey: "passagePath")
        coder.encodeObject(passage, forKey: "passage")
        coder.encodeObject(wasTaken, forKey: "wasTaken")
        coder.encodeObject(storyVariable, forKey: "storyVariable")
        coder.encodeObject(storyValue, forKey: "storyValue")
    }
    
}