//
//  Passage.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/17/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation

class Passage: NSObject, NSCoding
{
    var id : Int
    var title: String
    var choices: [Choice]?
    var lines: [Line]?
    var type : String? //Terminal or Chat or Splash
    var tags : [Tag]?
    var paths: [Path]?
    
    var alreadyDisplayed = Bool(false)
    
    
    init(id: Int,title: String)
    {
        self.id = id
        self.title = title
        self.alreadyDisplayed = false
    }
    
     /*NSCoding*/
    required init(coder decoder: NSCoder) {
        title = decoder.decodeObjectForKey("title") as! String
        id = decoder.decodeObjectForKey("id") as! Int
        choices = decoder.decodeObjectForKey("choices") as! [Choice]?
        lines = decoder.decodeObjectForKey("lines") as! [Line]?
        type = decoder.decodeObjectForKey("type") as! String?
        tags = decoder.decodeObjectForKey("tags") as! [Tag]?
        paths = decoder.decodeObjectForKey("paths") as! [Path]?
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(title, forKey: "title")
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(choices, forKey: "choices")
        coder.encodeObject(lines, forKey: "lines")
        coder.encodeObject(type, forKey: "type")
        coder.encodeObject(tags, forKey: "tags")
        coder.encodeObject(paths, forKey: "paths")
    }
    
    func selectChoiceAsTaken(choice: Choice)
    {
        for auxChoice in choices!
        {
            if(auxChoice.id == choice.id)
            {
                auxChoice.wasTaken = true
            }
        }
    }


}



    