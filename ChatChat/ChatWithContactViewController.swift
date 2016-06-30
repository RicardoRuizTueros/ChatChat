//
//  ChatWithContactViewController.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 14/6/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController

class ChatWithContactViewController : ChatViewController
{
    var contact : Contact = Contact (ID: "", username: "", image: NSData (), channelID: "", channelKey: "")
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        messageRef = rootRef.childByAppendingPath("Messages").childByAppendingPath(contact.channelID)
    }
    
    override internal func observeMessages ()
    {
        let messagesQuery = messageRef.queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            
            let id = snapshot.value["Sender ID"] as! String
            let encryptedText = snapshot.value["Message"] as! String
    
            let text = CustomCrypto.DecryptMessage (encryptedText, channelKey: self.contact.channelKey)
            
            self.addMessage(id, text: text)
            
            self.finishReceivingMessage()
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        let itemRef = messageRef.childByAutoId() // 1
        
        let encryptedText = CustomCrypto.EncryptMessage (text, channelKey: contact.channelKey)
        
        let messageItem = [
            "Sender ID": UserData.ID,
            "Message": encryptedText
        ]
        
        itemRef.setValue(messageItem) // 3
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        isTyping = false
    }

}