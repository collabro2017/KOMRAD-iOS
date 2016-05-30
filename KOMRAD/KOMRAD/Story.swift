//
//  Story.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/24/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
class Story: NSObject, NSCoding
{
    var id : Int
    var author: String
    var title: String
    var subtitle: String
    var version: Int
    var chapters: [Chapter]?
    var storyVariables: [StoryVariable]?
    
    init(id: Int,author: String,title: String,subtitle: String,version: Int)
    {
        self.id = id
        self.author = author
        self.title = title
        self.subtitle = subtitle
        self.version = version
        self.chapters = [Chapter]()
        self.storyVariables = [StoryVariable]()
    }
    
    /*NSCoding*/
    required init(coder decoder: NSCoder) {
        id = decoder.decodeObjectForKey("id") as! Int
        author = decoder.decodeObjectForKey("author") as! String
        title = decoder.decodeObjectForKey("title") as! String
        subtitle = decoder.decodeObjectForKey("subtitle") as! String
        version = decoder.decodeObjectForKey("version") as! Int
        chapters = decoder.decodeObjectForKey("chapters") as! [Chapter]?
        storyVariables = decoder.decodeObjectForKey("storyVariables") as! [StoryVariable]?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(author, forKey: "author")
        coder.encodeObject(title, forKey: "title")
        coder.encodeObject(subtitle, forKey: "subtitle")
        coder.encodeObject(version, forKey: "version")        
        coder.encodeObject(chapters, forKey: "chapters")
        coder.encodeObject(storyVariables, forKey: "storyVariables")
        
    }
    
    
}
