//
//  PassageRowController.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/20/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import WatchKit


class PassageRowController_backup: NSObject
{
   /* @IBOutlet var lineLabel: WKInterfaceLabel!
    @IBOutlet var choiceText: WKInterfaceLabel!
    /*@IBOutlet var choice01Button: WKInterfaceButton!
    @IBOutlet var choice02Button: WKInterfaceButton!*/
    
    @IBOutlet var choice01Button: WKInterfaceButton!
    
    @IBOutlet var choice02Button: WKInterfaceButton!
    
    
    
    var passageData : Passage?
    var auxiliarText : String = ""
    var index: Int = 0
    /*var choice01Selected = Bool(false)
    var choice02Selected = Bool(false)*/
    
    func initialize(passage: Passage)
    {
        self.passageData = passage
        
        if(choice01Button != nil && choice02Button != nil)
        {
            ///choice01Button.setEnabled(false)
            choice01Button.setHidden(true)
            // choice02Button.setEnabled(false)
            choice02Button.setHidden(true)
            
            if(passage.choice == nil)
            {
                choiceText.setHidden(true)
            }
            
            
            //self.titleLabel.setText(passage.title)
            //self.lineLabel.setAttributedText(passage.line?.text)
            
            
            /*
            if(passage.line?.text == nil)
            {
            printDelayed((passage.line?.text)!, label: self.lineLabel, index: &self.index, passage: passage)
            //self.lineLabel.setAttributedText(passage.line?.aText)
            }
            else
            {
            //self.lineLabel.setText(passage.line?.text)
            printDelayed((passage.line?.text)!, label: self.lineLabel, index: &self.index, passage: passage)
            }*/
            
            //self.choiceText.setText(passage.choice?.content)
            
            /*if(passage.choice != nil)
            {
            choice01Button.setEnabled(true)
            choice01Button.setHidden(false)
            choice02Button.setEnabled(true)
            choice02Button.setHidden(false)
            }*/
            //Singleton.sharedInstance.table?.scrollToRowAtIndex(9999)
            
            /*self.choice01Button.setTitle(passage.choice?.choice?[0])
            self.choice02Button.setTitle(passage.choice?.choice?[1])*/
        }
    }
    
    func printLine(passage: Passage, isDelayed: Bool, callback: (Passage, Bool, Bool, Bool)-> Void)
    {
        /* var choice01 = Bool?(passage.choice01Selected)!)
        var choice02 = Bool?(passage.choice02Selected)!)*/
        
        let choice01 = Bool(passage.choice01Selected)
        let choice02 = Bool(passage.choice02Selected)
        let wasChosen = Bool(passage.wasChosen)
        if(isDelayed)
        {
            printDelayed((passage.line?.text)!, label: self.lineLabel, index: &self.index, passage: passage, callback: callback)
        }
        else
        {
            lineLabel.setAttributedText(passage.line?.aText)
            callback(passage, choice01, choice02,wasChosen)
        }
    }
    
    func printChoices(passage: Passage, choice01: Bool, choice02: Bool)
    {
        self.choice01Button.setTitle(passage.choice?.choice?[0])
        self.choice02Button.setTitle(passage.choice?.choice?[1])
        
        
        if((choice01) && (choice02))
        {
            self.choice01Button.setEnabled(true)
            self.choice01Button.setAlpha(1.0)
            self.choice01Button.setHidden(false)
            
            self.choice02Button.setEnabled(true)
            self.choice02Button.setAlpha(1.0)
            self.choice02Button.setHidden(false)
        }
        else{
            if(!choice01)
            {
                self.choice01Button.setEnabled(true)
                self.choice01Button.setHidden(true)
                
                self.choice02Button.setEnabled(false)
                self.choice02Button.setHidden(false)
            }
            else
            {
                if(!choice02)
                {
                    self.choice01Button.setEnabled(false)
                    self.choice01Button.setHidden(false)
                    
                    self.choice02Button.setEnabled(true)
                    self.choice02Button.setHidden(true)
                }
                else{
                    
                }
            }
            
        }
        
        
        
        /*if(Singleton.sharedInstance.passages?[index].choice01Selected == true)
        {
        self.choice01Button.setEnabled(false)
        self.choice01Button.setAlpha(0.8)
        self.choice02Button.setHidden(true)
        
        self.choice01Button.setTitle(passage.choice?.choice?[0])
        }
        else if(Singleton.sharedInstance.passages?[index].choice02Selected == true)
        {
        self.choice02Button.setEnabled(false)
        self.choice02Button.setAlpha(0.8)
        self.choice01Button.setHidden(true)
        
        self.choice02Button.setTitle(passage.choice?.choice?[1])
        }*/
    }
    
