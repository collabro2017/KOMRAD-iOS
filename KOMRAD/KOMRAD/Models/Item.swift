//
//  Item.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/10/15.
//  Copyright (c) 2015 Bradley Becker. All rights reserved.
//

import Foundation

class Item: NSObject
{
    let type: String
    let content: String
    
    init(type: String, content: String)
    {
        self.type = type
        self.content = content
    }
}