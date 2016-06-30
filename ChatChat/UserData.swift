//
//  UserData.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 16/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

class UserData
{
    static var ID : String = ""
    static var username : String = ""
    static var image = NSData? ()
    
    /*
    static func LoadRealID  ()
    {
        // Try Load ID
        let realIDURL = GetFilesURL ("ID")
        
        do {
            realID = try NSString (contentsOfURL: realIDURL, encoding: NSUTF8StringEncoding) as String
        } catch {
            print ("Error loading ID")
        }
        
        // Load succeful
        if (!realID.isEmpty) {
            return
        }
        
        // Load failed, generate and save ID
        realID = NSUUID().UUIDString
        
        do {
            try realID.writeToURL (realIDURL, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print ("Error saving ID")
        }
    }
    */
    
    static func LoadUserImage ()
    {
        // Load Image
        let imageURL = GetImageURL("Profile Image.png")
        let imageData = NSData (contentsOfURL: imageURL)
        
        // imageView.image = UIImage (data: imageData!)
        
        image = imageData
    }
    
    static func LoadUserName ()
    {
        let usernameURL = GetFilesURL("username")
        
        do {
            let name = try NSString(contentsOfURL: usernameURL, encoding: NSUTF8StringEncoding) as String
            username = name;
        } catch {
            print ("Error loading username")
        }
    }
    
    static func SaveUserImage (imageData : NSData)
    {
        let imageURL = GetImageURL("Profile Image.png")
        
        imageData.writeToURL(imageURL, atomically: true)
        
        image = imageData
    }
    
    static func SaveUserName (name : String)
    {
        if (name.isEmpty) {
            return
        }
        
        let usernameURL = GetFilesURL("username")
        
        do {
            try name.writeToURL(usernameURL, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print ("Error saving username")
        }
        
        username = name;
    }
    
    static func GetImageURL (imagename : String) -> NSURL
    {
        let documentsImageURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let imageURL = documentsImageURL!.URLByAppendingPathComponent(imagename)
        
        return imageURL
    }
    
    static func GetFilesURL (filename : String) -> NSURL
    {
        let documentsUsernameURL = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let fileURL = NSURL (fileURLWithPath: documentsUsernameURL!).URLByAppendingPathComponent(filename)
        
        return fileURL
    }
}