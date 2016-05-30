//
//  NotificationService.swift
//  KOMRAD
//
//  Created by Trick Dev on 10/6/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation

class NotificationService
{
    static func ScheduleNotification(notification: KomradNotification)
    {
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func createNotification(alertBody: String, alertAction: String, deadlineInSeconds: Int, passage: Passage?)
    {
        let notification = KomradNotification(alertBody: alertBody, alertAction: alertAction, deadlineInSeconds: deadlineInSeconds, passage: passage)
        NotificationService.ScheduleNotification(notification)
    }
}