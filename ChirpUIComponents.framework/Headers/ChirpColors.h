/*------------------------------------------------------------------------------
 *
 *  ChirpColors.h
 *
 *  This file is part of the Chirp Components for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface ChirpColors : UIColor

/**
 * Chirp Brand Colours
 *
 * @return return Chirp brand light yellow colour. It is normally used for a start color of the chirp's yellow gradient.
 */
+ (UIColor *)chirpBrandColorLightYellow;

/**
 * Chirp Brand Colours
 *
 * @return return Chirp brand dark yellow colour. It is normally used for an end color of the chirp's yellow gradient.
 */
+ (UIColor *)chirpBrandColorDarkYellow;

/**
 * ChirpBar Brand Colours
 *
 * @return return ChirpBar brand maroon colour. It is normally used for the ChirpBar background colour.
 */
+ (UIColor *)chirpBarBrandColorBackground;

/**
 * ChirpWaveform Brand Colours
 *
 * @return return ChirpWaveform brand light maroon colour. It is normally used for the ChirpBar layer background colour.
 */
+ (UIColor *)chirpWaveformBrandColorBackground;

/**
 * ChirpWaveform Brand Colours
 *
 * @return return ChirpWaveform brand light red colour. It is normally used for the ChirpBar layer background colour.
 */
+ (UIColor *)chirpBrandColorLightRed;

/**
 * ChirpWaveform Brand Colours
 *
 * @return return ChirpWaveform brand dark red colour. It is normally used for the ChirpBar layer background colour.
 */
+ (UIColor *)chirpBrandColorDarkRed;

/**
 * ChirpBar Brand Colours
 *
 * @return return ChirpBar brand ligh black colour. It is normally used for a start color of the ChirpBar black gradient.
 */
+ (UIColor *)chirpBarBrandColorLightBackground;

/**
 * ChirpBar Brand Colours
 *
 * @return return ChirpBar brand ligh black colour. It is normally used for an end color of the ChirpBar black gradient.
 */
+ (UIColor *)chirpBarBrandColorDarkBackground;


@end
