//
//  WatchSessionManager.swift
//  KOMRAD
//
//  Created by DiegoPC on 10/10/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import WatchConnectivity
@available(iOS 9.0, *)
class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    let events = EventManager();
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session where session.paired && session.watchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activateSession()
    }
}

// MARK: Interactive Messaging
@available(iOS 9.0, *)
extension WatchSessionManager {
    
    // Live messaging! App has to be reachable
    private var validReachableSession: WCSession? {
        if let session = validSession where session.reachable {
            return session
        }
        return nil
    }
    
    // Sender
    func sendMessage(message: [String : AnyObject],
        replyHandler: (([String : AnyObject]) -> Void)? = nil,
        errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func sendMessageData(data: NSData,
        replyHandler: ((NSData) -> Void)? = nil,
        errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        
        deserializeNSData(messageData, replyHandler: replyHandler)
        
    }
    
    
    
    
    func deserializeNSData(messageData : NSData , replyHandler: (NSData) -> Void)
    {
        var nextPassage : Passage?
        
        var id = 0
        messageData.getBytes(&id, length: sizeof(NSInteger))
        
        if (id > 20000)
        {
            var result = NSString(data: messageData, encoding:NSUTF8StringEncoding) as String?
            if (result != nil)
            {
                nextPassage = ParseUtils.getPassageByName(result!)
                print("STRING!!")
            }
        }
        else
        {
            
            print("Int")
            
            if (id > -1)
            {
                print("The message was received and Id is: \(id)")
                /* let response = "REPLY HAS ARRIVED"
                let data = response.dataUsingEncoding(NSUTF8StringEncoding)
                replyHandler(data!)*/
                //TODO: Send array of passages as a reply.
                
                nextPassage = ParseUtils.getPassageByPassageId(id)
            }
        }
        
                NSKeyedArchiver.setClassName("Passage", forClass: Passage.self)
                NSKeyedArchiver.setClassName("Choice", forClass: Choice.self)
                NSKeyedArchiver.setClassName("Line", forClass: Line.self)
                NSKeyedArchiver.setClassName("Tag", forClass: Tag.self)
                NSKeyedArchiver.setClassName("Path", forClass: Path.self)
                NSKeyedArchiver.setClassName("Chapter", forClass: Chapter.self)
                NSKeyedArchiver.setClassName("StoryVariable", forClass: StoryVariable.self)
                
                
                let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(nextPassage!)
                
                replyHandler(data)
                
            
        
        
    }
    
}

