//
//  ParseUtils.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/25/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import AudioToolbox

class ParseUtils
{
    // var audios = [PFAudio]();
    static var pStories = [PFStory]();
    static var pChapters = [PFChapter]();
    static var pChoices = [PFChoice]();
    static var pPassages = [PFPassage]();
    static var pLines = [PFLine]();
    static var pPaths = [PFPath]();
    static var pPassageTags = [PFPassageTag]();
    static var pStoryVariables = [PFStoryVariable]();
    static var pTags = [PFTag]();
    //A test To Improve performance
    
    static func getAll() {        
        let fromLocal: Bool = false
        PFChapter.unpinAllObjectsInBackground()
        // var includeKeys = ["story"]
        pChapters = ParseService.RetrieveAll(fromLocal,orderByKeys: ["chapterId"],ascOrder: true)
        
        PFChapter.pinAllInBackground(pChapters)
        
        //includeKeys = ["passage", "passagePath", "passagePath.lastPassage", "passagePath.passage", "passagePath.nextPassage", "storyVariable"]
        pChoices = ParseService.RetrieveAll(fromLocal,orderByKeys: ["choiceId"],ascOrder: true)
        PFChoice.pinAllInBackground(pChoices)
        
        //includeKeys = ["chapter"]
        pPassages = ParseService.RetrieveAll(fromLocal,orderByKeys: ["passageId"],ascOrder: true)
        PFPassage.pinAllInBackground(pPassages)
        
        //includeKeys = ["passage"]
        pLines = ParseService.RetrieveAll(fromLocal,orderByKeys: ["passageLineId"],ascOrder: true)
        PFLine.pinAllInBackground(pLines)
        
        //includeKeys = ["lastPassage", "passage", "nextPassage"]
        pPaths = ParseService.RetrieveAll(fromLocal,orderByKeys: ["passagePathId"],ascOrder: true)
        PFPath.pinAllInBackground(pPaths)
        
        //includeKeys = ["passage","tag"]
        pPassageTags = ParseService.RetrieveAll(fromLocal,orderByKeys: ["passageTagId"],ascOrder: true)
        PFPassageTag.pinAllInBackground(pPassageTags)
        
        //includeKeys = ["story"]
        pStoryVariables = ParseService.RetrieveAll(fromLocal,orderByKeys: ["storyVariableId"],ascOrder: true)
        PFStoryVariable.pinAllInBackground(pStoryVariables)
        
        pTags = ParseService.RetrieveAll(fromLocal,orderByKeys: ["tagId"],ascOrder: true)
        PFTag.pinAllInBackground(pTags)
    }
    
