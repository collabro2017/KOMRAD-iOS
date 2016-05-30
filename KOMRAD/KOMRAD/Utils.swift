//
//  Utils.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/17/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import UIKit
class Utils
{
    
    static func createAttributedText(text: String) -> NSAttributedString
    {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1
        
        let attributes = [NSParagraphStyleAttributeName: style]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return attributedText
    }
    
    
    static func RegexTest(pattern: String, input: String) -> [NSTextCheckingResult]?
    {
        let options = NSMatchingOptions();
        do
        {
            let nsRegEx = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            
            let matches = nsRegEx.matchesInString(input, options: options, range: NSMakeRange(0,input.length))
            
            return matches
        }
        catch
        {
            
        }
        return nil
    }
    static func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        /*How to use it */
        /*
        delay(5) {     // takes a Double value for the delay in seconds
        
        // put the delayed action/function here
        
        }
        
        */
    }
    
    
    /* static func MacroAction(macro: String, key: String, value: String)
    {
    switch macro
    {
    case Constants.Macros.WAIT:
    //TODO: user an alternative to sleep(value)
    Constants.GlobalVariables.WAIT = value as! Int
    break;
    case Constants.Macros.SET:
    setStoryVariable(key,value: value)
    break;
    case Constants.Macros.AUDIO:
    //TODO: play audio sound
    break;
    case Constants.Macros.PAUSE:
    Constants.GlobalVariables.WAIT = 1 as! Int
    break;
    case Constants.Macros.TIME:
    // Return timestamp
    //TODO: play audio sounds
    break;
    case Constants.Macros.TYPING:
    Constants.GlobalVariables.TYPING = value as! Int
    break;
    case Constants.Macros.DOTS:
    //TODO: play dots animation
    break;
    
    default:
    break;
    
    }
    
    }*/
    
    static func setStoryVariables(inout dictionary: Dictionary<String,AnyObject>,storyVariables: [StoryVariable]?)
    {
        if(storyVariables != nil)
        {
            for storyVariable in storyVariables!
            {
                setStoryVariable(&dictionary,key: storyVariable.name, value: storyVariable.initialValue)
            }
        }
        
    }
    
    
    static func setStoryVariable(inout dictionary: Dictionary<String,AnyObject>, key: String, value: AnyObject)
    {
        dictionary[key] = value
    }
    static func getStoryVariable(dictionary : Dictionary<String,AnyObject>,key: String) -> AnyObject?
    {
        
        return dictionary[key]
    }
    
    static func keyAlreadyExist(key: String) -> Bool {
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey(key) != nil) {
            return true
        }
        
        return false
    }
    
}