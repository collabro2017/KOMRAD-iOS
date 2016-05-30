//
//  Manager.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/24/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class Manager: NSObject, WCSessionDelegate
{
    static let sharedInstance = Manager()
    
    var StoryVariables = Dictionary<String,AnyObject>()
    
    
    
    var isEnabledToMakeAction = true;
    var evaluateAllowed = true;
    var currentRows = [RowController]();
    var currentPassages = [Passage]();
    var terminalRunning = [Passage]();
    var chatRunning = [Passage]();
    var table: WKInterfaceTable?
    var story : Story?
    var mainInterface: MainInterfaceController?
    var passagePaths = [Path]();
    let events = EventManager();
    
    
    
    var session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    func startSession() {
        session?.delegate = self
        session?.activateSession()
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        deserializeNSData(messageData, replyHandler: replyHandler)
    }
    
    func deserializeNSData(messageData : NSData, replyHandler: (NSData) -> Void)
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
                    
                    Utils.setStoryVariables(&Manager.sharedInstance.StoryVariables,storyVariables:variables)
                    Manager.sharedInstance.initCurrent()
                    
                    self.events.trigger("buildTable", information: messageData);
                    replyHandler(NSData())
                    //self.buildTable()
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
                else
                {
                    var passage = myUnarchivedData as? Passage
                    if (passage != nil)
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.events.trigger("buildRow", information: passage);
                            
                            replyHandler(NSData())
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    override init()
    {
        super.init()
        print("Manager initialized");
        //initCurrent()
        /*passagePaths2 = [1,2,128]
        storePathsTaken()
        loadPathsTaken()*/
        startSession()
        
        
    }
    
    func initCurrent()
    {
        //TODO: Improve with proper logic.
        let chapter0 = self.story?.chapters![0]
        let chapter0Passages = (self.story?.chapters![0].passages![0])!
        
        //Add passages
        //self.currentPassages.append((self.story?.chapters![0].passages![0])!)
        getPassagesProgress()
    }
    
    
    
    
    //This methods setups currentPassages with the correct passages.
    func getPassagesProgress() //-> [Passage]?
    {
        var result = [Passage]();
        //TODO: UNCOMMENT
        //var progressArray = loadUserProgress()
        
        //TODO: For testing purposes only. Comment it later.
        /*if(Constants.GlobalVariables.RESET_PLAYER_PROGRESS == true)
        {*/
            currentPassages = [Passage]()
            var progressArray = [Int]()
            storeUserProgress()
        //}
        
        
        
        
        if(progressArray.count > 0)
        {
            for(var i = 0;i < progressArray.count;i++)
            {
                var aux = Manager.sharedInstance.sendNextPassageMessage(progressArray[i], callback: { (callback: Passage) -> Void in
                    self.currentPassages.append(callback)
                })
            }
        }
        else
        {
            currentPassages.append((self.story?.chapters![0].passages![0])!)
        }
    }
    
    func getPassageFromCurrentById(id: Int) -> Passage?
    {
        
        for passage in currentPassages
        {
            if(passage.id == id)
            {
                return passage
            }
        }
        return nil
    }
    
    
    func setAlreadyDisplayedByPassage(passage: Passage)
    {
        for(var i = 0;i < self.currentPassages.count;i++)
        {
            if(self.currentPassages[i] == passage)
            {
                self.currentPassages[i].alreadyDisplayed = true
            }
        }
    }
    
    
    func evaluateExpresion(variableName: String,logicalSimbol: String, value: String)
    {
        let variableValue = Utils.getStoryVariable(StoryVariables,key: variableName) as! String
        
        if(evaluateAllowed)
        {
            switch(logicalSimbol)
            {
            case Constants.ConditionalExpresions.GREATER_OR_EQUAL:
                isEnabledToMakeAction = (Int(variableValue) >= Int(value))
                break;
            case Constants.ConditionalExpresions.GREATER:
                isEnabledToMakeAction = (Int(variableValue) > Int(value))
                break;
            case Constants.ConditionalExpresions.EQUAL:
                isEnabledToMakeAction = (variableValue == value)
                break;
            case Constants.ConditionalExpresions.LESS:
                isEnabledToMakeAction = (Int(variableValue) < Int(value))
                break;
            case Constants.ConditionalExpresions.LESS_OR_EQUAL:
                isEnabledToMakeAction = (Int(variableName) <= Int(value))
                break;
            default:
                break;
            }
            evaluateAllowed = !isEnabledToMakeAction
            
        }
        else
        {
            isEnabledToMakeAction = false
        }
        
    }
    func ManageStoryVariables(choice:Choice)
    {
        let choiceStoryValue = choice.storyValue!
        let choiceStoryVariable = choice.storyVariable!
        //let storyVariable = Utils.getStoryVariable(StoryVariables,key: choiceStoryVariable.name) as? String
        let storyVariable = StoryVariables[choiceStoryVariable.name] as! String
        
        let results = Utils.RegexTest(Constants.RegexMacros.STORY_VALUE_SIGN,input: choiceStoryValue)
        
        if ((results != nil) && (results?.count > 0))
        {
            for result in results! as [NSTextCheckingResult]
            {
                let sign = (choiceStoryValue as NSString).substringWithRange(result.rangeAtIndex(1))
                let value = (choiceStoryValue as NSString).substringWithRange(result.rangeAtIndex(2))
                
                let storyVariableValue = Int(storyVariable)
                let choiceVariableValue = Int(value)
                
                let newValue = (sign == "+") ? (storyVariableValue! + choiceVariableValue!) : (storyVariableValue! - choiceVariableValue!)
                Utils.setStoryVariable(&StoryVariables,key: choiceStoryVariable.name, value: String(newValue))
            }
        }
        else
        {
            if (choiceStoryValue.length > 0)
            {
                Utils.setStoryVariable(&StoryVariables,key: choiceStoryVariable.name, value: choice.storyValue!)
                
            }
            
            
        }
        
    }
    
    //MARK: NSUserDefaults section
    
    func storePathsTaken()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(preparePathsArray(), forKey: "paths")
    }
    
    func loadPathsTaken()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var myarray = defaults.objectForKey("paths") as! NSArray
        print(myarray)
    }
    
    func preparePathsArray() -> NSArray
    {
        var auxArray = [Int]();
        for path in passagePaths
        {
            auxArray.append(path.passageId)
        }
        
        let pathArray  = auxArray as NSArray
        
        return pathArray
    }
    
    func storeUserProgress()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(prepareUserProgressArray(), forKey: "progress")
    }
    
    func prepareUserProgressArray() -> NSArray
    {
        var auxArray = [Int]();
        
        for passage in currentPassages
        {
            auxArray.append(passage.id)
        }
        
        let progressArray  = auxArray as NSArray
        
        return progressArray
    }
    
    func loadUserProgress() -> [Int]
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var myarray = [Int]()
        
        if(Utils.keyAlreadyExist("progress"))
        {
            myarray = defaults.objectForKey("progress") as! NSArray as! [Int]
            print(myarray)
        }
        else
        {
            
        }
        /*var myarray = defaults.objectForKey("progress") as! NSArray
        print(myarray)*/
        
        return myarray as! [Int]
    }
    
    func storeLineIndex(line: Int)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(line, forKey: "lineIndex")
    }
    
    func loadLineIndex() -> Int
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var lineIndex = defaults.integerForKey("lineIndex") as! Int
        
        return lineIndex
    }
    
    //MARK: Communication.
    func sendNotificationMessage(alertBody: String, alertAction: String, deadlineInSeconds: Int, passage: Passage?)
    {
        if((session?.reachable) != nil)
        {
            
            NSKeyedArchiver.setClassName("Passage", forClass: Passage.self)
            NSKeyedArchiver.setClassName("Choice", forClass: Choice.self)
            NSKeyedArchiver.setClassName("Line", forClass: Line.self)
            NSKeyedArchiver.setClassName("Tag", forClass: Tag.self)
            NSKeyedArchiver.setClassName("Path", forClass: Path.self)
            NSKeyedArchiver.setClassName("Chapter", forClass: Chapter.self)
            NSKeyedArchiver.setClassName("StoryVariable", forClass: StoryVariable.self)
            
            
            //Create a dictionary with all the values
            var dic = Dictionary<String, AnyObject>()
            dic["alertBody"] = alertBody
            dic["alertAction"] = alertAction
            dic["deadlineInSeconds"] = deadlineInSeconds
            dic["passage"] = passage
            //Archive the dictionary to send it
            let dicData : NSData = NSKeyedArchiver.archivedDataWithRootObject(dic)
            print("sending notification message")
            //Send it!
            
            session!.sendMessageData(dicData, replyHandler: { (replyHandler: NSData) -> Void in
                
                
                //self.SendChapters(self.stories[0].chapters![0])
                
                
                }, errorHandler: { (errorHandler: NSError) -> Void in
                    print("Error:  ", errorHandler)
                    //self.contentLoaded(true)
            })
        }
    }
    
    //MARK Communicate with iOS
    func sendNextPassageMessage(var id: Int, callback: ((Passage) -> Void))
    {
        
        let data = NSData(bytes: &id, length: sizeof(Int))
        
        print("sending notification message")
        //Send it!
        session!.sendMessageData(data, replyHandler: { (replyHandler: NSData) -> Void in
            
            
            //TODO: UNSERIALIZED PASSAGE
            var passage = self.NSDataToPassage(replyHandler)
            if (passage != nil)
            {
                callback(passage!)
            }
            else
            {
                print("NSDataToPassage return nil")
            }
            //self.SendChapters(self.stories[0].chapters![0])
            /*var convertedStr = NSString(data: replyHandler, encoding: NSUTF8StringEncoding)
            print(convertedStr)*/
            
            }, errorHandler: { (errorHandler: NSError) -> Void in
                print("Error:  ", errorHandler)
                //self.contentLoaded(true)
        })
    }
    func sendNextPassageMessageByName(var name: String, callback: ((Passage) -> Void))
    {
        
        
        let data = name.dataUsingEncoding(NSUTF8StringEncoding)
        print("sending notification message")
        //Send it!
        session!.sendMessageData(data!, replyHandler: { (replyHandler: NSData) -> Void in
            
            
            //TODO: UNSERIALIZED PASSAGE
            var passage = self.NSDataToPassage(replyHandler)
            if (passage != nil)
            {
                callback(passage!)
            }
            else
            {
                print("NSDataToPassage return nil")
            }
            //self.SendChapters(self.stories[0].chapters![0])
            /*var convertedStr = NSString(data: replyHandler, encoding: NSUTF8StringEncoding)
            print(convertedStr)*/
            
            }, errorHandler: { (errorHandler: NSError) -> Void in
                print("Error:  ", errorHandler)
                //self.contentLoaded(true)
        })
    }
    
    
    
    
    func NSDataToPassage(messageData: NSData) -> Passage?
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
        return myUnarchivedData as? Passage ?? nil
        
    }
    
    
}



