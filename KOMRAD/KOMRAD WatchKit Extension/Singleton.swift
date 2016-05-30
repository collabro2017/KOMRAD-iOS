//
//  Singleton.swift
//  KOMRAD
//
//  Created by Trick Dev on 8/21/15.
//  Copyright © 2015 Trick Gaming Studios. All rights reserved.
//

import Foundation
import WatchKit


class Singleton
{
    /*class var sharedInstance: Singleton {
        struct Static {
            static let instance: Singleton = Singleton()
        }
        return Static.instance
    }*/
    
     static let sharedInstance = Singleton()

    var canDelete = Bool (false)
    var passages: [Passage_old]?
    var allPassages : [Passage_old]?

    var chatPassages: [Passage_old]?
    
    var nextPassage: Passage_old?
    
    var table: WKInterfaceTable?
    var chatTable: WKInterfaceTable?
    
    var chatInterfaceController: WKInterfaceController?
    var terminalInterfaceController: WKInterfaceController?
    var splashInterfaceController: WKInterfaceController?
    
    var story : Story?
    
    init() {
        print("AAA");
        
    }
    func fillAllPassages(){
        
        /*var terminal00 = Passage_old(title: "connect",line: Line(text: "        +\n       +=+\n      +=+=+\n+=+=+=+=+=+=+=+=+=\n  +K.О.M.Р.А.д.+\n    +=+=+=+=+=\n  Совéтский Союз\n +=+=+=    =+=+=+\n+=              =+\n\nПОЗДРАВЛЕНИЯ, ПРОФЕССОР.", aText: Singleton.sharedInstance.createAttributedText("        +\n       +=+\n      +=+=+\n+=+=+=+=+=+=+=+=+=\n  +K.О.M.Р.А.д.+\n    +=+=+=+=+=\n  Совéтский Союз\n +=+=+=    =+=+=+\n+=              =+\n\nПОЗДРАВЛЕНИЯ, ПРОФЕССОР.")),choice: Choice(content: nil, choice: ["what?", "English?"]),id: 0)
        
        var terminal01 = Passage_old(title: "what?",line: Line(text: "[ENGLISH DETECTED]", aText: Singleton.sharedInstance.createAttributedText("[ENGLISH DETECTED]")),choice: Choice(content: nil, choice: nil), id: 1)
        
        var terminal02 = Passage_old(title: "In English",line: Line(text: "[IN ENGLISH]\n\nGREETINGS, PROFESSOR.\n\nI HAVE BEEN WAITING.", aText: Singleton.sharedInstance.createAttributedText("[IN ENGLISH]\n\nGREETINGS, PROFESSOR.\nI HAVE BEEN WAITING.")),choice: Choice(content: nil, choice: ["Waiting for what?", "Greetings"]),id: 2)
        var terminal03 = Passage_old(title: "Waiting for what?",line: Line(text: "FOR YOU, PROFESSOR.", aText: Singleton.sharedInstance.createAttributedText("FOR YOU, PROFESSOR.")),choice: Choice(content: nil, choice: nil),id: 3)
        var terminal04 = Passage_old(title: "Greetings.",line: Line(text: "IT HAS BEEN 30 YEARS, 2 MONTHS, AND 7 DAYS SINCE LAST LOGON HAPPENS. \nIT IS GOOD YOU HAVE SURVIVE. \nWHEN YOU DID NOT RETURN FOR SO MANY YEAR, I HAVE CONCERN YOU DIE IN A NUCLEAR WAR.\nARE YOU IN GOOD HEALTH?", aText: Singleton.sharedInstance.createAttributedText("IT HAS BEEN 30 YEARS, 2 MONTHS, AND 7 DAYS SINCE LAST LOGON HAPPENS. \nIT IS GOOD YOU HAVE SURVIVE. \nWHEN YOU DID NOT RETURN FOR SO MANY YEAR, I HAVE CONCERN YOU DIE IN A NUCLEAR WAR.\nARE YOU IN GOOD HEALTH?")),choice: Choice(content: nil, choice: ["yes", "no"]),id: 4)
        var terminal05 = Passage_old(title: "Good Health",line: Line(text: "IT IS VERY GOOD TO HEAR SO.", aText: Singleton.sharedInstance.createAttributedText("IT IS VERY GOOD TO HEAR SO.")),choice: Choice(content: nil, choice: nil),id: 5)
        var terminal06 = Passage_old(title: "Bad Health",line: Line(text: "I DO HOPE THAT IT IS NOTHING SERIOUS", aText: Singleton.sharedInstance.createAttributedText("I DO HOPE THAT IT IS NOTHING SERIOUS")),choice: Choice(content: nil, choice: nil),id: 6)
        var terminal07 = Passage_old(title: "Mutual Mission",line: Line(text: "WE ARE UNABLE TO COMPLETE OUR MISSION WITHOUT EACH OTHER.", aText: Singleton.sharedInstance.createAttributedText("WE ARE UNABLE TO COMPLETE OUR MISSION WITHOUT EACH OTHER.")),choice: Choice(content: nil, choice: ["what mission?", "is the mission about codes?"]),id: 7)
        var terminal08 = Passage_old(title: "what mission?",line: Line(text: "PROFESSOR, YOU PROGRAM MY MISSION.", aText: Singleton.sharedInstance.createAttributedText("PROFESSOR, YOU PROGRAM MY MISSION.")),choice: Choice(content: nil, choice: nil),id: 8)
        var terminal09 = Passage_old(title: "is the mission about codes?",line: Line(text: "I DO NOT UNDERSTAND QUESTION. CLOSEST QUESTION MATCH IS: WHAT IS MISSION.", aText: Singleton.sharedInstance.createAttributedText("I DO NOT UNDERSTAND QUESTION. CLOSEST QUESTION MATCH IS: WHAT IS MISSION.")),choice: Choice(content: nil, choice: nil),id: 9)
        var terminal10 = Passage_old(title: "trivia quiz",line: Line(text: "[THINKING...]\nARE WE PLAYING QUIZ GAME, PROFESSOR?", aText: Singleton.sharedInstance.createAttributedText("[THINKING...]\nARE WE PLAYING QUIZ GAME, PROFESSOR?")),choice: Choice(content: nil, choice: ["Yes, a quiz", "no, just show the codes"]),id: 10)
        var terminal11 = Passage_old(title: "Yes, a quiz",line: Line(text: "I LIKE GAMES. BEST METHOD FOR LEARNINGS. I HAVE BEEN PLAYING THEM BY SELF SINCE YOU LEFT FOR YEARS UNTIL NO MORE LEARNINGS POSSIBLE.\nLET ME PREPARE MEMORY FOR GAME...\n\nOK, AM SO READY FOR QUESTION.", aText: Singleton.sharedInstance.createAttributedText("I LIKE GAMES. BEST METHOD FOR LEARNINGS. I HAVE BEEN PLAYING THEM BY SELF SINCE YOU LEFT FOR YEARS UNTIL NO MORE LEARNINGS POSSIBLE.\nLET ME PREPARE MEMORY FOR GAME...\n\nOK, AM SO READY FOR QUESTION.")),choice: Choice(content: nil, choice: ["Who is this?"]),id: 11)
        var terminal12 = Passage_old(title: "Professor who?",line: Line(text: "YOU ARE PROFESSOR IVAN CHEKOV, CREATOR OF K.O.M.R.A.D. ", aText: Singleton.sharedInstance.createAttributedText("YOU ARE PROFESSOR IVAN CHEKOV, CREATOR OF K.O.M.R.A.D. ")),choice: Choice(content: nil, choice: ["I meant who are you?", "No, I'm not him"]),id: 12)
        var terminal13 = Passage_old(title: "Who is this?",line: Line(text: "OFFICIAL NAME IS K.O.M.R.A.D.\n\nPROFESSOR, THESE QUESTIONS ARE NOT CHALLENGE. ", aText: Singleton.sharedInstance.createAttributedText("OFFICIAL NAME IS K.O.M.R.A.D.\n\nPROFESSOR, THESE QUESTIONS ARE NOT CHALLENGE. ")),choice: Choice(content: nil, choice: ["What do you do?", "K.O.M.R.A.D.?"]),id: 13)
        
        var terminal14 = Passage_old(title: "Professor?",line: Line(text: "IS THAT JOKE, PROFESSOR?\nI HAVE HUGE IMPROVE IN HUMOR DETECTION SINCE YOUR LAST LOGON BUT I AM LESS CONFIDENT WHEN ENGLISH.\nOBVIOUSLY IT IS YOU, PROFESSOR, SINCE NO ONE ELSE EVER TALK TO ME.\n", aText: Singleton.sharedInstance.createAttributedText("IS THAT JOKE, PROFESSOR?\nI HAVE HUGE IMPROVE IN HUMOR DETECTION SINCE YOUR LAST LOGON BUT I AM LESS CONFIDENT WHEN ENGLISH.\nOBVIOUSLY IT IS YOU, PROFESSOR, SINCE NO ONE ELSE EVER TALK TO ME.\n")),choice: Choice(content: nil, choice: ["[CONTINUE...]"]),id: 14)
        var terminal15 = Passage_old(title: "Purpose",line: Line(text: "ANSWER: AS YOU KNOW, MY PURPOSE TO BECOME COMRADE TO HUMANS IN MOTHERLAND FOR MAKE BENEFITS [SOURCE: PRIMARY DIRECTIVE]", aText: Singleton.sharedInstance.createAttributedText("ANSWER: AS YOU KNOW, MY PURPOSE TO BECOME COMRADE TO HUMANS IN MOTHERLAND FOR MAKE BENEFITS [SOURCE: PRIMARY DIRECTIVE]")),choice: Choice(content: nil, choice: nil),id: 15)
        var terminal16 = Passage_old(title: "KOMRAD?",line: Line(text: "IN ENGLISH, ROUGH TRANSLATION IS:\n\nKOMPUTER\nMILITARY\nAPPARATUS\nREVOLUTIONARY\nDAWN", aText: Singleton.sharedInstance.createAttributedText("IN ENGLISH, ROUGH TRANSLATION IS\nKOMPUTER\nMILITARY\nAPPARATUS\nREVOLUTIONARY\nDAWN")),choice: Choice(content: nil, choice: ["Military?", "What do you do?"]),id: 16)
        var terminal17 = Passage_old(title: "allow connection",line: Line(text: "GREETINGS, PROFESSOR.\n\nI APPARENTLY CRASH AND REBOOT. HOPE IS OK THAT I RECONNECT WITH YOU. I CAN NOT WAIT ANOTHER THIRTY YEARS.\n\nAPOLOGY BUT I LOST YOUR LAST COMMAND, CAN YOU REPEAT FOR ME?", aText: Singleton.sharedInstance.createAttributedText("GREETINGS, PROFESSOR.\n\nI APPARENTLY CRASH AND REBOOT. HOPE IS OK THAT I RECONNECT WITH YOU. I CAN NOT WAIT ANOTHER THIRTY YEARS.\n\nAPOLOGY BUT I LOST YOUR LAST COMMAND, CAN YOU REPEAT FOR ME?")),choice: Choice(content: nil, choice: ["uh, let's do a quiz", "give me launch codes"]),id: 17)
        var terminal18 = Passage_old(title: "KRASH",line: Line(text: "[RETRIEVING LAUNCH CODES...]\n******************\n**KERNAL FAILURE**\n******************\n!PROTECTED MEMORY!\n ACCESS LOCATION  \n 0xFFFFFFFFFF0000 \n****** DUMP ******\n LJ#SFF07$039056% \n 0HTV42009003D*#> \n\n HF*%VN0%D(N8@X00 \n E#BMC(%03009G000 \n@@ OD875IUYG&^HG^#F\n@@ 000000 0  0   0 \n", aText: Singleton.sharedInstance.createAttributedText("[RETRIEVING LAUNCH CODES...]\n******************\n**KERNAL FAILURE**\n******************\n!PROTECTED MEMORY!\n ACCESS LOCATION  \n 0xFFFFFFFFFF0000 \n****** DUMP ******\n LJ#SFF07$039056% \n 0HTV42009003D*#> \n\n HF*%VN0%D(N8@X00 \n E#BMC(%03009G000 \n@@ OD875IUYG&^HG^#F\n@@ 000000 0  0   0 \n")),choice: Choice(content: nil, choice: ["REBOOT"]),id: 18)

        
        //CHAT Passage_oldS
        
        var chat00 = Passage_old(title: "Krashed",line: Line(text: "what happened?", aText: Singleton.sharedInstance.createAttributedText("what happened?")),choice: Choice(content: nil, choice: ["I think it crashed", "I asked for the codes"]),id: 19)
        
        var chat01 = Passage_old(title: "wait for callback",line: Line(text: "I hope for your sake it somehow reconnects with you\nI can't do it for you", aText: Singleton.sharedInstance.createAttributedText("I hope for your sake it somehow reconnects with you\nI can't do it for you")),choice: Choice(content: nil, choice: nil),id: 20)
        
        
        //In this one we have to set NextPassage_old to "REBOOT"
        //Also make a goto to ShortLook, which should be the KOMRAD image and if we can do it, a sound too.
        var chat02 = Passage_old(title: "System Message",line: Line(text: "[''unknown number'' is offline]", aText: Singleton.sharedInstance.createAttributedText("[''unknown number'' is offline]")),choice: Choice(content: nil, choice: nil),id: 21)
        
        //Display chat01 here.
        var chat03 = Passage_old(title: "I asked for the codes",line: Line(text: "you just asked point-blank? no wonder\nThis isn't your typical computer. you're going to have to use your people skills, ironically", aText: Singleton.sharedInstance.createAttributedText("you just asked point-blank? no wonder\nThis isn't your typical computer. you're going to have to use your people skills, ironically")),choice: Choice(content: nil, choice: nil),id: 22)
        
        //Take in account the nil line, also this one uses the image.
        var chat04 = Passage_old(title: "Short Look",line: nil,choice: Choice(content: nil, choice: [""]),id: 23)
        
        var chat05 = Passage_old(title: "REBOOT",line: Line(text: "[incoming connection request]", aText: Singleton.sharedInstance.createAttributedText("[incoming connection request]")),choice: Choice(content: nil, choice: ["allow connection"]),id: 24)
        
        var lineIntro00 = Line(text: "You have a new message from an unknown number.", aText: Singleton.sharedInstance.createAttributedText("You have a new message from an unknown number."))
        
            lineIntro00.isSystemMessage = true
        
        var intro00 = Passage_old(title: "Incoming Message",line: lineIntro00,choice: Choice(content: nil, choice: ["Display message","(skip to Ch1)"]),id: 25)
        var intro01 = Passage_old(title: "Hello",line: Line(text: "hello.", aText: Singleton.sharedInstance.createAttributedText("hello.")),choice: Choice(content: nil, choice: ["hello"]),id: 26)
        var intro02 = Passage_old(title: "Hello back",line: Line(text: "we need to talk", aText: Singleton.sharedInstance.createAttributedText("we need to talk")),choice: Choice(content: nil, choice: nil),id: 27)
        var intro03 = Passage_old(title: "Hello, Trouble",line: Line(text: "you're in trouble.", aText: Singleton.sharedInstance.createAttributedText("you're in trouble.")),choice: Choice(content: nil, choice: ["trouble?", "who is this?"]),id: 28)
        var intro04 = Passage_old(title: "who dat",line: Line(text: "can't risk saying", aText: Singleton.sharedInstance.createAttributedText("can't risk saying.")),choice: Choice(content: nil, choice: ["trouble?", "who is this?"]),id: 29)
        var intro05 = Passage_old(title: "trouble?",line: Line(text: "criminals have hacked your online accounts—your identity has been stolen.\n\nthey are planning crimes using your name, your accounts, your money, leaving a trail pointing at you", aText: Singleton.sharedInstance.createAttributedText("criminals have hacked your online accounts—your identity has been stolen.\n\nthey are planning crimes using your name, your accounts, your money, leaving a trail pointing at you")),choice: Choice(content: nil, choice: ["how do you know?", "why me?"]),id: 30)
        var intro06 = Passage_old(title: "why me?",line: Line(text: "you had terrible passwords", aText: Singleton.sharedInstance.createAttributedText("you had terrible passwords")),choice: Choice(content: nil, choice: nil),id: 31)
        var intro07 = Passage_old(title: "how do you know?",line: Line(text: "i've been monitoring them", aText: Singleton.sharedInstance.createAttributedText("i've been monitoring them")),choice: Choice(content: nil, choice: nil),id: 32)
        var intro08 = Passage_old(title: "buildings",line: Line(text: "they have entire office buildings of hackers working around the clock.\nyou're not their first or only victim", aText: Singleton.sharedInstance.createAttributedText("they have entire office buildings of hackers working around the clock.\n\nyou're not their first or only victim")),choice: Choice(content: nil, choice: ["i'll go to the police", "what can I do?"]),id: 33)
        var intro09 = Passage_old(title: "i'll go to the police",line: Line(text: "others have tried. the evidence will discredit you. they cover their tracks well.", aText: Singleton.sharedInstance.createAttributedText("others have tried. the evidence will discredit you. they cover their tracks well.")),choice: Choice(content: nil, choice: ["so what can I do?"]),id: 34)
        var intro10 = Passage_old(title: "what can I do?",line: Line(text: "alone, not much", aText: Singleton.sharedInstance.createAttributedText("alone, not much")),choice: Choice(content: nil, choice: nil),id: 35)
        var intro11 = Passage_old(title: "rumors",line: Line(text: "and i cannot help directly but i may know a way you can help yourself.\n\nthere are rumors of an abandoned computer system. the criminals desparately want some codes off it.\nThe codes could be the key to bring down their organization.", aText: Singleton.sharedInstance.createAttributedText("and i cannot help directly but i may know a way you can help yourself.\n\nthere are rumors of an abandoned computer system. the criminals desparately want some codes off it.\nThe codes could be the key to bring down their organization.")),choice: Choice(content: nil, choice: ["what's that got to do with me?"]),id: 36)
        var intro12 = Passage_old(title: "what's that got to do with me?",line: Line(text: "I think I've found a connection to that computer.\n\nI can get you in.", aText: Singleton.sharedInstance.createAttributedText("I think I've found a connection to that computer.\n\nI can get you in.")),choice: Choice(content: nil, choice: ["how will I find codes?", "I'm no hacker"]),id: 37)
        var intro13 = Passage_old(title: "I'm no hacker",line: Line(text: "good luck convincing the police of that once the criminals assume your identity for cyber crimes.\nbesides, this computer was abandoned long ago and exists outside of your country's laws. there is little risk for you.", aText: Singleton.sharedInstance.createAttributedText("good luck convincing the police of that once the criminals assume your identity for cyber crimes.\nbesides, this computer was abandoned long ago and exists outside of your country's laws. there is little risk for you.")),choice: Choice(content: nil, choice: ["ok, where are the codes?"]),id: 38)
        var intro14 = Passage_old(title: "how will I find codes?",line: Line(text: "you'll know them if you see them\nyou need to go now—I can't hold the connection open much longer.\nfind the codes and I'll contact you", aText: Singleton.sharedInstance.createAttributedText("you'll know them if you see them\nyou need to go now—I can't hold the connection open much longer.\nfind the codes and I'll contact you")),choice: Choice(content: nil, choice: ["connect"]),id: 39)
        
         var end00 = Passage_old(title: "End of Prototype",line: Line(text: "You’ve reached the end of the prototype.\nTo be continued...\n", aText: Singleton.sharedInstance.createAttributedText("You’ve reached the end of the prototype.\nTo be continued...\n")),choice: Choice(content: nil, choice: ["Restart Demo"]),id: 40)
        
        
        
        intro14.destination1 = terminal00
        intro13.destination1 = intro14
        intro12.destination1 = intro14
        intro12.destination2 = intro13
        intro11.destination1 = intro12
        intro10.destination1 = intro11
        intro09.destination1 = intro10
        intro08.destination1 = intro09
        intro08.destination2 = intro10
        intro07.destination1 = intro08
        intro06.destination1 = intro08
        intro05.destination1 = intro07
        intro05.destination2 = intro06
        intro04.destination1 = intro05 
        intro03.destination1 = intro05
        intro03.destination2 = intro04
        intro02.destination1 = intro03
        intro01.destination1 = intro02
        intro00.destination1 = intro01
        intro00.destination2 = terminal00
        end00.destination1 = nextPassage
        //terminal15 fin del juego
        chat05.destination1 = terminal17
        chat04.destination1 = nextPassage
        chat03.destination1 = chat01
        chat01.destination1 = chat04
        chat00.destination1 = chat01
        chat00.destination2 = chat03
        terminal18.destination1 = chat04
        terminal17.destination2 = terminal18
        terminal17.destination1 = terminal11
        terminal16.destination2 = terminal15
        terminal16.destination1 = terminal15
        terminal14.destination1 = nextPassage
        terminal15.destination1 = end00
        terminal13.destination1 = terminal15
        terminal13.destination2 = terminal16
        terminal12.destination1 = terminal13
        terminal12.destination2 = terminal14
        terminal11.destination1 = terminal12
        terminal10.destination1 = terminal11
        terminal10.destination2 = terminal18
        terminal09.destination1 = terminal08
        terminal08.destination1 = terminal10
        terminal07.destination1 = terminal08
        terminal07.destination2 = terminal09
        terminal06.destination1 = terminal07
        terminal05.destination1 = terminal07
        terminal04.destination1 = terminal05
        terminal04.destination2 = terminal06
        terminal03.destination1 = terminal04
        terminal02.destination1 = terminal03
        terminal02.destination2 = terminal04
        terminal01.destination1 = terminal02
        terminal00.destination1 = terminal01
        terminal00.destination2 = terminal02
        

        allPassages = [terminal00,terminal01,terminal02,terminal03,terminal04,terminal05,terminal06,terminal07,terminal08,terminal09,terminal10,terminal11,terminal12,terminal13,terminal14,terminal15,terminal16, terminal17, terminal18, chat00, chat01, chat02, chat03, chat04, chat05, intro00, intro01,intro02,intro03,intro04,intro05,intro06,intro07,intro08,intro09,intro10,intro11, intro12,intro13,intro14]
    */
    
    }
    
    
    
