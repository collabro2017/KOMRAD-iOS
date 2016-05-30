//
//  PassageCell.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/13/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import UIKit

class PassageCell: UITableViewCell
{

    @IBOutlet weak var passageTitleLabel: UILabel!
    
    @IBOutlet weak var passageLineLabel: UILabel!
    
    @IBOutlet weak var passageChoiceContentLabel: UILabel!
    
    @IBOutlet weak var passageChoice01Button: UIButton!
    
    @IBOutlet weak var passageChoice02Button: UIButton!
    
    
    static let cellReuseIdentifier = "PassageCellId"
    
    var titleLoaded : Bool = false
    var lineLoaded : Bool = false
    var choiceContentLoaded : Bool = false
    var choice01Loaded : Bool = false
    var choice02Loaded : Bool = false
    var passageData : Passage_old?
    
    let auxCoder = NSCoder()
    var adapter : MessageListAdapter?
    var hasFinishedLoading = Bool(false)
    


    
    func initialize(passage : Passage_old)
    {
        if(passageLineLabel.text != "")
        {
            return
        }
        
        self.passageData = passage
        
        
        //Disable buttons, later enabled if needed.
        passageChoice01Button.enabled = false
        passageChoice01Button.hidden = true
        passageChoice02Button.enabled = false
        passageChoice02Button.hidden = true
        
        if(self.passageData?.choice == nil)
        {
            passageChoiceContentLabel.enabled = false
            passageChoiceContentLabel.hidden = true
        }
        //passageLineLabel.text = passage.line?.text
        //passageChoiceContentLabel.text = passage.choice?.content
        
        var i = Int(0)
        
        //improve later, should use a better solution and some kind of scheduler for passages and such.
        printLabelDelayed(passageTitleLabel, content: passage.title, index: &i, toLoad: "title")
        i = 0
        
        /*if(titleLoaded)
        {
            printLabelDelayed(passageLineLabel, content: passage.line!.text!, index: &i, toLoad: "line")
            i = 0
        }
        else if(lineLoaded)
        {
            printLabelDelayed(passageChoiceContentLabel, content: passage.choice!.content, index: &i, toLoad: "choiceContent")
            i = 0
        }
        else if(choiceContentLoaded)
        {
            passageChoice01Button.setTitle(passage.choice?.choice?[0], forState: UIControlState.Normal)
            passageChoice02Button.setTitle(passage.choice?.choice?[1], forState: UIControlState.Normal)
        }*/
    
        //TODO: Do something with the buttons later.
        
    }
    
    //Not being used ATM, could come handy later.
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func printLabelDelayed(label: UILabel, content: String, inout index: Int, toLoad: String)
    {
        
        /*let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.05))
        dispatch_after(time, dispatch_get_main_queue())
        {
            if(index < content.characters.count)
            {
                label.text?.append(content[index])
                index++
                self.printLabelDelayed(label, content: content, index: &index, toLoad: toLoad)
            }
            else
            {
                var otherI = Int(0)
                
                switch toLoad
                {
                    
                case "title":
                    self.printLabelDelayed(self.passageLineLabel, content: self.passageData!.line!.text!, index: &otherI, toLoad: "line")
                    otherI = 0
                    //Move to choicecontent later!
                    self.passageChoice01Button.setTitle(self.passageData!.choice?.choice?[0], forState: UIControlState.Normal)
                    
                    self.passageChoice02Button.setTitle(self.passageData!.choice?.choice?[1], forState: UIControlState.Normal)
                    
                    self.passageChoice01Button.enabled = true
                    self.passageChoice01Button.hidden = false
                    self.passageChoice02Button.enabled = true
                    self.passageChoice02Button.hidden = false
                case "line":
                    self.printLabelDelayed(self.passageChoiceContentLabel, content: self.passageData!.choice!.content!, index: &otherI, toLoad: "choiceContent")
                    otherI = 0
                case "choiceContent":
                    //We put this here because we need "line" to finish to do this.
                    self.hasFinishedLoading = true
                    print("nothing to do here")
                case "choice01":
                     print("nothing to do here")
                case "choice02":
                     print("nothing to do here")
                default:
                    print("default")
                }
            }

       }*/
    }
    


    @IBAction func choice01Pressed(sender: UIButton)
    {
        //sender.setTitle("sarasa", forState: UIControlState.Normal)

        
       /* if(sender.titleLabel!.text == self.passageData!.choice?.choice?[0])
        {
            let line01 = Line(text: "THIS IS A NEW LINE", aText: nil)
            
            /*let choice01 = Choice(content: "DO YOU WANT TO CONTINUE?", choice: ["YES", "NO"])
            choice01.content!.uppercaseString*/
            
            let passage01 = Passage_old(title: "TOUCHED BUTTON01", line: line01, choice: nil, id: 0)
            
            self.adapter!.addPassage(passage01)
        }
        else if(sender.titleLabel!.text == self.passageData!.choice?.choice?[1])
        {
            //do other things.
        }*/
    }
  
    
    
    
}
