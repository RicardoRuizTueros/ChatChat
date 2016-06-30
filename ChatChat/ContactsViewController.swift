//
//  ContactsViewController.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 11/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

@objc class ContactsViewControler : UIViewController
{
    @IBOutlet weak var contactsScroll: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chirpWave: ChirpWaveformView!
    let URLRef = Firebase(url: "https://resplendent-fire-2168.firebaseio.com/")
    
    var messageReferenceSender: Firebase!
    var messageReferenceReceiver: Firebase!
    
    var contactChatting : Contact = Contact (ID: "", username: "", image: NSData(), channelID: "", channelKey: "")
    
    @IBOutlet weak var contactChannelID: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set message references
        let messageReference = URLRef.childByAppendingPath("Contact Sync")
        
        messageReferenceSender = messageReference.childByAppendingPath("Sender")
        messageReferenceReceiver = messageReference.childByAppendingPath("Receiver")
        
        // Set Chirp wave
        chirpWave.audioBuffer = CustomChirpSDK.AudioBuffer();
        
        // Load user data
        UserData.LoadUserName()
        UserData.LoadUserImage()
        
        // Initialize Chirp and start listening for shortkeys
        CustomChirpSDK.InitializeChirp()
        CustomChirpSDK.StartListeningShortKey(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // Load contacts after view is loaded because of image selector sieges
        LoadContacts ()
    }
    
    @IBAction func BackToLogin(sender: UIButton)
    {
        // Stop listening for shortkeys
        CustomChirpSDK.StopListening()
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier ("Main")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Called when received chirp with shortkey
    @objc func ReceiveUserSync ()
    {
        messageReferenceReceiver.queryLimitedToLast(1).observeEventType(.ChildAdded)
        {
            (snapshot: FDataSnapshot!) in
            
            let senderID = snapshot.value["Sender ID"] as! String
            let HMAC = snapshot.value["HMAC"] as! String
            let encryptedContactData = snapshot.value["User Data"] as! String
            
            self.AddNewContactReceiver (senderID, HMAC: HMAC, encryptedContactData: encryptedContactData)
        }
    }
    
    private func AddNewContactReceiver (senderID : String, HMAC : String, encryptedContactData : String)
    {
        // Calculate HMAC with own shortkey
        let calculatedHMAC = CustomCrypto.HMACTimed ()

        // Check same HMAC
        if (calculatedHMAC == HMAC) {
            // Send synchronization message
            SendUserSync (messageReferenceSender)
            
            // Add new contact data info
            AddNewContact (senderID, HMAC: HMAC, encryptedContactData: encryptedContactData)
        } else {
            print ("Contact not synched")
            print ("Received HMAC: " + HMAC)
            print ("Calculated HMAC: " + calculatedHMAC)
        }
    }
    
    @IBAction func AddNewContactSender (sender: UIButton)
    {
        // Generate shorkey
        CustomChirpSDK.GenerateShorKey()
        
        // Send synchronization message
        SendUserSync (messageReferenceReceiver)
        
        // Chirp shortkey
        CustomChirpSDK.ChirpShortKey()
        
        // Receive contact data
        messageReferenceSender.queryLimitedToLast(1).observeEventType(.ChildAdded)
        {
            (snapshot: FDataSnapshot!) in
            
            let senderID = snapshot.value["Sender ID"] as! String
            let HMAC = snapshot.value["HMAC"] as! String
            let encryptedContactData = snapshot.value["User Data"] as! String
            
            self.AddNewContact (senderID, HMAC: HMAC, encryptedContactData: encryptedContactData)
        }
    }
    
    private func AddNewContact (senderID : String, HMAC : String, encryptedContactData : String)
    {
        let hmac = CustomCrypto.HMACTimed ()
        
        if (hmac != HMAC) {
            return
        }
        
        let newContactData = CustomCrypto.DecryptUserData (encryptedContactData)
        let newContact = Contact (ID: UserData.ID, otherID: senderID, username: newContactData.1, image: newContactData.2, channelKey: CustomCrypto.keyPKCS5)
        
        AddContactDataToView (0, contact: newContact)
        
        newContact.SaveContact ()
    }
    
    
    private func LoadContacts ()
    {
        let contactList = Contact.LoadContacts()
        
        for (index, contact) in contactList.enumerate() {
            AddContactDataToView (index, contact: contact)
        }
    }
    
    private func AddContactDataToView (index : Int, contact : Contact)
    {
        let singleTap = CustomTapRecognizer (target: self, action: #selector(ContactsViewControler.StartChat(_:)), contact: contact)
        singleTap.numberOfTapsRequired = 1
        
        let contactImageView = UIImageView (image: UIImage (data: contact.image))
        contactImageView.contentMode = UIViewContentMode.ScaleAspectFit
        contactImageView.frame = CGRectMake(5, 0, 80, 80)
        contactImageView.addGestureRecognizer(singleTap)
        contactImageView.userInteractionEnabled = true
        
        let contactUsername = UILabel ()
        contactUsername.text = contact.username
        contactUsername.textColor = UIColor.whiteColor()
        contactUsername.frame = contactImageView.frame.offsetBy(dx: CGFloat (120), dy: CGFloat (-20))
        
        let contactChannelID = UILabel ()
        contactChannelID.text = contact.channelID
        contactChannelID.textColor = UIColor.whiteColor()
        contactChannelID.frame = CGRect (x: contactUsername.frame.minX, y: contactUsername.frame.minY + CGFloat (40), width: 200, height: contactUsername.frame.height)
        
        contactsScroll.addSubview (contactImageView)
        contactsScroll.addSubview (contactUsername)
        contactsScroll.addSubview (contactChannelID)
    }

    @objc func StartChat (singleTap : CustomTapRecognizer)
    {
        contactChatting = singleTap.contact
        performSegueWithIdentifier("ChatWithContact", sender: singleTap)
    }
    
    private func SendUserSync (urlFirebase : Firebase!)
    {
        let hmac = CustomCrypto.HMACTimed ()
        let encryptedUserData = CustomCrypto.EncryptUserData (UserData.ID, username: UserData.username, image: UserData.image!)
        let senderID = UserData.ID
        
        let newMessageReference = urlFirebase.childByAutoId()
        let newMessage = [
            "Sender ID": senderID,
            "HMAC" : hmac,
            "User Data" : encryptedUserData
        ]
        
        newMessageReference.setValue (newMessage)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        let navVc = segue.destinationViewController as! UINavigationController
        let chatVc = navVc.viewControllers.first as! ChatWithContactViewController
        chatVc.senderId = UserData.ID
        chatVc.senderDisplayName = ""
        chatVc.contact = contactChatting
    }
}