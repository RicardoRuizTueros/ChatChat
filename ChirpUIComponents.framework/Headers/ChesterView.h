/*------------------------------------------------------------------------------
 *
 *  ChesterView.h
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
 * An instance of ChesterView class implements our logo character 'Chester' view on the screen.
 * It is highly recommended the view is drawn square that should represent
 * an original shape as he is.
 */
@interface ChesterView : UIView


/**
 * ChesterView is tapped.
 *
 * @param block Block to execute when the ChesterView is tapped.
 */
- (void) setChesterTappedBlock:(void (^)())block;


/**
 * This method is a simple animation that Chester View is winking.
 * He is winking his right eye like a cute child.
 */
- (void)wink;

/**
 * This method is a simple animation that Chester View is blinking.
 * He is blinking his both eyes with surprise.
 */
- (void)blink;

/**
 * This method is a simple animation that Chester View is blushing.
 * He is itching his nose horizontally with shy.
 */
- (void)blush;

/**
 * This method is a simple animation that Chester View is smiling you.
 * He is smiling sweetly in his both eyes and nose his nose. 
 */
- (void)smile;

/**
 *  This method is to set a start-color for gradient of Chester's colors.
 *
 *  @param startColor Specifies the color at the start point of the gradient.
 */
- (void)setStartColor:(UIColor *)startColor;

/**
 *  This method is to set a end-color for gradient of Chester's colors.
 *
 *  @param endColor Specifies the color at the end point of the gradient.
 */
- (void)setEndColor:(UIColor *)endColor;

@end
