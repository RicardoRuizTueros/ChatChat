/*------------------------------------------------------------------------------
 *
 *  Chirp.h
 *
 *  Represents a single Chirp entity, with attached identifier and data.
 *
 *  This file is part of the Chirp SDK for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

/**
 *  A single Chirp object
 */
@interface Chirp : NSObject

/**
 *  init with shortcode adds RS longcode and createdAt.
 *
 *  @param shortcode a valid shortcode
 *
 *  @return an instantiated Chirp object
 */
- (instancetype)initWithShortcode:(NSString *)shortcode;

/**
 *  The unique shortcode identifying this chirp
 */
@property (strong) NSString *shortcode;

/**
 *  The shortcode + error correction
 */
@property (strong) NSString *longcode;

/**
 *  The date this chirp was created
 */
@property (strong) NSDate *createdAt;

/**
 *  The NSDictionary data associated with this chirp
 */
@property (strong) NSDictionary *data;

/**
 *  Play this chirp to the current audio output
 *
 *  @return YES if the data was chirped successfully, NO otherwise
 */
- (BOOL)chirp;

@end
