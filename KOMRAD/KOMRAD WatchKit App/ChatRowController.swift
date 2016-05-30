//
//  ChatRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 9/2/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation
import WatchKit

class ChatRowController: NSObject
{
    @IBOutlet var LabelOutlet: WKInterfaceLabel!
    @IBOutlet var LineGroupOutlet: WKInterfaceGroup!
    
    @IBOutlet var Choice01ButtonOutlet: WKInterfaceButton!
    @IBOutlet var Choice02ButttonOutlet: WKInterfaceButton!
    
    @IBOutlet var Choice01ButtonGroup: WKInterfaceGroup!
    @IBOutlet var Choice02ButtonGroup: WKInterfaceGroup!
    
    @IBOutlet var BubbleEffect: WKInterfaceGroup!
    @IBOutlet var MessageOutlet: WKInterfaceButton!
    @IBOutlet var MessageGroupOutlet: WKInterfaceGroup!
    
    var passageData : Passage_old?
    
    func initialize(passage: Passage_old)
    {
        self.passageData = passage
        
        
       
        //Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages?[19]
        
        
        Singleton.sharedInstance.setNextPassage(passage)
        Singleton.sharedInstance.setNextDestination(passage)
        
        self.Choice01ButtonGroup.setHidden(true)
        self.Choice02ButtonGroup.setHidden(true)
        self.BubbleEffect.setHidden(true)
        
        
        

        //self.MessageGroupOutlet.setHidden(false)
    }
    
