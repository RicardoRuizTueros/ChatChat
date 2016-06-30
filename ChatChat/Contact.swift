//
//  Contact.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 8/6/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

@objc class Contact : NSObject
{
    var ID : String = ""
    var username : String = ""
    var image : NSData = NSData ()
    var channelID : String = ""
    var channelKey : String = ""
    
    init (ID : String, otherID : String, username : String, image : NSData, channelKey : [UInt8])
    {
        self.ID = ID
        self.username = username
        self.image = image
        
        let channelKeyHex = channelKey.toHexString()
        self.channelKey = channelKeyHex.substringToIndex(channelKeyHex.startIndex.advancedBy(32))
        
        if (ID < otherID) {
            self.channelID = (ID.substringToIndex(ID.startIndex.advancedBy (5)) + otherID.substringToIndex(otherID.startIndex.advancedBy (5)))
        } else {
            self.channelID = (otherID.substringToIndex(otherID.startIndex.advancedBy (5)) + ID.substringToIndex(ID.startIndex.advancedBy (5)))
        }
    }
    
    init (ID : String, username : String, image : NSData, channelID : String, channelKey : String)
    {
        self.ID = ID
        self.username = username
        self.image = image
        self.channelID = channelID
        self.channelKey = channelKey
    }
    
    internal func SaveContact ()
    {
        let filesURL = Contact.GetFilesURL ("Contacts")
        let fileManager = NSFileManager.defaultManager()
        
        // Create contacts file if not exist
        if (!fileManager.fileExistsAtPath (filesURL.path!)) {
            fileManager.createFileAtPath(filesURL.path!, contents: nil, attributes: nil)
        }
        
        // Check if contact already exists
        let contacts : [String] = (try! String (contentsOfURL: filesURL, encoding: NSUTF8StringEncoding)).componentsSeparatedByString("\n")
        
        for (_, contact) in contacts.enumerate() {
            let contactData = contact.characters.split{$0 == " "}.map(String.init)
            if (!contactData.isEmpty && contactData [0] == ID) {
                return
            }
        }
        
        // Save new contact
        let imageBase64 = image.base64EncodedStringWithOptions (.Encoding64CharacterLineLength)
        var contactString = (ID + "#" + username + "#" + imageBase64)
        contactString = contactString + "#" + channelID + "#" + channelKey + ";"
        
        let data = contactString.dataUsingEncoding (NSUTF8StringEncoding)
        
        let fileHandler = NSFileHandle (forWritingAtPath: filesURL.path!)
        
        fileHandler!.seekToEndOfFile()
        fileHandler!.writeData(data!)
        fileHandler!.closeFile()
    }
    
    internal static func LoadContacts () -> [Contact]
    {
        let filesURL = Contact.GetFilesURL ("Contacts")
        let fileManager = NSFileManager.defaultManager()
        
        // Return empty list if tile does not exists
        if (!fileManager.fileExistsAtPath (filesURL.path!)) {
            print ("No contacts loaded..")
            return []
        }
        
        print ("Contacts loaded!")
        
        // Get contacts in file
        let contactsLine : [String] = (try! String (contentsOfURL: filesURL, encoding: NSUTF8StringEncoding)).componentsSeparatedByString(";")
        var contacts : [Contact] = []
        
        // Create an array of contacts objects
        for (_, contactLine) in contactsLine.enumerate() {
            if (!contactLine.isEmpty) {
                let contactData = contactLine.componentsSeparatedByString("#")
                let contactImage = NSData (base64EncodedString: contactData [2], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!

                contacts.append(Contact (ID: contactData [0], username: contactData [1], image: contactImage, channelID: contactData [3], channelKey: contactData [4]))
            }
        }
        
        return contacts
    }
    
    private static func GetFilesURL (filename : String) -> NSURL
    {
        let documentsURL = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let fileURL = NSURL (fileURLWithPath: documentsURL!).URLByAppendingPathComponent(filename)
        
        return fileURL
    }
}