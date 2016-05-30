//
//  TerminalRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/22/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//


import Foundation
import WatchKit


class TerminalRowController: RowController
{
    //OUTLETS
    @IBOutlet var lineLabel: WKInterfaceLabel!
    @IBOutlet var promptGroup: WKInterfaceGroup!
    @IBOutlet var cursorOutlet: WKInterfaceLabel!
    @IBOutlet var choiceButtonOutlet: WKInterfaceButton!
    
    override func initialize(passage: Passage)
    {
        self.passageData = passage
    }
    
    override func initialize(passage: Passage, object: AnyObject)
    {
        self.passageData = passage
    }
    
    override func hide()
    {
        
    }
    
    @IBAction func choicePressed()
    {
        
    }
    
    
}