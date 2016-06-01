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
    @IBOutlet var loadingView: UIView!
    
    
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
        dispatch_async(dispatch_get_main_queue()) {
            if(done) {
                self.lblLoadingContent.text = "Complete"
            }
            else {
                self.lblLoadingContent.text = "Kinda failed"
            }
        }
    }
    
    func loadContent(onSucess onSucess: (data: [Story]) -> Void, onFailure: (error: String) -> Void)
    {
        loadVersion()
        var stories = [Story]()
        
        //Check for internet connection
        if(Reachability.isConnectedToNetwork() == true)
        {
            ParseService.checkVersion(fromLocal: false, onSuccess: { (data) in
                let DBStories = data
                let DBVersion = DBStories[0].version
                
                if DBVersion > self.storyVersion { //Parse has updated data.
                    
                    //Remove the older data from Local Database
                    ParseUtils.removeAllObjectsFromLocalDatabase({ (status) in
                        if status {
                            //fetch updated data from Parse and saved it in local DB
                            ParseUtils.getAllAndSaveInDatabase({ (success) in
                                if success {
                                    self.storyVersion = DBVersion
                                    self.storeVersion()
                                    
                                    //Fetch Story from local Datastore
                                    ParseUtils.getStoryFromLocalDB({ (data) in
                                        //Run the success block
                                        stories.append(data!)
                                        onSucess(data: stories)
                                        
                                    }, onFailure: { (error) in
                                        onFailure(error: error.localizedDescription)
                                    })
                                }
                                else {
                                    onFailure(error: "Unable to fetch data.")
                                }
                            })
                        }
                        else {
                            onFailure(error: "Unable to delete data.")
                        }
                    })
                }
                else { //Fetch the data from local Database.                    
                    ParseUtils.getStoryFromLocalDB({ (data) in
                        //Run the success block
                        stories.append(data!)
                        onSucess(data: stories)
                        
                        }, onFailure: { (error) in
                            onFailure(error: error.localizedDescription)
                    })
                }
            },
            onFailure: { (error) in
                print(error.localizedDescription)
            })
        }
        else {
            onFailure(error: "No internet connection.")
        }
    }
    
    func sendMessage(callback: (done : Bool)-> Void)
    {
        
        self.loadContent(onSucess: { (data) in
            self.loadingView.removeFromSuperview()
            
            self.stories = data
            self.lblLoadingContent.text = "Preparing to Send Data to WatchKit"
            self.sendStoryToWatchApp()
            
        }, onFailure: { (error) in
            self.showAlertViewWithRetryButton(error)
        })
    }
    
    func sendStoryToWatchApp() {
        /* Serialize the Passage array into NSDATA */
        NSKeyedArchiver.setClassName("Passage", forClass: Passage.self)
        NSKeyedArchiver.setClassName("Choice", forClass: Choice.self)
        NSKeyedArchiver.setClassName("Line", forClass: Line.self)
        NSKeyedArchiver.setClassName("Tag", forClass: Tag.self)
        NSKeyedArchiver.setClassName("Path", forClass: Path.self)
        NSKeyedArchiver.setClassName("Story", forClass: Story.self)
        NSKeyedArchiver.setClassName("Chapter", forClass: Chapter.self)
        NSKeyedArchiver.setClassName("StoryVariable", forClass: StoryVariable.self)
        
        //Get the story
        let auxStory = Story(id: self.stories[0].id, author: self.stories[0].author, title: self.stories[0].title , subtitle: self.stories[0].subtitle, version: self.stories[0].version)
        
        let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(auxStory)
        dispatch_async(dispatch_get_main_queue(), {
            self.lblLoadingContent.text = "Sending Story to watch"
        })
        
        // Send message with NSDATA to Watchkit extension
        WatchSessionManager.sharedManager.sendMessageData(applicationData, replyHandler: { (replyHandler: NSData) -> Void in
            
            print("sending chapters")
            dispatch_async(dispatch_get_main_queue(), {
                self.lblLoadingContent.text = "Sending chapters"
            })
            self.SendChapters(self.stories[0].chapters![0])
            
            }, errorHandler: { (errorHandler: NSError) -> Void in
                
                let errmsg = "Error: " + String(errorHandler)
                print(errmsg)
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblLoadingContent.text = errmsg
                })
                self.contentLoaded(false)
                
            }, onFailure: {
                self.showAlertViewForWatchWithRetryButton("This game is designed for Apple Watch app. Please open the Watch app to play this game.")
        })
    }
    
    func SendChapters(chapter: Chapter)
    {
        self.chapterIndex++
        if (chapterIndex >= stories[0].chapters!.count)
        {
            //If all chapters are sent, send the variables
            let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(self.stories[0].storyVariables!)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.lblLoadingContent.text = "Sending variables"
            })
            
            // Send message with NSDATA to Watchkit extension
            WatchSessionManager.sharedManager.sendMessageData(applicationData, replyHandler: { (replyHandler: NSData) -> Void in
                print("Llegaron las  variables : ")
                
                self.contentLoaded(true)
                
                
                }, errorHandler: { (errorHandler: NSError) -> Void in
                    print("Error:  ", errorHandler)
                    self.contentLoaded(true)
                }, onFailure: {
                    self.showAlertViewForWatchWithRetryButton("This game is designed for Apple Watch app. Please open the Watch app to play this game.")
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
                }, onFailure: {
                    self.showAlertViewForWatchWithRetryButton("This game is designed for Apple Watch app. Please open the Watch app to play this game.")
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
        
        var auxVersion = defaults.integerForKey("storyVersion")
        
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
    
    func showAlertViewWithRetryButton(message: String) {
        let alertView = UIAlertController(title: "KOMRAD", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "Re-try", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.sendMessage(self.contentLoaded)
        }))
        alertView.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
            exit(0)
        }))
        self.showViewController(alertView, sender: nil)
    }
    
    func showAlertViewForWatchWithRetryButton(message: String) {
        let alertView = UIAlertController(title: "KOMRAD", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.sendStoryToWatchApp()
        }))
        alertView.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
            exit(0)
        }))
        self.showViewController(alertView, sender: nil)
    }
    
}
