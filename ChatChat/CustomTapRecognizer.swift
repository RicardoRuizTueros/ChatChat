//
//  CustomTapRecognizer.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 16/6/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

class CustomTapRecognizer : UITapGestureRecognizer
{
    internal var contact : Contact = Contact (ID: "", username: "", image: NSData(), channelID: "", channelKey: "")
    
    init(target: AnyObject?, action: Selector, contact : Contact)
    {
        super.init(target: target, action: action)
        self.contact = contact
    }
}