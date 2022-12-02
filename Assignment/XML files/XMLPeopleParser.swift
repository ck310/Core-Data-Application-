//
//  XMLPeopleParser.swift
//  Assignment02
//
//  Created by C Karthika on 02/04/2022.
//

import Foundation

class XMLPeopleParser:NSObject, XMLParserDelegate {
    
    // init
    var name : String!
    init(fileName:String){
        self.name = fileName
}
    // parsing vars
    var pName, pGender, pAge, pPhone, pDetails, pImage: String!// tmp vars for texts
    var tagId : Int = -1; var passData = false // spy vars
    
    // tags
    var tags = ["name", "gender", "age", "phone", "details", "image"]
    
    // data vars
    var peopleData = [Patient]()
    var patientData : Patient!
    
    // parser obj
    var parser = XMLParser()
    
    // methods to override
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // set the spys
        if tags.contains(elementName){
            passData = true
            
            switch elementName {
            case "name"    : tagId = 0
            case "gender"  : tagId = 1
            case "age"     : tagId = 2
            case "phone"   : tagId = 3
            case "details" : tagId = 4
            case "image"   : tagId = 5
            default:break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // reset spies if new tag found
        if tags.contains(elementName){
            passData = false
            tagId    = -1
        }
      
        // found person then make an person object and add it to dictionary
        if elementName == "patient"{
            let patient = Patient(name: pName, gender: pGender, age: pAge, phone: pPhone, details: pDetails, image: pImage)
            peopleData.append(patient)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // test spies and store in pVar the found string
        if passData{
            switch tagId {
            case 0 : pName    = string
            case 1 : pGender  = string
            case 2 : pAge     = string
            case 3 : pPhone   = string
            case 4 : pDetails = string
            case 5 : pImage   = string
            default: break
                
            }
        }
    }
    
    // method to parsing
    func startParsing(){
        //get to the xml file
        let bundlePath = Bundle.main.bundleURL
        let xmlPath = URL(fileURLWithPath: name, relativeTo: bundlePath)
        
        parser = XMLParser(contentsOf: xmlPath)!
        parser.delegate = self
        parser.parse()
    }
}

