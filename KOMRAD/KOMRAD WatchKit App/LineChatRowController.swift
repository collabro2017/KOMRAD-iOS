//
//  LineChatRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/25/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit

class LineChatRowController: RowController
{
    @IBOutlet var BubbleEffect: WKInterfaceGroup!
    @IBOutlet var LineGroupOutlet: WKInterfaceGroup!
    @IBOutlet var LabelOutlet: WKInterfaceLabel!
    //var semaphore  = dispatch_semaphore_create(0);
    
    var currentLine: Line?
    
    var isLastOne: Bool? = false
    
    override func initialize(passage: Passage)
    {
        //We set the passage data for this row.
        self.passageData = passage
        
        //We should do UI Initialization here.
    }
    
    override func initialize(passage: Passage, object: AnyObject)
    {
        self.passageData = passage
        var line = object as! Line
        self.currentLine = line
        self.print()
    }
    
    override func initialize(passage: Passage, object: AnyObject, callback: () -> Void)
    {
        self.passageData = passage
        var line = object as! Line
        self.currentLine = line
        self.print(passage, callback: callback)
    }
   
    
    
    override func print(passage: Passage, callback: () -> Void)
    
    {
        if(self.currentLine != "")
        {
            self.LineGroupOutlet.setHidden(false)
            self.BubbleEffect.setHidden(false)
            //TODO: Change this with constants.
            if(self.currentLine!.type == Constants.LineTypes.SYSTEM)
            {
                self.LineGroupOutlet.setBackgroundColor(UIColor.blackColor())
                self.LineGroupOutlet.setCornerRadius(0.0)
                self.BubbleEffect.setHidden(true)
                self.LabelOutlet.setAttributedText(self.currentLine!.text)
            }
            else
            {
               if(self.passageData?.alreadyDisplayed == false)
                {
                    var multiplier = Double(self.currentLine!.text!.length)
                    var delay: Double = (0.5+(0.03 * multiplier)) * Double(NSEC_PER_SEC)
                    var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    let content = NSAttributedString(string: "...")
                    self.LabelOutlet.setAttributedText(content)
                    
                    self.BubbleEffect.setHidden(false)
                   // dispatch_group_async(Manager.sharedInstance.group, Manager.sharedInstance.myCustomQueue,{
                        dispatch_after(dispatchTime, dispatch_get_main_queue(),
                            {
                                self.LineGroupOutlet.setHidden(false)
                                self.LabelOutlet.setAttributedText(self.currentLine!.text)
                                callback()
                                
                                /*if(self.isLastOne == true)
                                {
                                    callback()
                                    //TODO: next line never be called
                                    self.isLastOne = false
                                }*/
                                
                                
                   //     })
                    });
                    // dispatch_group_wait(group, dispatchTime);
                    
                }
                else
                {
                    self.BubbleEffect.setHidden(true)
                    self.LineGroupOutlet.setHidden(false)
                    self.LabelOutlet.setAttributedText(self.currentLine!.text)
                }
            }
        }
        else
        {
            self.LineGroupOutlet.setHidden(true)
            self.BubbleEffect.setHidden(true)
        }
        
        
    }
    
    
    
    
}