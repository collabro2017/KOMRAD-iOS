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

class MainInterfaceController: WKInterfaceController
{
    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var SpaceLabel: WKInterfaceLabel!
    var myCustomQueue: dispatch_queue_t = dispatch_queue_create("buildTableQueue", nil);
    // var myCustomQueue = Manager.sharedInstance.myCustomQueue;
    // var complete = false
    //var session: WCSession!
    var printableRowsAdded : Int = 0
    var lineIndex = -1
    var choiceIndex = -1
    var currentPassage : Passage?
    var nextPassage : Passage?
    // var session : WCSession!
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Manager.sharedInstance.initSession()
        
        //Session works
        
        //Manager.sharedInstance.session = session
        Manager.sharedInstance.table = table
        Manager.sharedInstance.mainInterface = self
        Manager.sharedInstance.events.listenTo("buildTable", action: self.buildTable);
        Manager.sharedInstance.events.listenTo("buildRow", action: self.addPassage);
        
        
        
        
        
        
        
        //Supposedly here should receive the new passages.
        //We should store this on Singleton, probably is a good idea to have two separated arrays for different chapters, I'm not sure about this.
        //We should also have an Passage array in Singleton that has the currentPassages (that's a good name I think!)
    }
    /*  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
    deserializeNSData(userInfo["Story"] as! NSData)
    }
    */
    
    /*func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
    
    if (self.session.reachable)
    {
    deserializeNSData(messageData, replyHandler: replyHandler)
    sendNextPassageMessage(666)
    }
    
    
    }*/
    
    
    
    /*func deserializeNSData(messageData : NSData, replyHandler: (NSData) -> Void)
    {
    NSKeyedUnarchiver.setClass(Passage.self, forClassName: "Passage")
    NSKeyedUnarchiver.setClass(Choice.self, forClassName: "Choice")
    NSKeyedUnarchiver.setClass(Line.self, forClassName: "Line")
    NSKeyedUnarchiver.setClass(Tag.self, forClassName: "Tag")
    NSKeyedUnarchiver.setClass(Path.self, forClassName: "Path")
    NSKeyedUnarchiver.setClass(Story.self, forClassName: "Story")
    NSKeyedUnarchiver.setClass(Chapter.self, forClassName: "Chapter")
    NSKeyedUnarchiver.setClass(StoryVariable.self, forClassName: "StoryVariable")
    
    let myUnarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(messageData)
    
    // let stories = myUnarchivedData as! [Story]
    let result = myUnarchivedData as? Chapter
    
    if (result != nil)
    {
    dispatch_async(dispatch_get_main_queue()) {
    Manager.sharedInstance.story?.chapters?.append(result!)
    replyHandler(NSData())
    }
    
    }
    else
    {
    var variables = myUnarchivedData as? [StoryVariable]
    if (variables != nil)
    {
    dispatch_async(dispatch_get_main_queue()) {
    
    Utils.setStoryVariables(&Manager.sharedInstance.StoryVariables,storyVariables:variables!)
    Manager.sharedInstance.initCurrent()
    self.buildTable()
    }
    }
    else
    {
    var story = myUnarchivedData as? Story
    if (story != nil)
    {
    dispatch_async(dispatch_get_main_queue()) {
    Manager.sharedInstance.story = story
    replyHandler(NSData())
    }
    }
    }
    }
    
    }
    */
    
    
    func buildTable()
    {
        for passage in Manager.sharedInstance.currentPassages
        {
            buildRow(passage)
        }
    }
    
    func buildRow(passage: Passage)// lineIndex: Int
    {
        lineIndex = -1
        currentPassage = passage
        Manager.sharedInstance.isEnabledToMakeAction = true
        Manager.sharedInstance.evaluateAllowed = true
        
        for tag in passage.tags!
        {
            print(passage.title)
            print(tag.name)
            print(tag.id)
            switch tag.name
            {
            case Constants.Tags.CHAT:
                
                printChatLine()
                break
                
            case Constants.Tags.TERMINAL:
                printTerminalLine()
                break
                
            case Constants.Tags.SPLASHSCREEN:
                printSplashRow(passage)
                Manager.sharedInstance.setAlreadyDisplayedByPassage(passage)
                break
                
            default:
                break
            }
        }
        
        //We set the Passage as Already Displayed for next time.
        
        
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
    
    func wipeRows()
    {
        Manager.sharedInstance.currentRows = [RowController]()
        
        for(var i=0; i <= table.numberOfRows
            ; i++)
        {
            let index = NSIndexSet(index: i)
            table.removeRowsAtIndexes(index)
        }
    }
    
    func AddNewRow(rowType : String){
        
        let index = NSIndexSet(index: self.table.numberOfRows)
        table.insertRowsAtIndexes(index, withRowType: rowType)
        dispatch_async(dispatch_get_main_queue(),{
            self.table.scrollToRowAtIndex(self.table.numberOfRows - 1)
        });
    }
    
    func AddLineChatRow () -> LineChatRowController
    {
        // var printableRowsAdded = 0
        
        AddNewRow(Constants.ROW.LINE_CHAT)
        let numberOfRows = table.numberOfRows-1
        let row = table.rowControllerAtIndex(numberOfRows) as! LineChatRowController
        addCurrentRow(row)
        //  self.table.scrollToRowAtIndex(table.numberOfRows - 1)
        return row
        
    }
    
    
    func printChatLine(){
        
        lineIndex++
        
        Manager.sharedInstance.storeLineIndex(lineIndex)
        
        if (lineIndex >= currentPassage!.lines?.count)
        {
            printChatChoices(currentPassage!)
        }
        else
        {
            let currentline = currentPassage!.lines?[lineIndex];
            
            if(currentline!.type == Constants.LineTypes.TEXT || currentline!.type == Constants.LineTypes.SYSTEM)
            {
                
                if (Manager.sharedInstance.isEnabledToMakeAction)
                {
                    
                    let row = AddLineChatRow()
                    //It's the last passage, use callback.
                    if(printableRowsAdded == self.getAmountOfPrintableLines(currentPassage!))
                    {
                        row.isLastOne = true
                    }
                    row.initialize(currentPassage!, object: currentPassage!.lines![lineIndex], callback: self.printChatLine)
                    
                }
                else
                {
                    print("PrintAlled is false")
                    printChatLine()
                }
                
            }
            else
            {
                //TODO CALL MATCHLINES
                MatchLine((currentline?.text?.string)!, callback: self.printChatLine)
            }
        }
        
        
    }
    
    func AddChoiceChatRow() -> ChoiceChatRowController{
        
        AddNewRow(Constants.ROW.CHOICE_CHAT)
        let numberOfRows = self.table.numberOfRows-1
        let row = self.table.rowControllerAtIndex(numberOfRows) as! ChoiceChatRowController
        addCurrentRow(row)
        //  table.scrollToRowAtIndex(table.numberOfRows+10)
        return row
    }
    
    func AddLineTerminalRow () -> LineTerminalRowController
    {
        // var printableRowsAdded = 0
        
        AddNewRow(Constants.ROW.LINE_TERMINAL)
        let numberOfRows = self.table.numberOfRows-1
        let row = self.table.rowControllerAtIndex(numberOfRows) as! LineTerminalRowController
        addCurrentRow(row)
        //table.scrollToRowAtIndex(table.numberOfRows - 1)
        return row
        
    }
    
    
    func AddChoiceTerminalRow() -> ChoiceTerminalRowController{
        
        AddNewRow(Constants.ROW.CHOICE_TERMINAL)
        let numberOfRows = self.table.numberOfRows-1
        let row = self.table.rowControllerAtIndex(numberOfRows) as! ChoiceTerminalRowController
        addCurrentRow(row)
        // table.scrollToRowAtIndex(table.numberOfRows - 1)
        return row
    }
    
    
    func printChatChoices(passage: Passage){
        
        Manager.sharedInstance.setAlreadyDisplayedByPassage(passage)
        
        if (passage.choices?.count > 0)
        {
            for(var i=0; i < passage.choices?.count
                ; i++)
            {
                let row = AddChoiceChatRow()
                row.initialize(passage, object: passage.choices![i])
                
            }
        }
        else
        {
            //self.addPassage(nextPassage!)
            
            //self.executeDisplayNextPassage(passage)
        }
        
    }
    
    func printTerminalChoices(passage: Passage){
        
        Manager.sharedInstance.setAlreadyDisplayedByPassage(passage)
        
        if (passage.choices?.count > 0)
        {
            for(var i=0; i < passage.choices?.count
                ; i++)
            {
                let row = AddChoiceTerminalRow()
                row.initialize(passage, object: passage.choices![i])
                
            }
        }
        else
        {
            //self.addPassage(nextPassage!)
            
            //self.executeDisplayNextPassage(passage)
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
    
    func printTerminalLine(){
        
        lineIndex++
        
        Manager.sharedInstance.storeLineIndex(lineIndex)
        
        if (lineIndex >= currentPassage!.lines?.count)
        {
            
            printTerminalChoices(currentPassage!)
            
        }
        else
        {
            let currentline = currentPassage!.lines?[lineIndex];
            
            if(currentline!.type == Constants.LineTypes.TEXT || currentline!.type == Constants.LineTypes.SYSTEM)
            {
                if (Manager.sharedInstance.isEnabledToMakeAction)
                {
                    
                    let row = AddLineTerminalRow()
                    //It's the last passage, use callback.
                    if(printableRowsAdded == self.getAmountOfPrintableLines(currentPassage!))
                    {
                        row.isLastOne = true
                    }
                    row.initialize(currentPassage!, object: currentPassage!.lines![lineIndex], callback: self.printTerminalLine)
                }
                else
                {
                    print("PrintAllowed is false")
                    printTerminalLine()
                }
            }
            else
            {
                //TODO CALL MATCHLINES
                MatchLine((currentline?.text?.string)!, callback: self.printTerminalLine)
            }
        }
        
        
    }
    
    
    func printSplashRow(passage: Passage)
    {
        //Wipe past data
        self.wipeRows()
        
        //Currently we don't need to do anything as is only an image.
        dispatch_sync(myCustomQueue,
            {
                //initialize the line
                //var i = Manager.sharedInstance.currentPassages.count - 1
                //TODO: Implement a proper solution for this.
                var i = 0
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
        Manager.sharedInstance.currentPassages.last?.selectChoiceAsTaken(choice)
        addPassageById((choice.passagePath?.nextPassageId)!)
        disableChoicesByPassage(choice)
    }
    
    func addPassageById(id: Int)
    {
        //var nextPassage = Manager.sharedInstance.getPassageFromStoryById(id)
        Manager.sharedInstance.sendNextPassageMessage(id, callback: { (callback: Passage) -> Void in
            var nextPassage = callback
           
                if (nextPassage.title == Constants.Names.NEXT_PASSAGE)
                {
                    let passageName = (Manager.sharedInstance.StoryVariables[Constants.Names.NEXT_PASSAGE]) as! String
                    
                    Manager.sharedInstance.sendNextPassageMessageByName(passageName,callback: { (callback: Passage) -> Void in
                        nextPassage = callback
                       
                    })
                    
                }
                
           self.addPassage(nextPassage)
            
        })
        
        
    }
    func addPassage(information: Any?)
    {
        if let passage = information as? Passage
        {
            Manager.sharedInstance.currentPassages.append(passage)
            Manager.sharedInstance.storeUserProgress()
            self.buildRow(passage)
        }
    }
    
    func MatchLine(line: String, callback: ()-> Void)
    {
        var results = Utils.RegexTest(Constants.RegexMacros.REGEX,input: line)
        
        if ((results != nil) && (results?.count > 0))
        {
            for result in results! as [NSTextCheckingResult]
            {
                let macro = (line as NSString).substringWithRange(result.rangeAtIndex(1))
                MacroAction(result,line: line, macro: macro)
            }
        }
        else
        {
            results = Utils.RegexTest(Constants.RegexMacros.FLOW_CONTROL_REGEX,input: line)
            
            if ((results != nil) && (results?.count > 0))
            {
                for result in results! as [NSTextCheckingResult]
                {
                    let macro = (line as NSString).substringWithRange(result.rangeAtIndex(1))
                    MacroAction(result,line: line, macro: macro)
                }
                
            }
            else
            {
                results = Utils.RegexTest(Constants.RegexMacros.NOTIFICATION_REGEX,input: line)
                
                if ((results != nil) && (results?.count > 0))
                {
                    for result in results! as [NSTextCheckingResult]
                    {
                        let macro = (line as NSString).substringWithRange(result.rangeAtIndex(1))
                        MacroAction(result,line: line, macro: macro)
                    }
                    
                }
                else
                {
                    print("line dont match", line)
                }
            }
        }
        callback()
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
                Utils.setStoryVariable(&Manager.sharedInstance.StoryVariables,key: key,value: value)
            }
            break;
        case Constants.Macros.AUDIO:
            if (isEnabledToMakeAction)
            {
                key = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            }//TODO: Play Audio
            break;
        case Constants.Macros.BUSY:
            if (isEnabledToMakeAction)
            {
                let timeInSec = (line as NSString).substringWithRange(result.rangeAtIndex(2))
               //TODO SEE RANGE AT INDEX OUT OF BOUNDS
                var busyMessage = (line as NSString).substringWithRange(result.rangeAtIndex(3))
                var notificationMessage = (line as NSString).substringWithRange(result.rangeAtIndex(4))
                
                if (busyMessage.length  <= 0)
                {
                    busyMessage = Constants.DefaultNotificationMessages.BUSY_MESSAGE
                }
                
                if (busyMessage.length  <= 0)
                {
                    notificationMessage = Constants.DefaultNotificationMessages.MESSAGE
                }
                Manager.sharedInstance.isEnabledToMakeAction = false
                Manager.sharedInstance.evaluateAllowed = false
                var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeInSec)!)
                
                // TODO: Mostrar mensaje [KOMRAD is busy]
                //TODO: SEND NOTIFICATION ( timeInSec)
                
                
                var seconds = Int(timeInSec)
                if(seconds == nil)
                {
                    seconds = 1
                }
                
                
                Manager.sharedInstance.sendNotificationMessage(notificationMessage, alertAction: "Open", deadlineInSeconds: seconds!, passage: currentPassage)
                
                
                
                /*let notification = KomradNotification(alertBody: notificationMessage, alertAction: "Open", deadlineInSeconds: seconds!, passage: currentPassage)
                NotificationService.ScheduleNotification(notification)*/
                
                dispatch_after(dispatchTime,dispatch_get_main_queue(),{
                    Manager.sharedInstance.isEnabledToMakeAction = true
                    Manager.sharedInstance.evaluateAllowed = true
                    
                    //TODO ocultar mensaje [KOMRAD is busy]
                    //TODO: Agregar passage y llamar al buildrow con este pasage y el lineIndex que llevaba.
                    
                });
            }
            break;
        case Constants.Macros.IF, Constants.Macros.ELSEIF:
            let variableName = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            let logicanSimbol = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(4))
            
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
            if (isEnabledToMakeAction)
            {
                value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
                Manager.sharedInstance.sendNextPassageMessageByName(value,callback: { (callback: Passage) -> Void in
                    self.addPassage(callback)
                    
                })
            }
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


