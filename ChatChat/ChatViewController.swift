/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Firebase
import JSQMessagesViewController


class ChatViewController: JSQMessagesViewController {
  
  // MARK: Properties
  let rootRef = Firebase(url: "https://resplendent-fire-2168.firebaseio.com/")
  var messageRef: Firebase!
  var messages = [JSQMessage]()
  
  var userIsTypingRef: Firebase!
  var usersTypingQuery: FQuery!
  private var localTyping = false
  var isTyping: Bool {
    get {
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  var outgoingBubbleImageView: JSQMessagesBubbleImage!
  var incomingBubbleImageView: JSQMessagesBubbleImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBubbles()
    messageRef = rootRef.childByAppendingPath("Messages").childByAppendingPath("General")
    
    // No avatars
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
  }
    
    @IBAction
    func BackToLogin ()
    {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier ("Main")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    observeMessages()
    observeTyping()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item] // 1
    if message.senderId == UserData.ID { // 2
      return outgoingBubbleImageView
    } else { // 3
      return incomingBubbleImageView
    }
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    
    if message.senderId == UserData.ID { // 1
      cell.textView!.textColor = UIColor.whiteColor() // 2
    } else {
      cell.textView!.textColor = UIColor.blackColor() // 3
    }
    
    return cell
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  internal func observeMessages() {
    let messagesQuery = messageRef.queryLimitedToLast(25)
    
    messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
        
      let id = snapshot.value["Sender ID"] as! String
      let text = snapshot.value["Message"] as! String
      
      self.addMessage(id, text: text)
      
      self.finishReceivingMessage()
    }
  }
  
  private func observeTyping() {
    let typingIndicatorRef = rootRef.childByAppendingPath("Typing")
    userIsTypingRef = typingIndicatorRef.childByAppendingPath(UserData.ID)
    userIsTypingRef.onDisconnectRemoveValue()
    usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
    
    usersTypingQuery.observeEventType(.Value) { (data: FDataSnapshot!) in
      
      // You're the only typing, don't show the indicator
      if data.childrenCount == 1 && self.isTyping {
        return
      }
      
      // Are there others typing?
      self.showTypingIndicator = data.childrenCount > 0
      self.scrollToBottomAnimated(true)
    }

  }
  
  func addMessage(id: String, text: String) {
    let message = JSQMessage(senderId: UserData.ID, displayName: "", text: text)
    messages.append(message)
  }
  
  override func textViewDidChange(textView: UITextView) {
    super.textViewDidChange(textView)
    // If the text is not empty, the user is typing
    isTyping = textView.text != ""
  }
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
    let itemRef = messageRef.childByAutoId() // 1
    
    let messageItem = [
        "Sender ID": UserData.ID,
        "Message": text
    ]
    
    itemRef.setValue(messageItem) // 3
    
    // 4
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    // 5
    finishSendingMessage()
    isTyping = false
  }
  
  private func setupBubbles() {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
  }
  
}