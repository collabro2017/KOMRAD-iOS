//
//  ParseService.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/15/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import Parse

class ParseService
{
    
    static func SaveAll(parseObjects : [PFObject])
    {
        PFObject.saveAllInBackground(parseObjects, block: {(success: Bool, error: NSError?) -> Void in
            if (success) {
                
            } else {
                print("Error: ",error!.description)
                // There was a problem, check error.description
            }
        })

    }
    static func Save(parseObject : PFObject)
    {
        parseObject.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                
            } else {
                print("Error: ",error!.description)
                // There was a problem, check error.description
            }
        }
    }
        
    static func CheckVersion(fromLocal : Bool) -> [PFStory]
    {
        var resultArray : [PFStory] = []
        var query = PFStory.query()
        query!.limit = 1
        //query!.cachePolicy = .CacheElseNetwork
       /* self.CheckOptionalValues(&query!, fromLocal: fromLocal, orderByKeys: orderByKeys, ascOrder: ascOrder, includeKeys: includeKeys)
     */
        if (fromLocal)
        {
            query?.fromLocalDatastore()
        }
        
        do
        {
            
            try resultArray = query!.findObjects() as! [PFStory]
            
        }
        catch
        {
            print("Error on Fetch Story");
        }
          //End synchronous method
            
        return resultArray;
    }
    
    static func checkVersion(fromLocal fromLocal: Bool, onSuccess:(data: [PFStory])->Void, onFailure: (error: NSError)->Void)
    {
        let query = PFStory.query()!
        query.limit = 1
        
        if (fromLocal) {
            query.fromLocalDatastore()
        }
        
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                onSuccess(data: data as! [PFStory])
            }
            else {
                onFailure(error: error!)
            }
        }
    }
    
    static func RetrieveAll<T : PFObject>(fromLocal : Bool = false,orderByKeys: [String] = [], ascOrder: Bool = true, includeKeys : [String] = [], limit : Int = 1000, pinAll : Bool = true) -> [T]
    {
        var resultArray : [T] = []
        var query = T.query()
        query!.limit = limit
        //query!.cachePolicy = .CacheElseNetwork
        self.CheckOptionalValues(&query!, fromLocal: fromLocal, orderByKeys: orderByKeys, ascOrder: ascOrder, includeKeys: includeKeys)
        
        do
        {
            
            try resultArray = query!.findObjects() as! [T]
            if (!fromLocal)
            {
                PFObject.pinAllInBackground(resultArray)
            }
        }
        catch
        {
            print("Error on Fetch Passage");
        }
        //End synchronous method
        
        return resultArray;
    }

    static func RetrieveByFieldname<T : PFObject>(field : String, value: NSObject,fromLocal : Bool = false,orderByKeys: [String] = [], ascOrder: Bool = true, includeKeys : [String] = [], limit : Int = 1000) -> [T]
    {
        
        var resultArray : [T] = []
        var query = T.query()
        query!.limit = limit
        // query!.cachePolicy = .CacheElseNetwork
        self.CheckOptionalValues(&query!, fromLocal: fromLocal, orderByKeys: orderByKeys, ascOrder: ascOrder, includeKeys: includeKeys)
        /* From Local Datastore */
        
        
        
        query!.whereKey(field, equalTo : value)
        do
        {
            try resultArray = query!.findObjects() as! [T]
            if (!fromLocal)
            {
                PFObject.pinAllInBackground(resultArray)
            }
        }
        catch
        {
            print("Error Fetching Object");
        }
        
        
        return resultArray;
    }
    
    /*static func RetrieveParagraphById<T : PFObject>(id : String,fromLocal : Bool = false,orderByKeys: [String] = [], ascOrder: Bool = true, includeKeys : [String] = [], limit : Int = 1000) -> [T]
    {
       
        var resultArray : [T] = []
        var query = T.query()
        query!.limit = limit
     // query!.cachePolicy = .CacheElseNetwork
         self.CheckOptionalValues(&query!, fromLocal: fromLocal, orderByKeys: orderByKeys, ascOrder: ascOrder, includeKeys: includeKeys)
        /* From Local Datastore */
      

        
        query!.whereKey(field, equalTo : value)
        do
        {
            try resultArray = query!.findObjects() as! [T]
            if (!fromLocal)
            {
                 PFObject.pinAllInBackground(resultArray)
            }
         }
        catch
        {
            print("Error Fetching Object");
        }
        
        
        return resultArray;
    }*/
    
    
    static func CheckOptionalValues(inout query: PFQuery, fromLocal : Bool = false, orderByKeys: [String] = [], ascOrder: Bool = true, includeKeys : [String] = [])
    {
       
        /* From Local Datastore */
        if(fromLocal)
        {
            query.fromLocalDatastore()
        }
        
        /* Include Keys in query */
        for includeKey in includeKeys
        {
            query.includeKey(includeKey)
        }
        /* Order Asc or Desc */
        if (orderByKeys.count > 0 )
        {
            if (ascOrder == true)
            {
                for orderByKey in orderByKeys
                {
                    query.orderByAscending(orderByKey)
                }
            }
            else
            {
                for orderByKey in orderByKeys
                {
                    query.orderByDescending(orderByKey)
                }
            }
        }
    }
    
}

