//
//  ChoiceChatRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/25/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit

class ChoiceChatRowController: RowController
{
    @IBOutlet var ChoiceButtonGroup: WKInterfaceGroup!
    @IBOutlet var ChoiceButtonOutlet: WKInterfaceButton!
    

    
    var currentChoice : Choice?
    
    override func initialize(passage: Passage)
    {
        //We set the passage data for this row.
        self.passageData = passage
               
        //We should do UI Initialization here.
    }
    
    override func initialize(passage: Passage, object: AnyObject)
    {
        self.passageData = passage
        
        var choice = object as! Choice
        self.currentChoice = choice
        
        self.print()
        
    }
    
    
    override func print()
    {
        if(self.currentChoice!.wasTaken == false)
        {
            self.ChoiceButtonOutlet.setTitle(self.currentChoice!.text)
            self.ChoiceButtonOutlet.setHidden(false)
        }
        else
        {
            self.ChoiceButtonOutlet.setTitle(self.currentChoice!.text)
            self.ChoiceButtonOutlet.setHidden(false)
            self.ChoiceButtonOutlet.setEnabled(false)
        }
        //Manager.sharedInstance.table?.scrollToRowAtIndex((Manager.sharedInstance.table?.numberOfRows)! - 1)
        
    }
    
    @IBAction func ChoicePressed()
    {
        if (currentChoice!.storyVariable != nil)
        {
            Manager.sharedInstance.ManageStoryVariables(currentChoice!)
        }
        Manager.sharedInstance.mainInterface!.addPassageByChoice(self.currentChoice!)
        ChoiceButtonOutlet.setEnabled(false)
    }
    
    override func hide()
    {
        super.hide()
        self.ChoiceButtonOutlet.setHidden(true)
    }
    
    
    
}