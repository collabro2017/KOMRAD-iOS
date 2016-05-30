 //
//  PassageRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/20/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import WatchKit


class PassageRowController: NSObject
{
    @IBOutlet var lineLabel: WKInterfaceLabel!
    @IBOutlet var choiceText: WKInterfaceLabel!
    /*@IBOutlet var choice01Button: WKInterfaceButton!
    @IBOutlet var choice02Button: WKInterfaceButton!*/
    
    @IBOutlet var choice01Button: WKInterfaceButton!
    
    @IBOutlet var choice02Button: WKInterfaceButton!
    
    @IBOutlet var promptGroup: WKInterfaceGroup!
    
    @IBOutlet var cursorOutlet: WKInterfaceLabel!
    
    var passageData : Passage_old?
    var auxiliarText : String = ""
    var index: Int = 0
    
    var prompt = NSAttributedString(string: "")
    var cursor = NSAttributedString(string: "_")
    /*var choice01Selected = Bool(false)
    var choice02Selected = Bool(false)*/
    
    
    func initialize(passage: Passage_old)
    {
        self.passageData = passage
               
        Singleton.sharedInstance.setNextPassage(passage)
        Singleton.sharedInstance.setNextDestination(passage)
        
        
        if(choice01Button != nil && choice02Button != nil)
        {
            choice01Button.setHidden(true)
            choice02Button.setHidden(true)
            
            if(passage.choice == nil)
            {
                choiceText.setHidden(true)
            }
            
 
        }
    }
    
    func printLine(passage: Passage_old, isDelayed: Bool, callback: (Passage_old, Bool, Bool, Bool)-> Void)
    {
        let choice01 = Bool(passage.choice01Selected)
        let choice02 = Bool(passage.choice02Selected)
        let wasChosen = Bool(passage.wasChosen)
        let longDelay = Bool(false);
        if(isDelayed)
        {
            //printDelayed((passage.line?.text)!, label: self.lineLabel, index: &self.index, passage: passage, longDelay:longDelay,callback: callback)
        }
        else
        {
            //lineLabel.setAttributedText(passage.line?.aText)
            
            callback(passage, choice01, choice02,wasChosen)
        }
    }
    
    func printChoices(passage: Passage_old, choice01: Bool, choice02: Bool, wasChosen: Bool)
    {
       /*var choice01Title = ""
       var choice02Title = ""
        
        var amountOfPassages = (Singleton.sharedInstance.passages?.count)!
        
        
        if ((passage.choice != nil) && (passage.choice?.choice != nil))
        {
           
            if(!wasChosen)
            {
                
                if((passage.choice?.choice?.count > 0))
                {
                    self.choice01Button.setHidden(false)
                    choice01Title = (passage.choice?.choice?[0])!
                    if (passage.choice?.choice?.count > 1)
                    {
                        choice02Title = (passage.choice?.choice?[1])!
                        self.choice02Button.setHidden(false)
                    }
                }
                Singleton.sharedInstance.table?.scrollToRowAtIndex(amountOfPassages - 1)

            }
            else
            {
                   if((passage.choice?.choice?.count > 0))
                    {
                        self.choice01Button.setHidden(!choice01)
                        choice01Title = (passage.choice?.choice?[0])!
                        if (passage.choice?.choice?.count > 1)
                        {
                            self.choice02Button.setHidden(!choice02)
                            choice02Title = (passage.choice?.choice?[1])!
                        }
                    }                 
            }
           
            
        }
        else
        {
            
            if(!wasChosen)
            {
               
                self.displayPassageWithoutChoice()
            }
        }
        self.choice01Button.setEnabled(!wasChosen)
        self.choice02Button.setEnabled(!wasChosen)
        self.choice01Button.setTitle(choice01Title)
        self.choice02Button.setTitle(choice02Title)
       
       */
        
    }
    
    func initializeCellForTable()
    {
        
        var amountOfPassages = Int((Singleton.sharedInstance.passages?.count)!)
        amountOfPassages -= 1
        for(var i=0; i < (amountOfPassages);i++)
        {
            let row = Singleton.sharedInstance.table?.rowControllerAtIndex(i) as? PassageRowController
            row?.initialize((Singleton.sharedInstance.passages?[i])!)
           row?.printLine((Singleton.sharedInstance.passages?[i])!, isDelayed: false, callback: (row?.printChoices)!)
            
        }
        
        let row = Singleton.sharedInstance.table?.rowControllerAtIndex(amountOfPassages) as? PassageRowController
        row?.initialize((Singleton.sharedInstance.passages?[amountOfPassages])!)
        row?.printLine((Singleton.sharedInstance.passages?[amountOfPassages])!, isDelayed: true,callback: (row?.printChoices)!)
        
        
        
    }
    
    func initializeCellForTableAtIndex(index: Int)
    {
        let row = Singleton.sharedInstance.table?.rowControllerAtIndex(index) as? PassageRowController
        row?.initialize((Singleton.sharedInstance.passages?[index])!)
    }
    
