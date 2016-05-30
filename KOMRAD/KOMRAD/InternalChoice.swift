//
//  InternalChoice.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/2/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation
class InternalChoice: NSObject
{
    let value: String?
    let key: Int
    
    //TODO: Add child Passage for this Choice.
    
    init(key: Int, value: String?)
    {
        self.key = key
        self.value = value
        
    }
}