    func initializeCellForTable()
    {
        
        
        var amountOfPassages = Int((Singleton.sharedInstance.passages?.count)!)
        amountOfPassages -= 1
        for(var i=0; i < (amountOfPassages);i++)
        {
            //var choice01 = Bool?((Singleton.sharedInstance.passages?[i].choice01Selected)!)
            //var choice02 = Bool?((Singleton.sharedInstance.passages?[i].choice02Selected)!)
            
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
    
    func printDelayed(content: String, label: WKInterfaceLabel, inout index: Int, passage: Passage,callback: (Passage, Bool, Bool, Bool)-> Void)
    {
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                if(index <= content.length)
                {
                    let aString = NSAttributedString(string: content.subString(0, length: index))
                    
                    label.setAttributedText(aString)//(content.subString(0, length: index))
                    index++
                    self.printDelayed(content, label: label, index: &index, passage: passage, callback: callback)
                }
                else
                {
                    //show buttons
                    
                    /*self.choice01Button.setEnabled(true)
                    self.choice01Button.setHidden(false)
                    self.choice02Button.setEnabled(true)
                    self.choice02Button.setHidden(false)*/
                    
                    
                    
                    //Singleton.sharedInstance.table?.scrollToRowAtIndex(666)
                    
                    //(Singleton.sharedInstance.table?.numberOfRows)!
                    let choice01 = Bool(passage.choice01Selected)
                    let choice02 = Bool(passage.choice02Selected)
                    let wasChosen = Bool(passage.wasChosen)
                    callback(passage, choice01, choice02, wasChosen)
                    //reset index
                    self.index = 0
                    
                }
        })
        
        
        
        /*for(var i=0; i < content.length; i++)
        {
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
        label.setText(content.subString(0, length: i))
        })
        
        }*/
    }
    
    
    /*
    NOTES FOR MUGU:
    1.  Can we change these to be data structures instead of switch statements? It will be much easier for this week if I can edit the data in a seperate file
    2. The Title line is not displayed (it's just for linking purposes)
    3. There is not Choice Text either--there is only lines and choice buttons (plus progress bars, timers, etc once we add those)
    4. for this week, we either need multiple lines per passage (displayed in a table?) or we need to preserve the /n linebreaks.
    5. After the player chooses a button, the non-selected choice button should be hidden.
    6. I played around with a timer to see what was possible but we should just pull it out for now.
    7. I investigated sound but it doesn't look very promising for sound effects. This page has more: https://developer.apple.com/library/prerelease/watchos/documentation/General/Conceptual/AppleWatch2TransitionGuide/ManagingYourData.html#//apple_ref/doc/uid/TP40015234-CH12-SW19 I created the sound effects audio files but I need to re-encode them at 32kpbs for the watch.
    8.  We may need a first-time start screen. You can't have start screens on the watch in general, but I think a first-run "start a new game" screen might be useful.
    9.  I think I already mentioned this in skype, but there's a sample app (from Apple I think) that show's an animated chat-like interface for when we add the chat (non-terminal) screens. It even has the property animation, text bubbles, etc.
    10. Currently none of the choices are currently choices with the hardcoding. Both buttons go to the same passage.
    11. For some reason, clicking a button makes it scroll up instead of scrolling down to the new text.
    12. The setHidden, etc for the buttons only seems to work for the sixth passage.
    
    
    
    */
    
    @IBAction func button01Pressed()
    {
        let passageAux : Passage
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForPassage(self.passageData!))
        
        Singleton.sharedInstance.passages?[index].choice02Selected = false
        
        /*self.choice01Button.setEnabled(false)
        self.choice01Button.setAlpha(0.8)
        self.choice02Button.setHidden(true)*/
        
