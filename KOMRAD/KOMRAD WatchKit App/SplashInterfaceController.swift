//
//  SplashInterfaceController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/11/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SplashInterfaceController: WKInterfaceController, WCSessionDelegate
{
    @IBOutlet var ImageButtonOutlet: WKInterfaceButton!
    var session: WCSession!
    override init()
    {
        super.init()
        
        var newPassages: [Passage]?
        let appGroupID = "group.com.SENTIENTPLAY.KOMRADGROUP"
       let defaults = NSUserDefaults(suiteName: appGroupID)
        //let passagesData = defaults?.stringForKey("Passages")
        
        //print(passagesData)
      /*  let passagesData = defaults!.objectForKey("Passages") as? NSData
        if let placesData = passagesData {
            newPassages = NSKeyedUnarchiver.unarchiveObjectWithData(placesData) as? [Passage]
            if (newPassages != nil)
            {
                print("items: ",newPassages)
            }
            else
            {
                print("no trajo nada passages")
            }
        }
        else
        {
            print("no trajo nada")
        }*/

        
        
          //     Singleton.sharedInstance.splashInterfaceController = self as WKInterfaceController
        
        //Singleton.sharedInstance.fillAllPassages()
        //Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages![25]
    }
    
    @IBAction func ImagePressed()
    {
        var nextPassage: Passage_old?
        nextPassage = Singleton.sharedInstance.nextPassage
        WKInterfaceDevice.currentDevice().playHaptic(.Notification)
        
        switch(nextPassage!.id)
        {
        case 25:
        Singleton.sharedInstance.splashInterfaceController?.pushControllerWithName("Chat", context: nextPassage)
            break
            
        default:
            print("")
            break
        }
    }
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        if(context != nil)
        {
            //self.passages = [context as! Passage]
            
            //Singleton.sharedInstance.chatPassages = passages
        }
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        if(WCSession.isSupported())
        {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    //Swift
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
           
            Singleton.sharedInstance.story = stories[0];
        }

    }
      
  
}