    func printLine(passage: Passage_old, callback: (Passage_old, Bool, Bool, Bool)-> Void)
    {
        /*let choice01 = Bool(passage.choice01Selected)
        let choice02 = Bool(passage.choice02Selected)
        let wasChosen = Bool(passage.wasChosen)
       
        if(passage.line != nil)
        {
   
            self.MessageGroupOutlet.setHidden(true)
            /*self.Choice01ButtonOutlet.setHidden(false)
            self.Choice02ButttonOutlet.setHidden(false)*/
            self.LineGroupOutlet.setHidden(false)
            self.BubbleEffect.setHidden(false)
            if(passage.line?.isSystemMessage == true)
            {
                self.LineGroupOutlet.setBackgroundColor(UIColor.blackColor())
                self.LineGroupOutlet.setCornerRadius(0.0)
                self.BubbleEffect.setHidden(true)
                self.LabelOutlet.setAttributedText(passage.line?.aText)
                callback(passage, choice01, choice02,wasChosen)
            }
            else
            {
                print("not a system message")
                if(!passage.wasChosen)
                {
                    var multiplier = Double((passage.line?.aText?.length)!)
                    var delay: Double = (0.5+(0.03 * multiplier)) * Double(NSEC_PER_SEC)
                    var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    let content = NSAttributedString(string: "...")
                    self.LabelOutlet.setAttributedText(content)
                    
                    self.BubbleEffect.setHidden(false)
                    
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(),
                        {
                            self.LabelOutlet.setAttributedText(passage.line?.aText)
                            
                            callback(passage, choice01, choice02,wasChosen)
                    })
                }
                else
                {
                    self.BubbleEffect.setHidden(true)
                    self.LabelOutlet.setAttributedText(passage.line?.aText)
                    callback(passage, choice01, choice02,wasChosen)
                }
                
            
            }
            
        }
        else
        {
           self.MessageGroupOutlet.setHidden(false)

            self.Choice01ButtonGroup.setHidden(true)
            self.Choice02ButtonGroup.setHidden(true)
            self.LineGroupOutlet.setHidden(true)
            self.BubbleEffect.setHidden(true)
           callback(passage, choice01, choice02,wasChosen)
        }*/
        
    }

    
    func printChoices(passage: Passage_old, choice01: Bool, choice02: Bool, wasChosen: Bool)
    {
       /* var choice01Title = ""
        var choice02Title = ""
        
        var amountOfPassages = Int((Singleton.sharedInstance.chatPassages?.count)!)
        
        dispatch_async(dispatch_get_main_queue())
            {
                Singleton.sharedInstance.chatTable?.scrollToRowAtIndex(amountOfPassages - 1)
        }

        
        
        
        if ((passage.choice != nil) && (passage.choice?.choice != nil))
        {
            
            if(!wasChosen)
            {
                if((passage.choice?.choice?.count > 0))
                {
                    if(passage.line != nil)
                    {
                        self.Choice01ButtonGroup.setHidden(false)
                        choice01Title = (passage.choice?.choice?[0])!
                        if (passage.choice?.choice?.count > 1)
                        {
                            choice02Title = (passage.choice?.choice?[1])!
                            self.Choice02ButtonGroup.setHidden(false)
                        }
                        else
                        {
                            //fix when there's only one choice
                            self.Choice02ButtonGroup.setHidden(true)
                        }
                        
                        
                    }
                    else
                    {
                        self.MessageGroupOutlet.setHidden(false)
                        self.Choice01ButtonGroup.setHidden(true)
                        self.Choice02ButtonGroup.setHidden(true)
                        self.LineGroupOutlet.setHidden(true)
                    }
                }
                
            }
            else
            {
                if((passage.choice?.choice?.count > 0))
                {
                    self.Choice01ButtonGroup.setHidden(!choice01)
                    choice01Title = (passage.choice?.choice?[0])!
                    if (passage.choice?.choice?.count > 1)
                    {
                        self.Choice02ButtonGroup.setHidden(!choice02)
                        choice02Title = (passage.choice?.choice?[1])!
                    }
                    else
                    {
                        //fix when there's only one choice
                        self.Choice02ButtonGroup.setHidden(true)
                    }
                }
            }
            
            
        }
        else
        {
            if(!wasChosen)
            {
                //DELAY BEFORE SHOWING THE NEXT PASSAGE WITHOUT CHOICES
                var delay: Double = (1.0) * Double(NSEC_PER_SEC)
                var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(),
                    {
                        self.displayPassageWithoutChoice()
                        self.Choice01ButtonGroup.setHidden(true)
                        self.Choice02ButtonGroup.setHidden(true)

                })

                
               
            }
            else
            {
                self.Choice01ButtonGroup.setHidden(true)
                self.Choice02ButtonGroup.setHidden(true)
            }
        }
        
        self.Choice01ButtonOutlet.setEnabled(!wasChosen)
        self.Choice02ButttonOutlet.setEnabled(!wasChosen)
        self.Choice01ButtonOutlet.setTitle(choice01Title)
        self.Choice02ButttonOutlet.setTitle(choice02Title)
        
        */
        
    }
    
    func initializeCellForTable()
    {
        var amountOfPassages = Int((Singleton.sharedInstance.chatPassages?.count)!)

        for(var i=0; i < (amountOfPassages);i++)
        {         
            
            let row = Singleton.sharedInstance.chatTable?.rowControllerAtIndex(i) as? ChatRowController
            row?.initialize((Singleton.sharedInstance.chatPassages?[i])!)
            row?.printLine((Singleton.sharedInstance.chatPassages?[i])!, callback: (row?.printChoices)!)
            
        }
        
      
        
        /*let row = Singleton.sharedInstance.chatTable?.rowControllerAtIndex(amountOfPassages) as? ChatRowController
        row?.initialize((Singleton.sharedInstance.chatPassages?[amountOfPassages])!)
        row?.printLine((Singleton.sharedInstance.chatPassages?[amountOfPassages])!, callback: (row?.printChoices)!)*/
        
        
    }
    
    
  
    
    
    func displayPassageWithoutChoice()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForChatPassage(self.passageData!))
        
        Singleton.sharedInstance.chatPassages?[index].choice01Selected = false
        Singleton.sharedInstance.chatPassages?[index].choice02Selected = false
        Singleton.sharedInstance.chatPassages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination1!)
        
    }
    
    @IBAction func button01Pressed()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForChatPassage(self.passageData!))
        
        Singleton.sharedInstance.chatPassages?[index].choice01Selected = true
        Singleton.sharedInstance.chatPassages?[index].choice02Selected = false
        Singleton.sharedInstance.chatPassages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination1!)
    }
    
    @IBAction func Button02Pressed()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForChatPassage(self.passageData!))
        
        Singleton.sharedInstance.chatPassages?[index].choice01Selected = false
        Singleton.sharedInstance.chatPassages?[index].choice02Selected = true
        Singleton.sharedInstance.chatPassages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination2!)
    }
    
    func actionbuttonPressed(passage : Passage_old)
    {
        //let passage = Singleton.sharedInstance.allTerminal?[passageId]
        
        //DESTINATION ID
        switch(passage.id)
        {
        //REBOOT -> ALLOW CONNECTION
        case 17:
                Singleton.sharedInstance.wipeChoicesForChat()
                Singleton.sharedInstance.chatPassages = []
                Singleton.sharedInstance.chatInterfaceController?.pushControllerWithName("Terminal", context: passage)
            break
        case 0:
            Singleton.sharedInstance.wipeChoicesForChat()
            Singleton.sharedInstance.chatPassages = []
            Singleton.sharedInstance.chatInterfaceController?.pushControllerWithName("Terminal", context: passage)
            break

            
        default:
            Singleton.sharedInstance.chatPassages?.append(passage)
            
            Singleton.sharedInstance.chatTable?.setNumberOfRows((Singleton.sharedInstance.chatPassages?.count)!, withRowType: "ChatRow")
            
            self.initializeCellForTable()
            
            break
            
        }
    }
    
    @IBAction func ImagePressed()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForChatPassage(self.passageData!))
        
        Singleton.sharedInstance.chatPassages?[index].choice01Selected = false
        Singleton.sharedInstance.chatPassages?[index].choice02Selected = false
        Singleton.sharedInstance.chatPassages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination1!)
    }
    
}