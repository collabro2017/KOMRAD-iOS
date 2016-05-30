//
//  SimpleMessageCell.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/11/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import UIKit

class SimpleMessageCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    static let cellReuseIdentifier = "SimpleMessageCellId"
    
    func initializeWithSimpleMessage(passage : Passage_old)
    {
        //contentLabel.text = item.content
    }
    
}
