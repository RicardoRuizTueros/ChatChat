/*------------------------------------------------------------------------------
 *
 *  ChirpButton.h
 *
 *  This file is part of the Chirp Components for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/**
 * An instance of the ChirpButton class implements our brand button 'ChirpButton' on the touch screen.
 * It has been already registed its pressed action by NSNotificationCenter which is nice usability.
 * The notification's key declared in ChirpUIComponentsConstants.h.
 */
@interface ChirpButton : UIButton

@end
