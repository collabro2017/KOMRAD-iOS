//
//  LineTerminalRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/25/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit

class LineTerminalRowController: RowController
{
    //OUTLETS
    @IBOutlet var lineLabel: WKInterfaceLabel!
    @IBOutlet var promptGroup: WKInterfaceGroup!
    @IBOutlet var cursorOutlet: WKInterfaceLabel!
    
    var currentLine: Line?
    
    var isLastOne: Bool? = false
    
    var index: Int = 0
    var prompt = NSAttributedString(string: "")
    var cursor = NSAttributedString(string: "_")

    
    override func initialize(passage: Passage) {
        self.passageData = passage
    }
    
    override func initialize(passage: Passage, object: AnyObject, callback: () -> Void) {
        self.passageData = passage
        var line = object as! Line
        self.currentLine = line
        self.print(passageData!, callback: callback)
        
    }
    
    override func print(passage: Passage, callback: () -> Void)
    {
        //var currentLastPassage : Passage?
        //var index = Manager.sharedInstance.currentPassages.count - 1
        //currentLastPassage = Manager.sharedInstance.currentPassages[index]
        
        let longDelay = Bool(false);
        
        /*if(currentLastPassage == self.passageData)
        {
            printDelayed((self.currentLine?.text?.string)!, label: self.lineLabel, index: &self.index, passage: self.passageData!, longDelay:longDelay)
        }
        else
        {
            lineLabel.setAttributedText(self.currentLine!.text)
        }*/
        if(passageData?.alreadyDisplayed == false)
        {
            printDelayed((self.currentLine?.text?.string)!, label: self.lineLabel, index: &self.index, passage: self.passageData!, longDelay:longDelay, callback: callback)
           
        }
        else
        {
            //TODO: Probably we will need to
            lineLabel.setAttributedText(self.currentLine!.text)
            callback()
        }
        
    }
    
    func printDelayed(content: String, label: WKInterfaceLabel, inout index: Int, passage: Passage,var longDelay: Bool, callback: () -> Void )
    {
        let seconds = 0.04
        let secondsWithLineBreak = 0.5
        var delay: Double = 0.0   // nanoseconds per seconds
        var lastChar: Character
        if(index < content.length)
        {
            lastChar = content[index]
        }
        else
        {
            lastChar = content[content.length - 1]
        }
        if(longDelay)
        {
            delay = (seconds + secondsWithLineBreak) * Double(NSEC_PER_SEC)
        }
        else
        {
            delay = seconds * Double(NSEC_PER_SEC)
        }
        
        if(lastChar == "\n")
        {
            longDelay = true;
        }
        else
        {
            longDelay = false;
        }
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_async(dispatch_get_main_queue(),{
            Manager.sharedInstance.table?.scrollToRowAtIndex((Manager.sharedInstance.table?.numberOfRows)! - 1)
        });
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                
                if(index <= content.length)
                {
                    let aString = NSAttributedString(string: content.subString(0, length: index))
                    
                    
                    let aux = NSMutableAttributedString(attributedString: self.prompt)
                    
                    
                    if(index == content.length)
                    {
                        aux.appendAttributedString(aString)
                        //self.promptGroup.setHidden(false)
                    }
                    else
                    {
                        aux.appendAttributedString(aString)
                        aux.appendAttributedString(self.cursor)
                    }                 
                    
                    label.setAttributedText(aux)//(content.subString(0, length: index))
                    index++
                    self.printDelayed(content, label: label, index: &index, passage: passage, longDelay: longDelay, callback: callback)
                }
                else
                {
                    
                    
                    //reset index
                    self.index = 0
                    
                    //Callback goes here. 
                    if(self.isLastOne == true)
                    {
                        self.promptGroup.setHidden(false)
                        
                    }
                    
                     callback()
                    
                }
               
                var amountOfPassages = (Manager.sharedInstance.currentPassages)
                
                //Scrolling should be handled in Interface Controller.
                //Singleton.sharedInstance.table?.scrollToRowAtIndex(amountOfPassages - 1)
                
        })
        
        
    }
    
}
