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
    
    //var myCustomQueue: dispatch_queue_t = dispatch_queue_create("buildTableQueue", nil);
    var myCustomQueue = Manager.sharedInstance.myCustomQueue;
    
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
        NSKeyedUnarchiver.setClass(StoryVariable.self, forClassName: "StoryVariable")
        
        let myUnarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(messageData)
        
        let stories = myUnarchivedData as! [Story]
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            //Initialize current passages and build table.
            Manager.sharedInstance.story = stories[0];
            var variables = stories[0].storyVariables
            Utils.setStoryVariables(variables)
            
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
                //printTerminalRow(passage)
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
    
    func getAmountOfPrintableLines(passage: Passage) -> Int
    {
        var result: Int = 0
        
        for line in passage.lines!
        {
            if(line.type == Constants.LineTypes.TEXT || line.type == Constants.LineTypes.SYSTEM)
            {
                result++
            }
        }
        
        return result
    }
    
    
    func printChatRow(passage: Passage)
    {
        var printableRowsAdded : Int = 0
        
        if(passage.lines?.count > 0)
        {
            //Print Chat Lines
            for(var i=0; i < passage.lines?.count
                ; i++)
            {
                
                var currentline = passage.lines?[i];
                
                if(currentline!.type == Constants.LineTypes.TEXT || currentline!.type == Constants.LineTypes.SYSTEM)
                {
                    if (Manager.sharedInstance.isEnabledToMakeAction)
                    {
                        
                        // Some asynchronous work
                        
                        
                        dispatch_sync(myCustomQueue,
                            {
                                
                                //Get subindex and needed data.
                                //var i = Manager.sharedInstance.currentPassages.count - 1
                                var index = NSIndexSet(index: self.table.numberOfRows)
                                var numberOfRows = self.table.numberOfRows
                                
                                //Insert row and transform it to desired controller.
                                self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.LINE_CHAT)
                                let row = self.table.rowControllerAtIndex(numberOfRows) as? LineChatRowController
                                
                                //Add it!
                                self.addCurrentRow(row!)
                                printableRowsAdded++
                                
                                if(passage.lines?.count > 0) //TODO see if this work
                                {
                                    //It's the last passage, use callback.
                                    if(printableRowsAdded == self.getAmountOfPrintableLines(passage))
                                    {
                                        row?.isLastOne = true
                                    }
                                    //TODO: Check this later, not really sure about that subindex.
                                    row?.initialize(passage, object: passage.lines![i], callback: (self.printLastLineEnded))
                                    
                                }
                                else
                                {
                                    row?.initialize(passage)//TODO: remove
                                    
                                }
                                
                        });
                    }
                    else
                    {
                        print("PrintAlled is false")
                    }
                    
                }
                else
                {
                    //TODO CALL MATCHLINES
                    self.MatchLine((currentline?.text?.string)!)
                }
                dispatch_group_wait(Manager.sharedInstance.group,DISPATCH_TIME_FOREVER)
                self.table.scrollToRowAtIndex(self.table.numberOfRows - 1)
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
                        row?.initialize(passage)
                        
                        
                        
                });
            }
            //self.table.scrollToRowAtIndex(table.numberOfRows - 1)
        }
        
        
    }
    
    //This is used after every line has been printed.
    func printLastLineEnded(passage: Passage)
    {
        switch(passage.type!)
                {
                case Constants.Tags.CHAT:
                    //If there's no choice, we know that the only way to continue is using a Display macro.
                    if(passage.choices?.count > 0)
                    {
                        self.printChatChoices(passage)
                    }
                    else
                    {
                        if (Manager.sharedInstance.isEnabledToMakeAction)
                        {
                            self.executeDisplayNextPassage(passage)
                            
                        }
                    }
                    break
                case Constants.Tags.TERMINAL:
                    break
                default:
                    break
                }
       
        
    }
    
    func executeDisplayNextPassage(passage: Passage)
    {
        if(passage.paths?.count > 0)
        {
            //We add the next passage based on the Display macro (which is stored on the Path array of the Passage model)
            Manager.sharedInstance.mainInterface!.addPassageById(passage.paths![0].nextPassageId!)
        }
        else
        {
            //TODO: Add error handling
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
                    
                    //var i = Manager.sharedInstance.currentPassages.count - 1
                    var index = NSIndexSet(index: self.table.numberOfRows)
                    var numberOfRows = self.table.numberOfRows
                    
                    
                    self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.CHOICE_CHAT)
                    let row = self.table.rowControllerAtIndex(numberOfRows) as? ChoiceChatRowController
                    self.addCurrentRow(row!)
                    //row?.initialize(passage, object)
                    
                    
                    row?.initialize(passage, object: passage.choices![i])
                    
                    
            });
        }
        
        table.scrollToRowAtIndex(table.numberOfRows - 1)
        
    }
    
    func printTerminalRow(passage: Passage)
    {
        var printableRowsAdded : Int = 0
        
        if(passage.lines?.count > 0)
        {
            //Print Terminal Lines
            for(var i=0; i < passage.lines?.count
                ; i++)
            {
                var currentline = passage.lines?[i];
                
                //TODO: Probably only of type TEXT, check later.
                if(currentline!.type == Constants.LineTypes.TEXT || currentline!.type == Constants.LineTypes.SYSTEM)
                {
                    dispatch_sync(myCustomQueue,
                        {
                            //initialize the line
                            /*if(self.table.numberOfRows == 0)
                            {*/
                            //Get subindex and needed data.
                            var i = Manager.sharedInstance.currentPassages.count - 1
                            var index = NSIndexSet(index: self.table.numberOfRows)
                            var numberOfRows = self.table.numberOfRows
                            
                            //Insert row and transform it to desired controller.
                            self.table.insertRowsAtIndexes(index, withRowType: Constants.ROW.TERMINAL)
                            let row = self.table.rowControllerAtIndex(numberOfRows) as? LineTerminalRowController
                            
                            //Add it!
                            self.addCurrentRow(row!)
                            printableRowsAdded++
                            
                            if(passage.lines?.count > 0)
                            {
                                //It's the last passage, use callback.
                                if(printableRowsAdded == self.getAmountOfPrintableLines(passage))
                                {
                                    row?.isLastOne = true
                                }
                                
                                row?.initialize(passage, object: passage.lines![0])
                            }
                            else
                            {
                                row?.initialize(passage)
                            }
                            
                            /*}
                            else
                            {
                            let row = self.table.rowControllerAtIndex(i) as? LineTerminalRowController
                            row?.initialize(passage, object: passage.lines![i])
                            
                            self.addCurrentRow(row!)
                            }*/
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
        let nextPassage = Manager.sharedInstance.getPassageFromStoryById(id)
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
        var isEnabledToMakeAction = Manager.sharedInstance.isEnabledToMakeAction
        switch macro
        {
        case Constants.Macros.SET:
            if (isEnabledToMakeAction)
            {
                key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
                value = (line as NSString).substringWithRange(result.rangeAtIndex(4))
                
                Utils.setStoryVariable(key,value: value)
            }
            break;
        case Constants.Macros.AUDIO:
            if (isEnabledToMakeAction)
            {
                key = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            }//TODO: Play Audio
            break;
        case Constants.Macros.AFK:
            if (isEnabledToMakeAction)
            {
                key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
                value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            }//TODO: SEND NOTIFICATION
            break;
        case Constants.Macros.IF, Constants.Macros.ELSEIF:
            let variableName = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            let logicanSimbol = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            
            Manager.sharedInstance.evaluateExpresion(variableName,logicalSimbol: logicanSimbol, value: value)
            break;
        case Constants.Macros.ELSE:
            //If we cant evaluate, then cant print
            Manager.sharedInstance.isEnabledToMakeAction = Manager.sharedInstance.evaluateAllowed
            
            break;
        case Constants.Macros.CLOSEIF:
            Manager.sharedInstance.evaluateAllowed = true
            Manager.sharedInstance.isEnabledToMakeAction = true
            break;
        case Constants.Macros.DISPLAY:
            /* if (isEnabledToMakeAction)
            {
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            let passage = Manager.sharedInstance.getPassageByName(value)
            self.addPassage(passage);
            }*/
            break;
        default:
            break;
        }
    }
    func addCurrentRow(row: RowController)
    {
        Manager.sharedInstance.currentRows.append(row)
    }
    
    /*func disableChoicesByPassage(choice: Choice)
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
    }*/
    func disableChoicesByPassage(choice: Choice)
    {
        for row in Manager.sharedInstance.currentRows
        {
            if(row.passageData == choice.passage)
            {
                if(row is ChoiceChatRowController)
                {
                    var aux = row as! ChoiceChatRowController
                    if(aux.currentChoice != choice)
                    {
                        row.hide()
                    }
                    
                }
                else if(row is ChoiceTerminalRowController)
                {
                    var aux = row as! ChoiceTerminalRowController
                    if(aux.currentChoice != choice)
                    {
                        row.hide()
                    }
                }
                
            }
        }
    }
    
}