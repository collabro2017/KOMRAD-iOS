//
//  SplashRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/22/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit


class SplashRowController: RowController
{
    //OUTLETS
    @IBOutlet var MessageButtonOutlet: WKInterfaceButton!
    
    //Properties
    var currentChoice : Choice?
    
    
    override func initialize(passage: Passage)
    {
        self.passageData = passage
    }
    
    override func initialize(passage: Passage, object: AnyObject)
    {
        self.passageData = passage
        
        var choice = object as! Choice
        self.currentChoice = choice
    }
    
    override func hide()
    {
        
    }
    
    @IBAction func ButtonPressed()
    {
        if(currentChoice != nil)
        {
            Manager.sharedInstance.mainInterface?.addPassageByChoice(self.currentChoice!)
            MessageButtonOutlet.setEnabled(false)
        }
        else
        {
            //If it doesn't have choices it will only have one path
           
            
            Manager.sharedInstance.mainInterface?.addPassageById(passageData!.paths![0].nextPassageId!)
            MessageButtonOutlet.setEnabled(false)
        }        
    }
}