    func printDelayed(content: String, label: WKInterfaceLabel, inout index: Int, passage: Passage_old,var longDelay: Bool, callback: (Passage_old, Bool, Bool, Bool)-> Void)
    {
        let seconds = 0.04
        let secondsWithLineBreak = 0.5
        var delay: Double = 0.0   // nanoseconds per seconds
        var lastChar: Character
        if(index < content.length)
        {
            lastChar = content[index]
            
       }
        else
        {
            lastChar = content[content.length - 1]
            
        }
        if(longDelay)
        {
            delay = (seconds + secondsWithLineBreak) * Double(NSEC_PER_SEC)
           
        }
        else
        {
            delay = seconds * Double(NSEC_PER_SEC)
        }
        
        if(lastChar == "\n")
        {
           longDelay = true;
        }
        else
        {
           longDelay = false;
        }
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
        {
            
            if(index <= content.length)
            {
                let aString = NSAttributedString(string: content.subString(0, length: index))
     
                
                var aux = NSMutableAttributedString(attributedString: self.prompt)
                
                
               
                if(index == content.length)
                {
                    aux.appendAttributedString(aString)
                    self.promptGroup.setHidden(false)
                }
                else
                {
                    aux.appendAttributedString(aString)
                    aux.appendAttributedString(self.cursor)
                    
                }
                
                
                
                
                label.setAttributedText(aux)//(content.subString(0, length: index))
                index++
                self.printDelayed(content, label: label, index: &index, passage: passage, longDelay: longDelay,callback: callback)
            }
            else
            {
                self.promptGroup.setHidden(false)
                let choice01 = Bool(passage.choice01Selected)
                let choice02 = Bool(passage.choice02Selected)
                let wasChosen = Bool(passage.wasChosen)
                callback(passage, choice01, choice02, wasChosen)
                
                
                //reset index
                self.index = 0
               
            }
            var amountOfPassages = (Singleton.sharedInstance.passages?.count)!
            Singleton.sharedInstance.table?.scrollToRowAtIndex(amountOfPassages - 1)
           /* dispatch_async(dispatch_get_main_queue()){
                Singleton.sharedInstance.table?.scrollToRowAtIndex(amountOfPassages - 1)
            }*/
            
            
        })

        
         }
    
    
/*
    NOTES FOR MUGU:
    7. SOUND: I investigated sound but it doesn't look very promising for sound effects on the watch. This page has more: https://developer.apple.com/library/prerelease/watchos/documentation/General/Conceptual/AppleWatch2TransitionGuide/ManagingYourData.html#//apple_ref/doc/uid/TP40015234-CH12-SW19 I created the sound effects audio files for iOS and I re-encoded them at 32kpbs for the watch.
    9.  ANIMATIONS: need animations (chat bubbles, choice buttons) FYI: I think I already mentioned this in skype, but there's a sample app (from Apple I think) that show's an animated chat-like interface for when we add the chat (non-terminal) screens. It even has the property animation, text bubbles, etc.
    14. NOTIFICATIONS: replace komrad notification image with real watch/ios notifications
    17. PAUSES: need to put the pauses in--
        c.long pauses that lead to notifications
        d. messages that display while terminal or chat is busy: "K.O.M.R.A.D. is processing"; "unknown number" is busy
    20. CHOICES: remember that there can be as many as four choice buttons in a passage.
    22. MENU: we need the force touch menu in for RESTART, FAST MODE (skip pauses and typing)
    25. I added a haptic/sound or two into the code. The one in SplashInterfaceController is working fine but the same code in PassageRowController wouldn't work
    27. 38MM: I only have a 42mm to test on in real life; right now the 38mm looks like it's wrapping lines on the first Terminal passage. Not sure if that's a simulator bug or an issue with our storyboard or what...
    
    
 
 */
    func displayPassageWithoutChoice()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForPassage(self.passageData!))
        
        self.promptGroup.setHidden(true)
        
        Singleton.sharedInstance.passages?[index].choice01Selected = false
        Singleton.sharedInstance.passages?[index].choice02Selected = false
        Singleton.sharedInstance.passages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination1!)
        
    }
    
    
    
    
    @IBAction func button01Pressed()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForPassage(self.passageData!))
        
        self.promptGroup.setHidden(true)
        
        
        Singleton.sharedInstance.passages?[index].choice01Selected = true
        Singleton.sharedInstance.passages?[index].choice02Selected = false
        Singleton.sharedInstance.passages?[index].wasChosen = true
        
        if (passageAux.id == 40)
        {
            Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages?[25]
            Singleton.sharedInstance.terminalInterfaceController?.pushControllerWithName("Splash", context: nil)
        }
        else
        {
            actionbuttonPressed(passageAux.destination1!)
        }
        
    }
    
    
 
    @IBAction func button02Pressed()
    {
        let passageAux : Passage_old
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForPassage(self.passageData!))
        
        self.promptGroup.setHidden(true)
        
        Singleton.sharedInstance.passages?[index].choice01Selected = false
        Singleton.sharedInstance.passages?[index].choice02Selected = true
        Singleton.sharedInstance.passages?[index].wasChosen = true
        
        actionbuttonPressed(passageAux.destination2!)
        
      
    }
    
    func actionbuttonPressed(passage : Passage_old)
    {
        //let passage = Singleton.sharedInstance.allTerminal?[passageId]
        //Singleton.sharedInstance.allPassages[19]
        
        /* SOUND/HAPTIC NOT WORKING: 
        let device = WKInterfaceDevice.currentDevice()
        let haptictype = WKHapticType.Success
        device.playHaptic(haptictype)
        */
        
        //DESTINATION ID
        switch(passage.id)
        {
            //KRASH -> SHORT LOOK
            case 23:
                Singleton.sharedInstance.wipeChoicesForTerminal()
                Singleton.sharedInstance.passages = []
                Singleton.sharedInstance.terminalInterfaceController?.pushControllerWithName("Splash", context: passage)
                
                break
            
            default:
                Singleton.sharedInstance.passages?.append(passage)
                
                Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
                
                self.initializeCellForTable()

                break
            
        }
        
    }
}
