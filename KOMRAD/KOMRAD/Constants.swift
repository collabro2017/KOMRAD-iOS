//
//  Constant.swift
//  KOMRAD
//
//  Created by DiegoPC on 9/18/15.
//  Copyright © 2015 Sentient Play LLC. All rights reserved.
//

import Foundation


struct Constants {
    
    struct Main
    {
        static let APP_GROUP_ID = "group.com.SENTIENTPLAY.KOMRADGROUP"
    }
    struct Names
    {
        static let NEXT_PASSAGE = "$nextpassage"
    }
    
    struct DefaultNotificationMessages
    {
        static let BUSY_MESSAGE = "[K.O.M.R.A.D. is busy…]"
        static let MESSAGE = "NOTIFICATION MESSAGE"
    }
    struct Tags
    {
        static let TERMINAL = "terminal"
        static let CHAT = "chat"
        static let END = "end"
        static let SPLASHSCREEN = "splashscreen"
       
    }
    struct LineTypes
    {
        static let TEXT = "TEXT"
        static let MACRO = "MACRO"
        static let SYSTEM = "SYSTEM"
        
    }
    struct ROW {
        static let CHAT = "Chat"
        static let LINE_CHAT = "LineChat"
        static let CHOICE_CHAT = "ChoiceChat"
        
        static let LINE_TERMINAL = "LineTerminal"
        static let CHOICE_TERMINAL = "ChoiceTerminal"
        static let SPLASH = "Splash"
        
        
    }
    
    struct ParseKeys
    {
        static let DEV_APPID = "koTAVvfEvc84kzl20e5plYgCEm6f6cS6AWhs1qUF"
        static let DEV_CLIENT_KEY = "BcvV8fOzaaRmdRb6mBNSxLwJpy15E14YFGjmXn7i"
        static let PROD_APPID = "KFcJ3IWfKuEp6uRJVAUtjdB3ECd1e8vKInpo4wMs"
        static let PROD_CLIENT_KEY = "HyC0Bm4JwSUSTHNC05bg9QnuydA87NdDl2q5wE4o"
        static let BRAD_APPID = "EPH4Cdy6nUeFy0CphWqgkkwEzZsu1GIYfIvY1IQD"
        static let BRAD_CLIENT_KEY = "1nIznOkLmVqHtiRKOubFeaxNlqsksqBkhfFfzGyb"
    }
    
    struct Macros
    {
        static let SET = "set"
        //static let WAIT = "wait"
        static let AUDIO = "audio"
        static let IF = "if"
        static let THEN = "then"
        static let ELSE = "else"
        static let ELSEIF = "elseif"
        //static let PAUSE = "pause"
        //static let TYPING = "typing"
        //static let TIME = "time"
        static let BUSY = "busy"
        static let DISPLAY = "display"
        static let GOTO = "goto"
        static let CLOSEIF = "/if"
    }
    
    struct RegexMacros
    {
        static let REGEX = "\\<\\<(set|afk|audio|display|goto|time)(?:[\\s\"\\=]+)?(\\$[a-z]+)?(?:[\\s\"\\=]+)?([A-Za-z0-9\\s\\,\\?\\'\\.\\!]+)?(?:[\\s\"\\=\\+]+)?([0-9]+)?(?:s)?\\>?\\>?"
        static let FLOW_CONTROL_REGEX = "\\<\\<(\\/?if|elseif|else|then)(?:\\s)?(\\$[a-z]+)?(?:\\s)?([a-z]+)?(?:\\s)?([0-9]+)?\\>?\\>?"
        static let NOTIFICATION_REGEX = "(?!\\/\\%)\\<\\<(busy)\\s?([0-9]+)s(?:\\s\")?([A-Za-z0-9\\s\\[\\]\\,\\:\\;\\?\\'\\.\\-\\(\\)\\!\\/]+)?\"?\\>\\>([A-Za-z0-9\\s\\[\\]\\,\\:\\;\\?\\'\"\\.\\-\\(\\)\\!]+)?(?:\\<\\<\\/busy\\>\\>)?"
        static let STORY_VALUE_SIGN = "(\\+|\\-)([0-9]+)"
    }
    
    struct ConditionalExpresions
    {
        static let EQUAL = "eq"
        static let NOT = "not"
        static let AND = "and"
        static let OR = "or"
        static let GREATER = "gt"
        static let GREATER_OR_EQUAL = "gte"
        static let LESS = "lt"
        static let LESS_OR_EQUAL = "lte"
       
        
    }
    
    struct GlobalVariables
    {
        static var WAIT  = 0
        static var TYPING  = 0
        static var CHAPTER_LIMIT = 100
        static var PASSAGE_LIMIT = 1000
        static var RESET_PLAYER_PROGRESS = true
    }
    
    
    
}