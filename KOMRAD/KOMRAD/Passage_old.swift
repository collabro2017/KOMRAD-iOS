//
//  Passage.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/12/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation

class Passage_old: NSObject
{
    //TODO: Support arrays properly.
    
    let title: String
    //let content: String?
    //let choice: Choice?
    //let line: Line?
    var id: Int
    let choice: String?
    let line: String?
    var choice01Selected = Bool(true)
    var choice02Selected = Bool(true)
    var alreadyDisplayed = Bool(false)
    
    var wasChosen = Bool(false)
    /*let father: Passage?
    let son: [Passage]?*/
    var destination1 : Passage_old?
    var destination2 : Passage_old?
    
   // init(title: String, line: Line?, choice: Choice?, id: Int)
    init(title: String, line: String?, choice: String?, id: Int)
    {
        self.title = title
        self.choice = choice
        self.line = line
        self.id = id
        self.choice01Selected = true
        self.choice02Selected = true
        self.alreadyDisplayed = false
        self.wasChosen = false
    }
    
    
    
}