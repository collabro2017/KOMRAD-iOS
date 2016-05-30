//
//  MainInterfaceController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/22/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MainInterfaceController: WKInterfaceController, WCSessionDelegate
{
    @IBOutlet var table: WKInterfaceTable!
    
    var myCustomQueue: dispatch_queue_t = dispatch_queue_create("buildTableQueue", nil);
    var session: WCSession!
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //Session works
        if(WCSession.isSupported())
        {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        
        
        Manager.sharedInstance.table = table
        Manager.sharedInstance.mainInterface = self
        
        //Supposedly here should receive the new passages.
        //We should store this on Singleton, probably is a good idea to have two separated arrays for different chapters, I'm not sure about this.
        //We should also have an Passage array in Singleton that has the currentPassages (that's a good name I think!)
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        
        NSKeyedUnarchiver.setClass(Passage.self, forClassName: "Passage")
        NSKeyedUnarchiver.setClass(Choice.self, forClassName: "Choice")
        NSKeyedUnarchiver.setClass(Line.self, forClassName: "Line")
        NSKeyedUnarchiver.setClass(Tag.self, forClassName: "Tag")
        NSKeyedUnarchiver.setClass(Path.self, forClassName: "Path")
        NSKeyedUnarchiver.setClass(Story.self, forClassName: "Story")
        NSKeyedUnarchiver.setClass(Chapter.self, forClassName: "Chapter")
        
        let myUnarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(messageData)
        
        let stories = myUnarchivedData as! [Story]
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            //Initialize current passages and build table.
            Manager.sharedInstance.story = stories[0];
            Manager.sharedInstance.initCurrent()
            self.buildTable()
        }
        
        
        
    }
    
    func buildTable()
    {
        for passage in Manager.sharedInstance.currentPassages
        {
            buildRow(passage)
        }
    }
    
    func buildRow(passage: Passage)
    {
        for tag in passage.tags!
        {
            print(passage.title)
            print(tag.name)
            print(tag.id)
            switch tag.name
            {
            case Constants.Tags.CHAT:
                printChatRow(passage)
                break
                
            case Constants.Tags.TERMINAL:
                printTerminalRow(passage)
                break
                
            case Constants.Tags.SPLASHSCREEN:
                printSplashRow(passage)
                break
                
            default:
                break
            }
        }
        
        //We set the Passage as Already Displayed for next time.
        Manager.sharedInstance.setAlreadyDisplayedByPassage(passage)
        
    }
    
    
    
    func printChatRow(passage: Passage)
    {
        
        if(passage.lines?.count > 0)
        {
            //Print Chat Lines
            for(var i=0; i < passage.lines?.count
                ; i++)
            {
                var currentline = passage.lines?[i];
                
                if(currentline!.type == Constants.LineTypes.TEXT || currentline!.type == Constants.LineTypes.SYSTEM)
                {
                    dispatch_sync(myCustomQueue,
                        {
                            var i = Manager.sharedInstance.currentPassages.count - 1
                            var index = NSIndexSet(index: self.table.numberOfRows)
                            var numberOfRows = self.table.numberOfRows
                            
                            self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.LINE_CHAT)
                            let row = self.table.rowControllerAtIndex(numberOfRows) as? LineChatRowController
                            
                            self.addCurrentRow(row!)
                            self.table.scrollToRowAtIndex(numberOfRows+1)
                            
                            if(passage.lines?.count > 0) //TODO see if this work
                            {
                                //It's the last passage, use callback.
                                if(((passage.lines?.count)! - 1) ==  i)
                                {
                                    row?.isLastOne = true
                                }
                                row?.initialize(passage, object: passage.lines![0], callback: (self.printChatChoices))
                            }
                            else
                            {
                                row?.initialize(passage)
                            }
                    });
                    
                }
                else
                {
                    //TODO CALL MATCHLINES
                    MatchLine((currentline?.text?.string)!)
                }
                
            }
            
        }
        else
        {
            //Print Chat Choices
            for(var i=0; i < passage.choices?.count
                ; i++)
            {
                dispatch_sync(myCustomQueue,
                    {
                        //initialize the choice
                        /*if(self.table.numberOfRows == 0)
                        {*/
                        
                        var i = Manager.sharedInstance.currentPassages.count - 1
                        var index = NSIndexSet(index: self.table.numberOfRows)
                        var numberOfRows = self.table.numberOfRows
                        
                        
                        self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.CHOICE_CHAT)
                        let row = self.table.rowControllerAtIndex(numberOfRows) as? ChoiceChatRowController
                        self.addCurrentRow(row!)
                        self.table.scrollToRowAtIndex(numberOfRows)

                        if(passage.choices?.count > 0)
                        {
                            row?.initialize(passage, object: passage.choices![0])
                        }
                        else
                        {
                            row?.initialize(passage)
                        }
                });
            }
        }
        
        
    }
    
    
    //TODO: This method should be "printLineEnded" and should be used by any method who needs to do something after the print animation.
    func printChatChoices(passage: Passage)
    {
        //Print Chat Choices
        for(var i=0; i < passage.choices?.count
            ; i++)
        {
            dispatch_sync(myCustomQueue,
                {
                    //initialize the choice
                    /*if(self.table.numberOfRows == 0)
                    {*/
                    
                    var i = Manager.sharedInstance.currentPassages.count - 1
                    var index = NSIndexSet(index: self.table.numberOfRows)
                    var numberOfRows = self.table.numberOfRows
                    
                    
                    self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.CHOICE_CHAT)
                    let row = self.table.rowControllerAtIndex(numberOfRows) as? ChoiceChatRowController
                    self.addCurrentRow(row!)
                    self.table.scrollToRowAtIndex(numberOfRows)

                    if(passage.choices?.count > 0)
                    {
                        row?.initialize(passage, object: passage.choices![0])
                    }
                    else
                    {
                        row?.initialize(passage)
                    }
            });
        }
    }
    
    func printTerminalRow(passage: Passage)
    {
        //Print Terminal Lines
        for(var i=0; i < passage.lines?.count
            ; i++)
        {
            dispatch_sync(myCustomQueue,
                {
                    //initialize the line
                    if(self.table.numberOfRows == 0)
                    {
                        var index = NSIndexSet(index: 0)
                        self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.TERMINAL)
                        let row = self.table.rowControllerAtIndex(0) as? LineTerminalRowController
                        self.addCurrentRow(row!)
                        self.table.scrollToRowAtIndex(self.table.numberOfRows)

                        if(passage.choices?.count > 0)
                        {
                            row?.initialize(passage, object: passage.lines![0])
                        }
                        else
                        {
                            row?.initialize(passage)
                        }
                        
                    }
                    else
                    {
                        let row = self.table.rowControllerAtIndex(i) as? LineTerminalRowController
                        row?.initialize(passage, object: passage.lines![i])
                        
                        self.addCurrentRow(row!)
                    }
            });
        }
        
        //Print Terminal Choices
        for(var i=0; i < passage.choices?.count
            ; i++)
        {
            dispatch_sync(myCustomQueue,
                {
                    //initialize the choice
                    if(self.table.numberOfRows == 0)
                    {
                        var index = NSIndexSet(index: 0)
                        self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.TERMINAL)
                        let row = self.table.rowControllerAtIndex(0) as? ChoiceTerminalRowController
                        self.addCurrentRow(row!)
                        self.table.scrollToRowAtIndex(self.table.numberOfRows)

                        if(passage.choices?.count > 0)
                        {
                            row?.initialize(passage, object: passage.choices![0])
                        }
                        else
                        {
                            row?.initialize(passage)
                        }
                    }
                    else
                    {
                        let row = self.table.rowControllerAtIndex(i) as? ChoiceTerminalRowController
                        row?.initialize(passage, object: passage.choices![i])
                        
                        self.addCurrentRow(row!)
                    }
            });
        }
    }
    
    func printSplashRow(passage: Passage)
    {
        //Currently we don't need to do anything as is only an image.
        dispatch_sync(myCustomQueue,
            {
                //initialize the line
                
                var i = Manager.sharedInstance.currentPassages.count - 1
                let index = NSIndexSet(index: i)
                self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.SPLASH)
                let row = self.table.rowControllerAtIndex(i) as? SplashRowController
                self.addCurrentRow(row!)
               

                if(passage.choices?.count > 0)
                {
                    row?.initialize(passage, object: passage.choices![0])
                }
                else
                {
                    row?.initialize(passage)
                }
                
                
        });
    }
    
    func addPassageByChoice(choice: Choice)
    {
        addPassageById((choice.passagePath?.nextPassageId)!)
        disableChoicesByPassage(choice)
    }
    
    func addPassageById(id: Int)
    {
        let nextPassage: Passage? = Manager
            .sharedInstance.getPassageFromStoryById(id)
        if(nextPassage != nil)
        {
            self.addPassage(nextPassage!)
        }
        else
        {
            print("Next Passage is NIL")
        }
        
    }
    func addPassage(passage: Passage)
    {
        Manager.sharedInstance.currentPassages.append(passage)
        self.buildRow(passage)
    }
    
    func MatchLine(line: String)
    {
        var results = Utils.RegexTest(Constants.RegexMacros.REGEX,input: line)
        
        if ((results != nil) && (results?.count > 0))
        {
            for result in results! as [NSTextCheckingResult]
            {
                // range at index 0: full match
                // range at index 1: first capture group
                let macro = (line as NSString).substringWithRange(result.rangeAtIndex(1))
                MacroAction(result,line: line, macro: macro)
                
            }
            
            
        }
        
    }
    
    
    private func MacroAction(result: NSTextCheckingResult,line: String, macro: NSString)
    {
        var key = ""
        var value = ""
        
        switch macro
        {
        case Constants.Macros.SET:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(4))
            
            Utils.setStoryVariable(key,value: value)
            break;
        case Constants.Macros.AUDIO:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            //TODO: Play Audio
            break;
        case Constants.Macros.IF:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            
            break;
        case Constants.Macros.AFK:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
           //TODO: SEND NOTIFICATION
            break;
        
        case Constants.Macros.DISPLAY:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            let passage = Manager.sharedInstance.getPassageByName(value)
            self.addPassage(passage);
            
            break;
        default:
            break;
        }
    }
    func addCurrentRow(row: RowController)
    {
        Manager.sharedInstance.currentRows.append(row)
    }
    
    func disableChoicesByPassage(choice: Choice)
    {
        for row in Manager.sharedInstance.currentRows
        {
            if(row.passageData == choice.passage)
            {
                for auxChoice in (row.passageData?.choices)!
                {
                    if(choice != auxChoice)
                    {
                        row as! ChoiceChatRowController
                        row.hide()
                    }
                }
            }
        }
    }
    
    
}