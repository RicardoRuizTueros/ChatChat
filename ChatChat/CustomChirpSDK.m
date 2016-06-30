//
//  CustomSDKChirp.m
//  ChatChat
//
//  Created by Ricardo Ruiz on 20/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChirpSDK/ChirpSDK.h"
#import "CustomChirpSDK.h"
#import "ChatChat-Swift.h"

@implementation CustomChirpSDK

static NSString* SDK_Key = @"e5VxXdRI31xxHByVxeivsp8IK";
static NSString* SDK_Secret = @"B3XpkWCaxCSdP4sBepvhyD48ybiALQDz7UaEqM9L32NwXYOltc";

NSString* shortKey;

+ (void) InitializeChirp
{
    [[ChirpSDK sdk] setAppKey: SDK_Key
                    andSecret: SDK_Secret
                    withCompletion: ^(BOOL authenticated, NSError* error)
                    {
                        if (authenticated)
                            NSLog(@"Authenticated OK.");
                    }
    ];
}

+ (void) StartListeningShortKey : (ContactsViewControler*) contactsViewController
{
    [[ChirpSDK sdk] setOfflineOnly:YES];
    [[ChirpSDK sdk] startListening:^(Chirp *chirp, NSError *error)
     {
         if (!error)
         {
             shortKey = chirp.shortcode;
             NSLog(@"Received Short Key: %@", shortKey);
             [contactsViewController ReceiveUserSync];
         }
         else
         {
             NSLog(@"Error: %@", error);
         }
     }];
}

+ (void) StopListening
{
    [[ChirpSDK sdk] stopListening];
}

+ (void) ChirpShortKey
{
    [[ChirpSDK sdk] chirpShortcode: shortKey withCompletion:^(Chirp *chirp, NSError *error)
    {
        NSLog (@"Chirped shortkey: %@", shortKey);
    }];
}

+ (void) GenerateShorKey
{
    NSString* letters = @"abcdefghijklmnopqrstuv0123456789";
        
    NSMutableString* randomString = [NSMutableString stringWithCapacity: 10];
        
        for (int iterations = 0; iterations < 10; iterations++) {
            [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
        }
        
    shortKey = randomString;
}

+ (AudioBuffer*) AudioBuffer
{
    return [[ChirpSDK sdk] audioBuffer];
}

+ (NSString*) ShortKey
{
    return shortKey;
}

@end