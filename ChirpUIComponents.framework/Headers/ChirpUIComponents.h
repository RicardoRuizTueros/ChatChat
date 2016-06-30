/*------------------------------------------------------------------------------
 *
 *  ChirpUIComponents.h
 *
 *  This file is part of the Chirp Components for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

#import <ChirpUIComponents/ChesterView.h>
#import <ChirpUIComponents/ChirpButton.h>
#import <ChirpUIComponents/ChirpBarView.h>
#import <ChirpUIComponents/ChirpWaveformView.h>
#import <ChirpUIComponents/ChirpColors.h>

/**----------------------------------------------------------------------------*
 * Chirp Button Notification.
 *----------------------------------------------------------------------------*/
static NSString *const ChirpNotificationButtonPressed = @"io.chirp.notification.chirp-button-pressed";

@interface ChirpUIComponents : NSObject

/**
*  The current version of the ChirpUIComponents framework
*
*  @return Returns a semantic version string.
*/
+ (NSString *)version;

@end
