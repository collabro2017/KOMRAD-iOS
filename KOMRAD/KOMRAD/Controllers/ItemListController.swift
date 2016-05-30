//
//  ItemListController.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/10/15.
//  Copyright (c) 2015 Bradley Becker. All rights reserved.
//

import Foundation
import UIKit
import Parse
import WatchConnectivity

@available(iOS 9.0, *)
class ItemListController: UIViewController, UITableViewDelegate, WCSessionDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var listAdapter : MessageListAdapter?
    var stories = [Story]();
     var session: WCSession!
    @IBOutlet weak var lblLoadingContent: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
      //  lblLoadingContent.text = "Loading Content..."
        
    }
      
}