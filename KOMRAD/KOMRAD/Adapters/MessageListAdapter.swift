//
//  MessageListAdapter.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/11/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation
import UIKit

class MessageListAdapter: NSObject, UITableViewDataSource
{
    var items: [Item] = []
    var passages: [Passage_old]
    var timer = NSTimer()
    var counter = 0
    let tableView: UITableView


    init(tableView: UITableView)
    {
        //We create dummy data to test functionality.
        //TODO: Look for a solution regarding order in the content of a Passage, probably will be solved from Backend.
        //Passage01
     /*   let line01 = Line(text: "WELCOME TO K.O.M.R.A.D. TEST! \n ... LOADING CONTENT ...", aText: nil)

        let choice01 = Choice(content: "DO YOU WANT TO CONTINUE?", choice: ["YES", "NO"])
        choice01.content!.uppercaseString
        
        //let choice01 = nil
*/
        
        let passage01 = Passage_old(title: "WELCOME", line: nil, choice: nil, id: 0)
        
        passages = [passage01]

        self.tableView = tableView
        super.init()
        
       /* timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)


        */
       
    }
    
    func updateCounter()
    {
       /* counter++
        if(counter == 3)
        {
            let line02 = Line(text: "THANKS FOR WAITING! \n THE PURPOSE OF THIS EXPERIMENT IS TESTING....", aText: nil)
            
            let passage02 = Passage_old(title: "NEW TEST", line: line02, choice: nil, id: 0)
            
            passages.append(passage02)
            */
            tableView.reloadData()
            
        //}
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return passages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        /*for Passage in self.passages
        {
        
        }*/
        /*let cell = tableView.dequeueReusableCellWithIdentifier(SimpleMessageCell.cellReuseIdentifier, forIndexPath: indexPath) as! SimpleMessageCell
        cell.initializeWithSimpleMessage(items[indexPath.row])
        return cell*/
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PassageCell.cellReuseIdentifier, forIndexPath: indexPath) as! PassageCell
        cell.initialize(passages[indexPath.row])
        cell.adapter = self
        return cell
    }
    
    func addPassage(passage: Passage_old)
    {
        passages.append(passage)
        
        tableView.reloadData()
    }
}



