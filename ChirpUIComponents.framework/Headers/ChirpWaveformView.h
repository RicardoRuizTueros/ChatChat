/*------------------------------------------------------------------------------
 *
 *  ChirpWaveformView.h
 *
 *  This file is part of the Chirp Components for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>

IB_DESIGNABLE

/**
 * ChirpWaveformView is a smart audio waveform visualizer which notifies you to ensure that it picks incoming chirp sounds.
 * It is a design free which is allowed to modify whatever you want.
 */
@interface ChirpWaveformView : UIView

/**
 * Audio buffer containing the most recent samples heard by the microphone
 * (typically 64 frames). Can be used to create ChirpWaveformView.
 */
@property (nonatomic, assign) AudioBuffer *audioBuffer;

/**
 * receivedFlashColor is a flash animation colour of the ChirpWaveform view when hearing a chirp.
 * It can be changed its value in Interdace Builder.
 */
@property (nonatomic, strong) IBInspectable UIColor *receivedFlashColor;

/**
 * sentFlashColor is a flash animation colour of the ChirpWaveform view when playing a chirp.
 * It can be changed its value in Interdace Builder. 
 */
@property (nonatomic, strong) IBInspectable UIColor *sentFlashColor;

@end
