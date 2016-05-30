//
//  KomradNotification.swift
//  KOMRAD
//
//  Created by Trick Dev on 10/6/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation

class KomradNotification: UILocalNotification
{   
    init(alertBody: String, alertAction: String, deadlineInSeconds: Int, passage: Passage?)
    {
        super.init()
        
        self.alertBody = alertBody
        self.alertAction = alertAction
        
        /*var deadlineInSeconds : Int
        deadlineInSeconds = 0*/
        
        //TODO: Check later why I can't just call a method from inside this init.
        /*deadlineInSeconds = minutesToSeconds(deadlineInMinutes)*/
  
        //deadlineInSeconds = deadlineInMinutes * 5
        
        let timeInterval = NSTimeInterval(deadlineInSeconds)
        
        //Passage stuff
        NSKeyedArchiver.setClassName("Passage", forClass: Passage.self)
        
        let applicationData: NSData  = NSKeyedArchiver.archivedDataWithRootObject(passage!)
        
        
        
        self.userInfo = ["PASSAGE": applicationData]
        
        self.fireDate = NSDate(timeIntervalSinceNow: timeInterval)        
    }
    
    
    
    /*func minutesToSeconds(minutes: Int) -> Int
    {
        print(minutes)
        return (minutes * 60)
    }*/
   

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}