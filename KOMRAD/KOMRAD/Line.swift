//
//  Line.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/13/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation

class Line: NSObject, NSCoding
{
   
    var id: Int
    var text: NSAttributedString?
    var type: String?
    
    
    init(id: Int,type: String?, text: NSAttributedString?)
    {
        self.id = id
        self.text = text
        self.type = type
    }

    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        text = decoder.decodeObjectForKey("text") as! NSAttributedString
        id = decoder.decodeObjectForKey("id") as! Int
        type = decoder.decodeObjectForKey("type") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(text, forKey: "text")
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(type, forKey: "type")
    }

}
