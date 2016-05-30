//
//  ChatInterfaceController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/2/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import WatchKit
import Foundation


class ChatInterfaceController: WKInterfaceController
{
    @IBOutlet var tableOutlet: WKInterfaceTable!
    var passages: [Passage_old]?
    
    override init()
    {
        super.init()
        
        self.passages = []
                
        //Singleton.sharedInstance.fillAllPassages()
        
        passages = [Singleton.sharedInstance.allPassages![23]]
        
        //Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages![25]
        Singleton.sharedInstance.chatPassages = passages
        
        
        Singleton.sharedInstance.chatTable = self.tableOutlet
        Singleton.sharedInstance.chatInterfaceController = self as WKInterfaceController
    }
    

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        if(context != nil)
        {
            self.passages = [context as! Passage_old]
            
            Singleton.sharedInstance.chatPassages = passages
        }
        
        // Configure interface objects here.
    }

    override func willActivate()
    {
        
        super.willActivate()
        
        var auxPassages: [Passage_old]?
        var auxTable: WKInterfaceTable?
        
        auxPassages = Singleton.sharedInstance.chatPassages
        auxTable = Singleton.sharedInstance.chatTable
        
        auxTable!.setNumberOfRows(auxPassages!.count, withRowType: "ChatRow")
        
        
       
        
        for(var i=0; i < auxPassages!.count;i++)
        {
            let row = auxTable!.rowControllerAtIndex(i) as? ChatRowController
            row?.initialize(auxPassages![i])
            row?.printLine(auxPassages![i], callback: (row?.printChoices)!)
            
                       
            //row?.printChoices(self.passages[i])
            
        }

        // This method is called when watch view controller is about to be visible to user
        auxTable!.scrollToRowAtIndex(auxPassages!.count)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
