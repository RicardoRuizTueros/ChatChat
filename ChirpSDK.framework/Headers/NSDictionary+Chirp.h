/*------------------------------------------------------------------------------
 *
 *  NSDictionary+Chirp.h
 *
 *  This file is part of the Chirp SDK for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#pragma once

#import <Foundation/Foundation.h>



@class Chirp;

@interface NSDictionary(Chirp)

/**
 *  Check to see whether your NSDictionary can be chirp.
 *
 *  Your dictionary should have values of type NSData, NSString, NSNumber, UIImage, NSDictionary, NSArray
 *  Your dictionary should have keys of type NSString
 *
 *  @return BOOL YES if your dictionary can be chirped successfully
 */
- (BOOL) isChirpable;

/**
 *  Convenience method to convert a complex dictionary into a NSJSONSerializable format
 *
 *  @param dictionary A dictionary conforming to NSJSONSerializable, but it can also include NSData and UIImage values.
 *
 *  @return NSDictionary A dictionary with data and image values converted to Base64.
 */
+ (NSDictionary *) makeChirpableDictionary:(NSDictionary *) dictionary;


- (void)chirpWithCompletion:(void (^)(Chirp *chirp, NSError *error))block;


@end
