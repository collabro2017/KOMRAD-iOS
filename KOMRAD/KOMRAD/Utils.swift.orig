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
<<<<<<< HEAD
        let options = NSMatchingOptions();
        do
        {
            let nsRegEx = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            
            let matches = nsRegEx.matchesInString(input, options: options, range: NSMakeRange(0,input.length))
            
            return matches
        }
        catch
=======
        var story = Story(id: pFStory.storyId, author: pFStory.author, title: pFStory.title, subtitle: pFStory.subtitle, version: pFStory.version)
        var objectId = pFStory.objectId
        
        /* Get Chapters */
        var chapters = Array<Chapter>()
         var pFChapters : [PFChapter] = ParseService.RetrieveByFieldname("story", value: pFStory ,fromLocal: fromLocal,orderByKeys: ["chapterId"],ascOrder: true,includeKeys: [], limit: chapterLimit)
        for pFChapter in pFChapters
>>>>>>> KOM-14
        {
            
        }
        return nil
    }
    static func delay(delay:Double, closure:()->()) {
        
<<<<<<< HEAD
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        /*How to use it */
        /*
            delay(5) {     // takes a Double value for the delay in seconds
        
                // put the delayed action/function here
        
            }
=======
        story.chapters = chapters
        
>>>>>>> KOM-14
        
        */
    }
    static func MatchLine(line: String)
    {
       var results = Utils.RegexTest(Constants.RegexMacros.REGEX,input: line)
       
        if ((results != nil) && (results?.count > 0))
       {
            for result in results! as [NSTextCheckingResult]
            {
                print("number of matches: \(results!.count)")
                // range at index 0: full match
                // range at index 1: first capture group
                let macro = (line as NSString).substringWithRange(result.rangeAtIndex(1))
                
                MacroAction(result,line: line, macro: macro)
                
                
            }
        
        
        }
        // MacroAction()
    }
    static private func MacroAction(result: NSTextCheckingResult,line: String, macro: NSString)
    {
        var key = ""
        var value = ""
        
        switch macro
        {
        case Constants.Macros.SET:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(4))
            
            setStoryVariable(key,value: value)
            break;
        case Constants.Macros.AUDIO:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            //TODO: Play Audio
            break;
        case Constants.Macros.IF:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            
            break;
        case Constants.Macros.WAIT:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            Constants.GlobalVariables.WAIT = value as! Int
            break;
        case Constants.Macros.TYPING:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            Constants.GlobalVariables.TYPING = value as! Int
            break;
        case Constants.Macros.DISPLAY:
            key = (line as NSString).substringWithRange(result.rangeAtIndex(2))
            value = (line as NSString).substringWithRange(result.rangeAtIndex(3))
            
            break;
        default:
            break;
        }
        
        //MacroAction(macro, key: key, value: key)

    
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
    
    static func saveStoryVariables(storyVariables: [StoryVariable])
    {
        for storyVariable in storyVariables
        {
            setStoryVariable(storyVariable.name, value: storyVariable.initialValue)        
        }
    }
    
    
    static func setStoryVariable(key: String, value: AnyObject?)
    {
        Constants.GlobalVariables.StoryVariables.setValue(value, forKey: key)
    }
    static func getStoryVariable(key: String) -> AnyObject?
    {
       return Constants.GlobalVariables.StoryVariables.objectForKey(key)
    }
    
}