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
    
    
    
    
    
    /* TRANSFORM PARSE OBJECTS TO MODEL OBJECTS */
    
    static func getStory(pFStory: PFStory, fromLocal: Bool = false, chapterLimit: Int = 1000,limit: Int = 1000) -> Story
    {
        var story = Story(id: pFStory.storyId, author: pFStory.author, title: pFStory.title, subtitle: pFStory.subtitle, version: pFStory.version)
        var objectId = pFStory.objectId
        
        /* Get Chapters */
        var chapters = Array<Chapter>()
        var pFChapters : [PFChapter] = ParseService.RetrieveByFieldname("story", value: pFStory ,fromLocal: fromLocal,orderByKeys: ["chapterId"],ascOrder: true)
        for pFChapter in pFChapters
        {
            var passages = getPassages(pFChapter,fromLocal: fromLocal,limit: limit)
            var chapter = Chapter(id: pFChapter.chapterId, name: pFChapter.name, passages: passages)
            chapters.append(chapter)
        }
        
        
        return story
    }
    static func getPassages(pFChapter: PFChapter, fromLocal: Bool, limit: Int) -> [Passage]?
    {
        var pFPassages : [PFPassage]?
        var passages = [Passage]();
        pFPassages = ParseService.RetrieveByFieldname("chapter", value: pFChapter, fromLocal: fromLocal,orderByKeys: ["passageId"],ascOrder: true,includeKeys: [], limit: limit)
        for pFPassage in pFPassages!
        {
            var passage = Utils.getPassage(pFPassage)
            passages.append(passage)
        }
        return passages
    }
    
    
    static func getPassage(pFPassage: PFPassage) -> Passage
    {
        var passage = Passage(id: pFPassage.passageId, title: pFPassage.title)
        
        var objectId = pFPassage.objectId
        /* Get Choices */
        
        var choices = Array<Choice>()
        var includeKeys = ["passage","passagePath","passagePath.lastPassage","passagePath.passage","passagePath.nextPassage"]
        var pFChoices : [PFChoice] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal: false,orderByKeys: ["choiceId"],ascOrder: true,includeKeys: includeKeys)
        for pFChoice in pFChoices
        {
            print("Choice Name: ", pFChoice.name)
            
            var pathId =  pFChoice.passagePath.passagePathId
            var lastId = (pFChoice.passagePath.lastPassage != nil) ? pFChoice.passagePath.lastPassage?.passageId : 0
            var nextId = (pFChoice.passagePath.nextPassage != nil) ? pFChoice.passagePath.nextPassage?.passageId : 0
            var passageId = (pFChoice.passagePath.passage != nil) ? pFChoice.passagePath.passage?.passageId : 0
            
            var passagePath = Path(id: pathId, lastPassageId: lastId, passageId: passageId!, nextPassageId: nextId)
            var choice = Choice(id: pFChoice.choiceId, text: pFChoice.name, passage: passage, passagePath: passagePath)
            choices.append(choice)
        }
        passage.choices = choices
        
        /* Get Lines */
        var lines = Array<Line>()
        var pFLines : [PFLine] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal:false,orderByKeys: ["passageLineId"],ascOrder: true)
        for pFLine in pFLines
        {
            let lineText = Utils.createAttributedText(pFLine.content)
            var line = Line(id: pFLine.passageLineId, type: pFLine.type, text: lineText)
            lines.append(line)
            
        }
        passage.lines = lines
        
        
        /* Get Tag/Type */
        var tags = Array<Tag>()
        passage.type = ""
        includeKeys = ["tag"]
        var pFPassageTags : [PFPassageTag] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal: false,orderByKeys: ["passageTagId"],ascOrder: true, includeKeys: includeKeys)
        for pFPassageTag in pFPassageTags
        {
            
            var pFTag = pFPassageTag.tag
            var tag = Tag(id: pFTag.tagId, name: pFTag.name)
            
            if (pFTag.name == Constants.Tags.TERMINAL) || (pFTag.name == Constants.Tags.CHAT)
            {
                passage.type = pFTag.name
            }
            
            tags.append(tag)
        }
        passage.tags = tags
        
        /* Get Path */
        var paths = Array<Path>()
        includeKeys = ["lastPassage","passage","nextPassage"]
        let pFPaths : [PFPath] = ParseService.RetrieveByFieldname("passage", value: pFPassage ,fromLocal:false,orderByKeys: ["passagePathId"],ascOrder: true, includeKeys: includeKeys)
        
        for pFPath in pFPaths
        {
            
            let lastPassageId = pFPath.lastPassage != nil ? pFPath.lastPassage?.passageId : -1
            let nextPassageId = pFPath.nextPassage != nil ? pFPath.nextPassage?.passageId : -1
            
            var path = Path(id: pFPath.passagePathId, lastPassageId: lastPassageId, passageId: pFPath.passage!.passageId, nextPassageId: nextPassageId)
            paths.append(path)
            
        }
        passage.paths = paths
        
        
        return passage
        
    }
     /* END OF TRANSFORM PARSE OBJECTS TO MODEL OBJECTS */
}