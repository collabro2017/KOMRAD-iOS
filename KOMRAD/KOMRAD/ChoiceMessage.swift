//
//  ChoiceMessage.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/12/15.
//  Copyright (c) 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation

class ChoiceMessage: NSObject
{
    let type: String
    let content: String
    
    init(type: String, content: String)
    {
        self.type = type
        self.content = content
    }
}