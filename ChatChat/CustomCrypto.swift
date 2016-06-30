//
//  CustomCrypto.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 20/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import CryptoSwift

class CustomCrypto
{
    static var keyPKCS5 : [UInt8] = [UInt8.allZeros]
    static var iv = "0123456789012345" // Random 16 bytes
    
    static func EncryptUserData (realID : String, username : String, image : NSData) -> String
    {
        let key = SubKey()
        
        let encryptedID = try! realID.encrypt(AES(key: key, iv: iv)).toBase64()
        let encryptedUsername = try! username.encrypt(AES(key: key, iv: iv)).toBase64()
        let encryptedImage = try! (image.encrypt (AES (key: key, iv: iv))).arrayOfBytes().toBase64()
        
        return encryptedID! + " " + encryptedUsername! + " " + encryptedImage!
    }
    
    static func DecryptUserData (encryptedUserData : String) -> (String, String, NSData)
    {
        let key = SubKey()
        
        let userData = encryptedUserData.characters.split{$0 == " "}.map(String.init)
        
        let ID = try! userData[0].decryptBase64ToString (AES (key: key, iv: iv))
        let username = try! userData[1].decryptBase64ToString (AES (key: key, iv: iv))
        let image = try! NSData (bytes: userData[2].decryptBase64 (AES (key: key, iv: iv)))
        
        return (ID, username, image)
    }
    
    static func EncryptMessage (message : String, channelKey : String) -> String
    {
        let encryptedMessage = try! message.encrypt (AES (key: channelKey, iv: iv, blockMode: .CBC, padding: PKCS7 ())).toBase64()
        
        return encryptedMessage!
    }
    
    static func DecryptMessage (encryptedMessage : String, channelKey : String) -> String
    {
        let message = try! encryptedMessage.decryptBase64ToString (AES (key: channelKey, iv: iv, blockMode: .CBC, padding: PKCS7 ()))
        
        return message
    }
    
    static func HMACTimed () -> String
    {
        keyPKCS5 = KeyWithPKCS5()
        
        return try! Authenticator.HMAC(key: Array(CustomChirpSDK.ShortKey().utf8), variant: .sha256).authenticate (keyPKCS5).toHexString()
    }
    
    private static func KeyWithPKCS5 () -> [UInt8]
    {
        let timeSalt = TimeSalt ().utf8.map {$0}
        let shortkey = CustomChirpSDK.ShortKey().utf8.map {$0}
            
        let key = try! PKCS5.PBKDF2 (password: shortkey, salt: timeSalt, iterations: 4096, keyLength: shortkey.count, hashVariant: .sha256).calculate()

        return key
    }
    
    private static func SubKey () -> String
    {
        if (keyPKCS5 == [UInt8.allZeros]) {
            keyPKCS5 = KeyWithPKCS5 ()
        }
        
        let keyHex = keyPKCS5.toHexString ()
        
        return keyHex.substringWithRange (keyHex.startIndex..<keyHex.startIndex.advancedBy (32))
    }
    
    private static func TimeSalt () -> String
    {
        // To do ...
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        return "NaCl";
    }
}