    static func removeAllObjectsFromLocalDatabase(onSuccess: (status: Bool) -> Void) {
        PFStory.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
            if error == nil {
                PFChapter.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                    if error == nil {
                        PFChoice.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                            if error == nil {
                                PFPassage.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                    if error == nil {
                                        PFLine.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                            if error == nil {
                                                PFPath.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                                    if error == nil {
                                                        PFPassageTag.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                                            if error == nil {
                                                                PFStoryVariable.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                                                    if error == nil {
                                                                        PFTag.unpinAllObjectsInBackgroundWithBlock({ (status: Bool, error: NSError?) in
                                                                            if error == nil {
                                                                                onSuccess(status: true)
                                                                            }
                                                                            else {
                                                                                onSuccess(status: false)
                                                                            }
                                                                        })
                                                                    }
                                                                    else {
                                                                        onSuccess(status: false)
                                                                    }
                                                                })
                                                            }
                                                            else {
                                                                onSuccess(status: false)
                                                            }
                                                        })
                                                    }
                                                    else {
                                                        onSuccess(status: false)
                                                    }
                                                })
                                            }
                                            else {
                                                onSuccess(status: false)
                                            }
                                        })
                                    }
                                    else {
                                        onSuccess(status: false)
                                    }
                                })
                            }
                            else {
                                onSuccess(status: false)
                            }
                        })
                    }
                    else {
                        onSuccess(status: false)
                    }
                })
            }
            else {
                onSuccess(status: false)
            }
        })
    }
    
    static func getStoryAndPin(onSuccess: (success: Bool)->Void) {
        let storyQuery = PFStory.query()!
        storyQuery.limit = 1000
        storyQuery.orderByAscending("storyId")
        storyQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFStory.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getChaptersAndPin(onSuccess: (success: Bool)->Void) {
        let chapterQuery = PFChapter.query()!
        chapterQuery.limit = 1000
        chapterQuery.orderByAscending("chapterId")
        chapterQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFChapter.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getChoicesAndPin(onSuccess: (success: Bool)->Void) {
        let choiceQuery = PFChoice.query()!
        choiceQuery.limit = 1000
        choiceQuery.orderByAscending("choiceId")
        choiceQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFChoice.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getPassageAndPin(onSuccess: (success: Bool)->Void) {
        let passageQuery = PFPassage.query()!
        passageQuery.limit = 1000
        passageQuery.orderByAscending("passageId")
        passageQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFPassage.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getLinesAndPin(onSuccess: (success: Bool)->Void) {
        let lineQuery = PFLine.query()!
        lineQuery.limit = 1000
        lineQuery.orderByAscending("passageLineId")
        lineQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFLine.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getPathsAndPin(onSuccess: (success: Bool)->Void) {
        let pathQuery = PFPath.query()!
        pathQuery.limit = 1000
        pathQuery.orderByAscending("passagePathId")
        pathQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFPath.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getPassageTagsAndPin(onSuccess: (success: Bool)->Void) {
        let passageTagQuery = PFPassageTag.query()!
        passageTagQuery.limit = 1000
        passageTagQuery.orderByAscending("passageTagId")
        passageTagQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFPassageTag.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getStoryVariablesAndPin(onSuccess: (success: Bool)->Void) {
        let passageTagQuery = PFStoryVariable.query()!
        passageTagQuery.limit = 1000
        passageTagQuery.orderByAscending("storyVariableId")
        passageTagQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFStoryVariable.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getTagsAndPin(onSuccess: (success: Bool)->Void) {
        let tagQuery = PFTag.query()!
        tagQuery.limit = 1000
        tagQuery.orderByAscending("tagId")
        tagQuery.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                PFTag.pinAllInBackground(data, block: { (status: Bool, error: NSError?) in
                    if error == nil {
                        onSuccess(success: true)
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        }
    }
    
    static func getAllAndSaveInDatabase(onSuccess: (success: Bool)->Void) {
        self.getStoryAndPin({ (success) in
            if success {
                self.getChaptersAndPin({ (success) in
                    if success {
                        self.getChoicesAndPin({ (success) in
                            if success {
                                self.getPassageAndPin({ (success) in
                                    if success {
                                        self.getLinesAndPin({ (success) in
                                            if success {
                                                self.getPathsAndPin({ (success) in
                                                    if success {
                                                        self.getPassageTagsAndPin({ (success) in
                                                            if success {
                                                                self.getStoryVariablesAndPin({ (success) in
                                                                    if success {
                                                                        self.getTagsAndPin({ (success) in
                                                                            onSuccess(success: success)
                                                                        })
                                                                    }
                                                                    else {
                                                                        onSuccess(success: false)
                                                                    }
                                                                })
                                                            }
                                                            else {
                                                                onSuccess(success: false)
                                                            }
                                                        })
                                                    }
                                                    else {
                                                        onSuccess(success: false)
                                                    }
                                                })
                                            }
                                            else {
                                                onSuccess(success: false)
                                            }
                                        })
                                    }
                                    else {
                                        onSuccess(success: false)
                                    }
                                })
                            }
                            else {
                                onSuccess(success: false)
                            }
                        })
                    }
                    else {
                        onSuccess(success: false)
                    }
                })
            }
            else {
                onSuccess(success: false)
            }
        })
    }
    
    static func getStoryFromLocalDB(onSuccess: (data: Story?)->Void, onFailure: (error: NSError)->Void) {
        let query = PFStory.query()!
        query.limit = 1000
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) in
            if error == nil {
                if data != nil {
                    let storyObj = (data as! [PFStory]).first!
                    let story = Story(id: storyObj.storyId, author: storyObj.author, title: storyObj.title,
                                                    subtitle: storyObj.subtitle, version: storyObj.version)
                    story.storyVariables = getStoryVariables(storyObj, fromLocal: true)
                    story.chapters = getChapters(storyObj, fromLocal: true)
                    onSuccess(data: story)
                }
            }
            else {
                onFailure(error: error!)
            }
        }
    }
    
    static func getStory(fromLocal: Bool = false) -> Story
    {
        pStories = ParseService.RetrieveAll(fromLocal,orderByKeys: ["storyId"],ascOrder: true)
        PFStory.unpinAllInBackground(pStories)
        /*if (!fromLocal)
        {
        PFStory.pinAllInBackground(pStories)
        }*/
        
        
        var story : Story?
        for pFStory in pStories
        {
            story = Story(id: pFStory.storyId, author: pFStory.author, title: pFStory.title, subtitle: pFStory.subtitle, version: pFStory.version)
            story?.storyVariables = getStoryVariables(pFStory, fromLocal: fromLocal)
            story?.chapters = getChapters(pFStory, fromLocal: fromLocal)
        }
        
        return story!
    }
    
    static func getStoryVariables(pFStory: PFStory, fromLocal: Bool = false) -> [StoryVariable]?
    {
        var storyVariables = Array<StoryVariable>()
        let pFStoryVariables : [PFStoryVariable] = ParseService.RetrieveByFieldname("story", value: pFStory ,fromLocal: true,orderByKeys: ["storyVariableId"],ascOrder: true)
        for pFStoryVariable in pFStoryVariables
        {
            let storyVariable = StoryVariable(id: pFStoryVariable.storyVariableId, name: pFStoryVariable.name, initialValue: pFStoryVariable.initialValue, detail: pFStoryVariable.description)
            storyVariables.append(storyVariable)
        }
        return storyVariables
    }
    
    static func getChapters(pFStory: PFStory, fromLocal: Bool = false) -> [Chapter]?
    {
        /* Get Chapters */
        var chapters = Array<Chapter>()
        var pFChapters : [PFChapter] = ParseService.RetrieveByFieldname("story", value: pFStory ,fromLocal: fromLocal,orderByKeys: ["chapterId"],ascOrder: true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastChapterRead = defaults.integerForKey("lastChapterRead")
        
        if(lastChapterRead == 0)
        {
            //IF NO CHAPTER READ TAKE THE FIRST ONE
            if (pFChapters.count > 0 )
            {
                let passages = getPassagesFromPFChapter(pFChapters[0], fromLocal: fromLocal)
                let chapter = Chapter(id: pFChapters[0].chapterId, name: pFChapters[0].name, passages: passages)
                chapters.append(chapter)
            }
        }
        else
        {
            //IF SAVED CHAPTER LOAD THAT ONE
            for pFChapter in pFChapters
            {
                if(pFChapter.chapterId == lastChapterRead)
                {
                    let passages = getPassagesFromPFChapter(pFChapter, fromLocal: fromLocal)
                    let chapter = Chapter(id: pFChapter.chapterId, name: pFChapter.name, passages: passages)
                    chapters.append(chapter)
                }
            }
        }
        return chapters
    }
    
    static func getPassagesFromPFChapter(pFChapter: PFChapter, fromLocal: Bool = false) -> [Passage]?
    {
        var pFPassages : [PFPassage]?
        var passages = [Passage]();
        pFPassages = ParseService.RetrieveByFieldname("chapter", value: pFChapter, fromLocal: fromLocal,orderByKeys: ["passageId"],ascOrder: true);
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastPassageRead = defaults.integerForKey("lastPassageRead")
        
        
        for pFPassage in pFPassages!
        {
            
            if(lastPassageRead == 0)
            {
                //IF NO SAVED PASSAGE LOAD THE FIRST PASSAGE
                let passage = getPassage(pFPassage, fromLocal: fromLocal)
                passages.append(passage)
                break;
            }
            else
            {
                //IF SAVED PASSAGE LOAD THE PASSAGE AND ALL PREVIOUS PASSAGES
                if(pFPassage.passageId > lastPassageRead)
                {
                    break;
                }
                
                let passage = getPassage(pFPassage, fromLocal: fromLocal)
                passages.append(passage)
            }
            
        }
        return passages
    }
    
    /////////////////////////////////////////////////////////////////////////////
    //THIS FUNCTION IS GOING TO BE CALLED ON WATCH NOTIFICATION
    ///////////////////////////////////////////////////////////////////////////
    static func getPassageByPassageId(passageId: Int) -> Passage!
    {
        let pFPassages :[PFPassage] = ParseService.RetrieveByFieldname("passageId", value: passageId, fromLocal: true,orderByKeys: ["passageId"],ascOrder: true)
        if (pFPassages.count > 0)
        {
            let pFPassage : PFPassage = pFPassages[0]
            let passage = getPassage(pFPassage, fromLocal: true)
            
            //SAVE LAST READ PASSAGE & CHAPTER
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(pFPassage.passageId, forKey: "lastPassageRead")
            defaults.synchronize()
            
            /*var pFChapters : [PFChapter] = ParseService.RetrieveByFieldname("objectId", value: pFPassage.chapter.objectId!,fromLocal: true,orderByKeys: ["chapterId"],ascOrder: true)
            
            
            defaults.setInteger(pFChapters[0].chapterId, forKey: "lastChapterRead")*/
            
            return passage
        }
        return nil
    }
    
    static func getPassageByName(name: String) -> Passage!
    {
        let pFPassages :[PFPassage] = ParseService.RetrieveByFieldname("name", value: name, fromLocal: true,orderByKeys: ["passageId"],ascOrder: true)
        if (pFPassages.count > 0)
        {
            let pFPassage : PFPassage = pFPassages[0]
            let passage = getPassage(pFPassage, fromLocal: true)
            return passage
        }
        return nil
    }
    
    static func getPassageByObjectId(pFPassage: PFPassage) -> Passage!
    {
        let objectId = pFPassage.objectId
        let pFPassages :[PFPassage] = ParseService.RetrieveByFieldname("objectId", value: objectId!, fromLocal: true,orderByKeys: ["passageId"],ascOrder: true)
        if (pFPassages.count > 0)
        {
            let pFPassage : PFPassage = pFPassages[0]
            let passage = Passage(id: pFPassage.passageId, title: pFPassage.title)
            return passage
        }
        return nil
    }
    static func getPassageStoryVariableFromObjectId(objectId: String, fromLocal: Bool = false) -> StoryVariable!
    {
        let pFStoryVariables :[PFStoryVariable] = ParseService.RetrieveByFieldname("objectId", value: objectId, fromLocal: true,orderByKeys: ["storyVariableId"],ascOrder: true)
        if (pFStoryVariables.count > 0)
        {
            var pFStoryVariable = pFStoryVariables[0]
            var storyVariable = StoryVariable(id: pFStoryVariable.storyVariableId, name: pFStoryVariable.name, initialValue: pFStoryVariable.initialValue, detail: pFStoryVariable.description)
            
            return storyVariable
        }
        return nil
    }
    
    static func getPathFromPFPath(pFPath: PFPath, fromLocal: Bool = false) -> Path!
    {
        var path : Path?
        let pFPaths : [PFPath] = ParseService.RetrieveByFieldname("objectId", value: pFPath.objectId! ,fromLocal:true,orderByKeys: ["passagePathId"],ascOrder: true)
        
        for pFPath in pFPaths
        {
            var lastPassageId = (pFPath.lastPassage != nil) ? getPassageByObjectId(pFPath.lastPassage!).id : 0
            var passageId = (pFPath.passage != nil) ? getPassageByObjectId(pFPath.passage!).id : 0
            var nextPassageId = (pFPath.nextPassage != nil) ? getPassageByObjectId(pFPath.nextPassage!).id : 0
            
            var path = Path(id: pFPath.passagePathId, lastPassageId: lastPassageId, passageId: passageId, nextPassageId: nextPassageId)
            return path
            
        }
        return nil
        
    }
    
    
    static func getChoices(pFPassage: PFPassage, passage : Passage, fromLocal: Bool = false) -> [Choice]
    {
        var choices = Array<Choice>()
        var pFChoices : [PFChoice] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal: fromLocal,orderByKeys: ["choiceId"],ascOrder: true)
        for pFChoice in pFChoices
        {
            //Path
            var passagePath : Path?
            var pFPaths : [PFPath] = ParseService.RetrieveByFieldname("objectId", value: pFChoice.passagePath.objectId! ,fromLocal: fromLocal,orderByKeys: ["passagePathId"],ascOrder: true)
            if (pFPaths.count > 0)
            {
                passagePath = getPathFromPFPath(pFPaths[0])
            }
            
            var choice = Choice(id: pFChoice.choiceId, text: pFChoice.name, passage: passage, passagePath: passagePath)
            
            if (pFChoice.storyVariable != nil)
            {
                choice.storyVariable = getPassageStoryVariableFromObjectId(pFChoice.storyVariable!.objectId!)
                choice.storyValue = pFChoice.storyVariableValue
            }
            
            choices.append(choice)
        }
        return choices
    }
    
    static func getLines(pFPassage: PFPassage, passage : Passage, fromLocal: Bool = false) -> [Line]
    {
        /* Get Lines */
        var lines = Array<Line>()
        var pFLines : [PFLine] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal:fromLocal,orderByKeys: ["passageLineId"],ascOrder: true)
        for pFLine in pFLines
        {
            let lineText = Utils.createAttributedText(pFLine.content)
            var line = Line(id: pFLine.passageLineId, type: pFLine.type, text: lineText)
            lines.append(line)
            
        }
        return lines
    }
    
    
    static func getTag(pFTag: PFTag, fromLocal: Bool = false) -> Tag!
    {
        var pFTags : [PFTag] = ParseService.RetrieveByFieldname("objectId", value: pFTag.objectId! ,fromLocal: true,orderByKeys: ["tagId"],ascOrder: true)
        if (pFTags.count > 0)
        {
            for pFTag in pFTags
            {
                var tag = Tag(id: pFTag.tagId, name: pFTag.name)
                return tag
            }
        }
        return nil
        
    }
    
    
    static func getTags(pFPassage: PFPassage, passage : Passage, fromLocal: Bool = false) -> [Tag]
    {
        /* Get Tag/Type */
        var tags = Array<Tag>()
        passage.type = ""
        
        
        var pFPassageTags : [PFPassageTag] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal: fromLocal,orderByKeys: ["passageTagId"],ascOrder: true)
        if (pFPassageTags.count > 0 )
        {
            
            for pFPassageTag in pFPassageTags
            {
                
                var tag = getTag(pFPassageTag.tag)
                if (tag != nil)
                {
                    tags.append(tag)
                    
                }
            }
        }
        return tags
        
    }
    
    static func getPaths(pFPassage: PFPassage, passage : Passage, fromLocal: Bool = false) -> [Path]
    {
        //Path
        var passagePaths = [Path]()
        var pFPaths : [PFPath] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal: fromLocal,orderByKeys: ["passagePathId"],ascOrder: true)
        for pFPath in pFPaths
        {
            var passagePath = getPathFromPFPath(pFPath)
            passagePaths.append(passagePath)
        }
        
        return passagePaths
    }
    
    
    
    static func getPassage(pFPassage: PFPassage, fromLocal: Bool = false) -> Passage
    {
        var passage = Passage(id: pFPassage.passageId, title: pFPassage.title)
        
        var objectId = pFPassage.objectId
        /* Get Choices */
        
        passage.choices = getChoices(pFPassage, passage: passage, fromLocal: fromLocal)
        passage.lines = getLines(pFPassage,passage: passage, fromLocal: fromLocal)
        passage.tags = getTags(pFPassage,passage: passage, fromLocal: fromLocal)
        passage.paths = getPaths(pFPassage,passage: passage, fromLocal: fromLocal)
        
        return passage
        
    }
    
    
    /* END OF TRANSFORM PARSE OBJECTS TO MODEL OBJECTS */
}