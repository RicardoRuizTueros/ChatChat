/*------------------------------------------------------------------------------
 *
 *  NSString+Chirp.h
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

@interface NSString(Chirp)

- (BOOL) chirp;
- (BOOL) isValidChirpShortcode;

@end