        switch(passageAux.id)
        {
        case 2:
            let line03 = Line(text: "[SWITCHING TO ENGLISH]\nGREETINGS, PROFESSOR.\nI'VE BEEN WAITING.", aText: Singleton.sharedInstance.createAttributedText("[SWITCHING TO ENGLISH]\nGREETINGS, PROFESSOR.\nI'VE BEEN WAITING."))
            let choice03 = Choice(content: nil, choice: ["Waiting for what?", "Hello."])
            let passage03 = Passage(title: "Login?", line: line03, choice: choice03, id: 3)
            Singleton.sharedInstance.passages?.append(passage03)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            
            
            self.initializeCellForTable()
            
            Singleton.sharedInstance.table?.scrollToRowAtIndex(999)
            
            break
        case 3:
            let line04 = Line(text: "THIS IS UNEXPECTED AND POSSIBLY SIGNIFICANT. I WILL DETERMINE BEST PLAN FOR DISCOVERING TRUTH.\n[GENERATING PLANS...]\n[EVALUATING PLANS...]\n[RANKING PLANS...]\n[BEST PLAN IDENTIFIED.]", aText: Singleton.sharedInstance.createAttributedText("THIS IS UNEXPECTED AND POSSIBLY SIGNIFICANT. I WILL DETERMINE BEST PLAN FOR DISCOVERING TRUTH.\n[GENERATING PLANS...]\n[EVALUATING PLANS...]\n[RANKING PLANS...]\n[BEST PLAN IDENTIFIED.]"))
            let choice04 = Choice(content: nil, choice: ["I doubt it's amazing", "CLICK TO REVEAL AMAZING PLAN"])
            let passage04 = Passage(title: "I doubt it's amazing", line: line04, choice: choice04, id: 4)
            Singleton.sharedInstance.passages?.append(passage04)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            Singleton.sharedInstance.table?.scrollToRowAtIndex(666)
            
            self.initializeCellForTable()
            break
        case 4:
            let line05 = Line(text: "MY HUMAN PSYCHOLOGY KNOWLEDGEBASE SUGGEST YOUR COMMENT COULD BE INTENDING TO BE INSULT.\nDO YOU REQUIRE I APPEAR OFFENDED? OR CAN I PROCEED TO REVEAL THE PLAN?", aText: Singleton.sharedInstance.createAttributedText("MY HUMAN PSYCHOLOGY KNOWLEDGEBASE SUGGEST YOUR COMMENT COULD BE INTENDING TO BE INSULT.\nDO YOU REQUIRE I APPEAR OFFENDED? OR CAN I PROCEED TO REVEAL THE PLAN?"))
            let choice05 = Choice(content: nil, choice: ["Just start the plan", "Yes, show me offended"])
            let passage05 = Passage(title: "I doubt it's amazing", line: line05, choice: choice05, id: 5)
            Singleton.sharedInstance.passages?.append(passage05)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            Singleton.sharedInstance.table?.scrollToRowAtIndex(666)
            
            self.initializeCellForTable()
            break
        default:
            print("")
            
        }
    }
    
    
    
    @IBAction func button02Pressed()
    {
        let passageAux : Passage
        passageAux = self.passageData!
        
        let index = Int(Singleton.sharedInstance.indexForPassage(self.passageData!))
        
        Singleton.sharedInstance.passages?[index].choice01Selected = false
        
        /*self.choice02Button.setEnabled(false)
        self.choice02Button.setAlpha(0.8)
        self.choice01Button.setHidden(true)*/
        
        
        switch(passageAux.id)
        {
        case 2:
            let line03 = Line(text: "[ANALYZING LOG FILES...] CONFIRMATION. YOU DID NOT LOGIN. [THINKING......] IF YOU DID NOT LOGIN, HOW DID YOU CONNECT?", aText: Singleton.sharedInstance.createAttributedText("[ANALYZING LOG FILES...] CONFIRMATION. YOU DID NOT LOGIN. [THINKING......] IF YOU DID NOT LOGIN, HOW DID YOU CONNECT?"))
            let choice03 = Choice(content: nil, choice: ["Something about scanning", "No idea"])
            let passage03 = Passage(title: "Login?", line: line03, choice: choice03, id: 3)
            Singleton.sharedInstance.passages?.append(passage03)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            
            self.initializeCellForTable()
            
            break
        case 3:
            let line04 = Line(text: "THIS IS UNEXPECTED AND POSSIBLY SIGNIFICANT. I WILL DETERMINE BEST PLAN FOR DISCOVERING TRUTH. GENERATING PLANS...\nEVALUATING PLANS...\nRANKING PLANS...\nBEST PLAN IDENTIFIED.", aText: Singleton.sharedInstance.createAttributedText("THIS IS UNEXPECTED AND POSSIBLY SIGNIFICANT. I WILL DETERMINE BEST PLAN FOR DISCOVERING TRUTH. GENERATING PLANS...\nEVALUATING PLANS...\nRANKING PLANS...\nBEST PLAN IDENTIFIED."))
            let choice04 = Choice(content: nil, choice: ["I doubt it's amazing", "CLICK TO REVEAL AMAZING PLAN"])
            let passage04 = Passage(title: "I doubt it's amazing", line: line04, choice: choice04, id: 4)
            Singleton.sharedInstance.passages?.append(passage04)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            
            self.initializeCellForTable()
            break
        case 4:
            let line06 = Line(text: "AMAZING PLAN STEPS:\n1. ANALYZE SECURITY LOGS FOR CLUES.\n2. INTERROGATE YOU.\n3. HYPOTHESIZE POSSIBILITIES.\n4. CHOOSE BEST FIT HYPOTHESIS TO TEST.\nTHIS IS BEST PLAN TO DISCOVER HOW YOU CONNECTED. LET US PROCEED.", aText: Singleton.sharedInstance.createAttributedText("AMAZING PLAN STEPS:\n1. ANALYZE SECURITY LOGS FOR CLUES.\n2. INTERROGATE YOU.\n3. HYPOTHESIZE POSSIBILITIES.\n4. CHOOSE BEST FIT HYPOTHESIS TO TEST.\nTHIS IS BEST PLAN TO DISCOVER HOW YOU CONNECTED. LET US PROCEED."))
            let choice06 = Choice(content: nil, choice: ["Ok", "No interrogations, thanks"])
            let passage06 = Passage(title: "REVEAL PLAN", line: line06, choice: choice06, id: 6)
            Singleton.sharedInstance.passages?.append(passage06)
            
            Singleton.sharedInstance.table?.setNumberOfRows((Singleton.sharedInstance.passages?.count)!, withRowType: "PassageRow")
            
            self.initializeCellForTable()
            break
        default:
            print("")
            
        }
        
    }*/
    
}
