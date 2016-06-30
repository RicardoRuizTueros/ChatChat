//
//  CustomChirpSDK.h
//  ChatChat
//
//  Created by Ricardo Ruiz on 20/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

#ifndef CustomChirpSDK_h
#define CustomChirpSDK_h

#endif /* CustomChirpSDK_h */

#import <Foundation/Foundation.h>
@import ChirpUIComponents;

@class ContactsViewControler;

@interface CustomChirpSDK : NSObject

+ (void) InitializeChirp;

+ (void) StartListeningShortKey : (ContactsViewControler*) contactsViewController;

+ (void) ChirpShortKey;

+ (void) GenerateShorKey;

+ (void) StopListening;

+ (NSString*) ShortKey;

+ (AudioBuffer*) AudioBuffer;

@end