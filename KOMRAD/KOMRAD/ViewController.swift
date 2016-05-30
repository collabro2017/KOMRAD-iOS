//
//  ViewController.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/24/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import UIKit
import Parse
import WatchConnectivity
import SystemConfiguration
import AudioToolbox
import AVFoundation

@available(iOS 9.0, *)
class ViewController: UIViewController, WCSessionDelegate, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var audioKOMRADPlayer: AVAudioPlayer!
    
    var timerLight = NSTimer()
    let timeLights: NSTimeInterval = 19
    
    var stories = [Story]();
    var storyVersion = 0
    var chapterIndex = -1
    var reachability = Reachability();

    @IBOutlet weak var lblLoadingContent: UILabel!
    
    @IBOutlet var viewTitleScreen: UIView!
    @IBOutlet weak var imgKOMRADsingle: UIImageView!
    @IBOutlet weak var imgDarkness: UIView!
    @IBOutlet weak var imgKOMRAD: UIImageView!
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer = nil
    }

    func audioKOMRADPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        audioKOMRADPlayer = nil
        //last to finish so shut off timer
        timerLight.invalidate()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        WatchSessionManager.sharedManager.startSession()
       // loadVersion()

        //play intro music and KOMRAD talking
        let soundURL: NSURL = NSBundle.mainBundle().URLForResource("SouloftheMachine", withExtension: "caf")!
        audioPlayer = try! AVAudioPlayer(contentsOfURL: soundURL)
        audioPlayer.delegate = self
        
        let soundKOMRADURL: NSURL = NSBundle.mainBundle().URLForResource("KspeaksIntro", withExtension: "caf")!
        audioKOMRADPlayer = try! AVAudioPlayer(contentsOfURL: soundKOMRADURL)
        audioKOMRADPlayer.delegate = self
        audioKOMRADPlayer.meteringEnabled = true

        audioPlayer.play()
        audioKOMRADPlayer.play()
       
        //start timer to lights out effect
        timerLight = NSTimer.scheduledTimerWithTimeInterval(timeLights, target: self, selector: "firstLightsOut", userInfo: nil, repeats: false)
        
        sendMessage(contentLoaded)
        
      //  WatchSessionManager.sharedManager.events.listenTo("sendPassage", action: self.sendPassage);
        
    }
    
    // ---------- LIGHTING ANIMATION ---------------
    
    func firstLightsOut()
    {
        lightsOut()
        timerLight = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "modulateGlow", userInfo: nil, repeats: true)
    }
    
    func lightsOut()
    {
        //"turn off the lights" by swapping title image and darkening background image
        imgDarkness.hidden = false
        imgKOMRAD.image = UIImage(named: "KOMRADdark")
        imgKOMRADsingle.image = UIImage(named: "KOMRADsingledark")
        viewTitleScreen.bringSubviewToFront(imgKOMRAD)
        viewTitleScreen.bringSubviewToFront(imgKOMRADsingle)
    }
    
    func modulateGlow()
    {
    
        //we will increase/decrease glow based on current metering
        audioKOMRADPlayer.updateMeters()
        let threshhold: Float = -16.0  //MAGIC NUMBER based on current soundfile
        let pwr: Float = audioKOMRADPlayer.averagePowerForChannel(0) //only channel 0 because K's voice is essentially mono
        if (pwr > threshhold) {
            //turn on glow--ideally this would be an animated fade in/out
            imgKOMRAD.image =  UIImage(named: "KOMRADdarkglow")
            imgKOMRADsingle.image = UIImage(named: "KOMRADsingledarkglow")
            //viewTitleScreen.bringSubviewToFront(imgKOMRAD)
            //viewTitleScreen.bringSubviewToFront(imgKOMRADsingle)
        }
        else { lightsOut() }
        
    }

    func lightsOn()
    {
        //"turn back on the lights" by swapping title image and darkening background image
        imgDarkness.hidden = true
        imgKOMRAD.image = UIImage(named: "KOMRADlight")
        imgKOMRADsingle.image = UIImage(named: "KOMRADsinglelight")
        viewTitleScreen.bringSubviewToFront(imgKOMRAD)
        viewTitleScreen.bringSubviewToFront(imgKOMRADsingle)
    }
    
    // ------------ CONTENT LOADING ---------------
    
    func contentLoaded(done : Bool)
    {
        if(done)
        {
            lblLoadingContent.text = "Complete"
        }
        else
        {
            lblLoadingContent.text = "Kinda failed"
        }
    }
    
    func loadContent() -> [Story]
    {
        var stories = [Story]()
        var pFStories : [PFStory]?
        let version = loadVersion()
        //  var includeKeys = ["passage","passagePath","passagePath.lastPassage","passagePath.passage","passagePath.nextPassage","storyVariable", "choice"]
        var fromLocal = true
        
        //Only works on device.
        if(Reachability.isConnectedToNetwork() == true)
        {
            var DBStories : [PFStory] = ParseService.CheckVersion(false)
            var DBVersion = DBStories[0].version
            //var LocalStories : [PFStory] = ParseService.CheckVersion(true)
            
           // if(LocalStories.count > 0)
           // {
                //var LocalVersion = LocalStories[0].version
                
                if(DBVersion > storyVersion)
                {
                    //pFStories = DBStories
                    fromLocal = false
                    storyVersion = DBVersion
                    storeVersion()
                    ParseUtils.getAll()
                }
                else
                {
                    //pFStories = LocalStories
                    fromLocal = true
                }
         /*   }
            else
            {
                pFStories = LocalStories
                fromLocal = true
            }*/
            
            
        }
        
        //TODO: CHange with fromLocal and delete getall below
        
        //ParseUtils.getAll()
        var story = ParseUtils.getStory(fromLocal)
        
        stories.append(story)
        return stories
    }
    
    
    
    
    func sendMessage(callback: (done : Bool)-> Void)
    {
        
        
        /* LOAD PARSE CONTENT AND CONVERT TO PASSAGE DOMAIN */
        stories = loadContent();
        
        
        lblLoadingContent.text = "Preparing to Send Data to WatchKit"
        /* Serialize the Passage array into NSDATA */
        NSKeyedArchiver.setClassName("Passage", forClass: Passage.self)
        NSKeyedArchiver.setClassName("Choice", forClass: Choice.self)
        NSKeyedArchiver.setClassName("Line", forClass: Line.self)
        NSKeyedArchiver.setClassName("Tag", forClass: Tag.self)
        NSKeyedArchiver.setClassName("Path", forClass: Path.self)
        NSKeyedArchiver.setClassName("Story", forClass: Story.self)
        NSKeyedArchiver.setClassName("Chapter", forClass: Chapter.self)
        NSKeyedArchiver.setClassName("StoryVariable", forClass: StoryVariable.self)
        
        
        let auxStory = Story(id: self.stories[0].id, author: self.stories[0].author, title: self.stories[0].title , subtitle: self.stories[0].subtitle, version: self.stories[0].version)
        
        
        let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(auxStory)
        lblLoadingContent.text = "Sending Story to watch"
        // Send message with NSDATA to Watchkit extension
        WatchSessionManager.sharedManager.sendMessageData(applicationData, replyHandler: { (replyHandler: NSData) -> Void in
            self.lblLoadingContent.text = "Sending chapters"
            print("sending chapters")
            self.SendChapters(self.stories[0].chapters![0])
            }, errorHandler: { (errorHandler: NSError) -> Void in
                var errmsg = "Error: " + String(errorHandler)
                print(errmsg)
                self.lblLoadingContent.text = errmsg
                self.contentLoaded(true)
        })
        
    }
    
    func SendChapters(chapter: Chapter)
    {
        self.chapterIndex++
        if (chapterIndex >= stories[0].chapters!.count)
        {
            //If all chapters are sent, send the variables
            let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(self.stories[0].storyVariables!)
            self.lblLoadingContent.text = "Sending variables"
            // Send message with NSDATA to Watchkit extension
            WatchSessionManager.sharedManager.sendMessageData(applicationData, replyHandler: { (replyHandler: NSData) -> Void in
                print("Llegaron las  variables : ")
                
                self.contentLoaded(true)
                
                
                }, errorHandler: { (errorHandler: NSError) -> Void in
                    print("Error:  ", errorHandler)
                    self.contentLoaded(true)
            })
            
        }
        else // if has chapter to send
        {
            let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(chapter)
            print("Sending chapter: ",self.stories[0].chapters![self.chapterIndex].name)
            // Send message with NSDATA to Watchkit extension
            WatchSessionManager.sharedManager.sendMessageData(applicationData, replyHandler: { (replyHandler: NSData) -> Void in
                //print("Llego Chapter: ",self.stories[0].chapters![self.chapterIndex-1].name)
                
                self.SendChapters(self.stories[0].chapters![0])
                
                }, errorHandler: { (errorHandler: NSError) -> Void in
                    print("Error:  ", errorHandler)
                    self.contentLoaded(true)
            })
        }
        
    }
    
    
    
   @IBAction func TestNotification(sender: AnyObject)
    {
        /*
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "This is a test!" // text that will be displayed in the notification
        notification.alertAction = "Open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        //notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.fireDate = NSDate(timeIntervalSinceNow: 15)

        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        //notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        */

        print("about to create a notification")
        
        let passage = Passage(id: 666, title: "tessssst")
        
        let notification = KomradNotification(alertBody: "TEST NOTIFICATION", alertAction: "Open", deadlineInSeconds: 1, passage: passage)
        print("notification created")
        NotificationService.ScheduleNotification(notification)
        print("notification scheduled")

    }

    
    
    //MARK: Version Control
    func storeVersion()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(storyVersion, forKey: "storyVersion")
        defaults.synchronize()
    }
    
    func loadVersion() -> Int
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var auxVersion = defaults.integerForKey("storyVersion2")
        
        storyVersion = auxVersion
        
        print("Story Version: \(auxVersion)")
        
        return auxVersion;
    }
    
    
    
    
    
  /*  func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        
        deserializeNSData(messageData, replyHandler: replyHandler)
        
    }*/
  /*  func sendPassage(information: Any){
    
        var dictionary = information as! Dictionary<String, NSData>
        var data : NSData = dictionary["replyHandler"]!
        deserializeNSData(messageData: dictionary["messageData"]!, replyHandler: (data) -> Void)
    
    }*/    
    
    }