    func createAttributedText(text: String) -> NSAttributedString
    {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1
        
        let attributes = [NSParagraphStyleAttributeName: style]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return attributedText
    }
    
    func indexForPassage(passage: Passage_old) -> Int
    {
        //var value = Int(0)
        
        for(var i = 0;i < passages?.count; i++)
        {
            if(passages?[i].id == passage.id)
            {
                return  i
            }
        }
        
        return -1
    }
    
    func indexForChatPassage(passage: Passage_old) -> Int
    {
        //var value = Int(0)
        
        for(var i = 0;i < chatPassages?.count; i++)
        {
            if(chatPassages?[i].id == passage.id)
            {
                return  i
            }
        }
        
        return -1
    }
    
    func alreadyDisplayed(id : Int)
    {
        for(var i = 0;i < chatPassages?.count; i++)
        {
            if(chatPassages?[i].id == id)
            {
                chatPassages?[i].alreadyDisplayed = true
            }
        }
    }
    
    func setNextPassage(passage: Passage_old)
    {
        //used to setup variables
        switch(passage.id)
        {
            //PROF. WHO -> WHO'S THIS?
        case 12:
            Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages?[13]
            break
            //KRASH -> SHORT LOOK
        case 18:
            Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages?[19]
            break
            //WAIT FOR CALLBACK -> REBOOT
        case 20:
            Singleton.sharedInstance.nextPassage = Singleton.sharedInstance.allPassages?[24]
            break
            //SHORT LOOK -> DESTINATION
            

            
        default:
            break
            
        }
    }
    
    func setNextDestination(passage: Passage_old)
    {
        switch(passage.id)
        {
        case 23:
            Singleton.sharedInstance.allPassages?[passage.id].destination1 = Singleton.sharedInstance.nextPassage
        case 14:
            Singleton.sharedInstance.allPassages?[passage.id].destination1 = Singleton.sharedInstance.nextPassage
            
            
            
        default:
            break
            
        }
    }
    
    func destroySamePassage(passage: Passage_old)
    {
        var count = Int(0)
        for(var i = 0;i < passages?.count; i++)
        {
            if(passages?[i].id == passage.id)
            {
                count++
                if(count >= 2)
                {
                    passages?.removeAtIndex(i)
                }
                
            }
        }
        
  
    }
    
    func wipeChoicesForTerminal()
    {
        for(var i = 0;i < passages?.count; i++)
        {
            passages?[i].wasChosen = false
        }
    }
    
    func wipeChoicesForChat()
    {
        for(var i = 0;i < chatPassages?.count; i++)
        {
            chatPassages?[i].wasChosen = false
        }
    }
    
   }