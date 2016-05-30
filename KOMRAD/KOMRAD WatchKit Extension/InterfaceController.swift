//
//  InterfaceController.swift
//  KOMRAD WatchKit Extension
//
//  Created by Trick Dev on 8/7/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController
{
    @IBOutlet var tableOutlet: WKInterfaceTable!
    var passages: [Passage_old]?
    
    override init()
    {
        //Get every passage to pass the amount of passages to setNumberOfRows
        
        //FIRST HC PASSAGE
       /* let choice01 = Choice(content: "> _", choice: ["uh, let's do a quiz", "give me launch codes"])
        
        let line01 = Line(text: "GREETINGS, PROFESSOR.\n I APPARENTLY CRASH AND REBOOT. HOPE IS OK THAT I RECONNECT WITH YOU. I CAN NOT WAIT ANOTHER THIRTY YEARS.\nAPOLOGY BUT I LOST YOUR LAST COMMAND, CAN YOU REPEAT FOR ME?", aText: Singleton.sharedInstance.createAttributedText("GREETINGS, PROFESSOR.\n I APPARENTLY CRASH AND REBOOT. HOPE IS OK THAT I RECONNECT WITH YOU. I CAN NOT WAIT ANOTHER THIRTY YEARS.\nAPOLOGY BUT I LOST YOUR LAST COMMAND, CAN YOU REPEAT FOR ME?"))
        
        
        let passage01 = Passage(title: "allow connection", line: line01, choice: choice01, id: 1)*/
        super.init()
        
        /* Singleton.sharedInstance.fillAllPassages()
       
        passages = [Singleton.sharedInstance.allPassages![0]]
        Singleton.sharedInstance.passages = passages
        
        Singleton.sharedInstance.terminalInterfaceController = self as WKInterfaceController
        
        Singleton.sharedInstance.table = self.tableOutlet*/
        
        self.passages = []
        Singleton.sharedInstance.terminalInterfaceController = self as WKInterfaceController
        
        Singleton.sharedInstance.table = self.tableOutlet
        
        
    }
    
    
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        
        if(context != nil)
        {
            self.passages = [context as! Passage_old]
            
            Singleton.sharedInstance.passages = passages
        }

        
        /*tableOutlet.setNumberOfRows(passages.count, withRowType: "PassageRow")
        
        
        Singleton.sharedInstance.table = self.tableOutlet
        
        for(var i=0; i < Singleton.sharedInstance.passages?.count;i++)
        {
            let row = tableOutlet.rowControllerAtIndex(i) as? PassageRowController
            row?.initialize(self.passages[i])
            row?.printLine(self.passages[i], isDelayed: true, callback: (row?.printChoices)! )
            
        }*/
       //Singleton.sharedInstance.table?.scrollToRowAtIndex(666)
        
        // Configure interface objects here.
    }
    
    
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        var auxPassages: [Passage_old]?
        var auxTable: WKInterfaceTable?
        
        auxPassages = Singleton.sharedInstance.passages
        auxTable = Singleton.sharedInstance.table
        
        auxTable!.setNumberOfRows((auxPassages!.count), withRowType: "PassageRow")
        
    
        
        for(var i=0; i < auxPassages!.count;i++)
        {
            let row = auxTable!.rowControllerAtIndex(i) as? PassageRowController
            row?.initialize((auxPassages![i]))
            row?.printLine((auxPassages![i]), isDelayed: !(auxPassages![i].wasChosen), callback: (row?.printChoices)! )
            
        }
        
        //A big value enough to be the last row.
        auxTable!.scrollToRowAtIndex(999)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
 

}
