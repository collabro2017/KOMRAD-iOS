//
//  ChoiceTerminalRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/28/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit

class ChoiceTerminalRowController: RowController
{
    var currentChoice : Choice?
    
    
    //OUTLETS
    @IBOutlet var choiceButtonOutlet: WKInterfaceButton!
    @IBOutlet var choiceGroupOutlet: WKInterfaceGroup!
    
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
            choiceButtonOutlet.setTitle(self.currentChoice!.text)
            choiceButtonOutlet.setHidden(false)
        }
        else
        {
            choiceButtonOutlet.setTitle(self.currentChoice!.text)
            choiceButtonOutlet.setHidden(false)
            choiceButtonOutlet.setEnabled(false)
        }
    }

    
    @IBAction func choicePressed()
    {
        if (currentChoice!.storyVariable != nil)
        {
            Manager.sharedInstance.ManageStoryVariables(currentChoice!)
        }
        Manager.sharedInstance.mainInterface!.addPassageByChoice(self.currentChoice!)
        choiceButtonOutlet.setEnabled(false)
    }
    
    override func hide()
    {
        super.hide()
        self.choiceButtonOutlet.setHidden(true)
    }
}