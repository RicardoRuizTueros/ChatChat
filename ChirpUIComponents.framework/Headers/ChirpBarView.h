/*------------------------------------------------------------------------------
 *
 *  ChirpBarView.h
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

#import "ChesterView.h"
#import "ChirpWaveformView.h"

/**
 *  An instance of ChirpBarView class implements our brand audio/notification visualizer.
 *  It notifies you not only ensuring that a device picks incoming chirp sounds 
 *  but also informing when it has been changed states such as its volume changes, network connections
 *  and our API server states.
 *  It is a fixed design which is not allowed to modify.
 */
@interface ChirpBarView : UIView 

/**
 *  ChirpWaveformView is a smart audio visualizer which is a component of ChirpBarView.
 */
@property (nonatomic, strong) ChirpWaveformView *chirpWaveformView;

/**
 *  ChesterView is our log brand 'Chester' view which is a compoent of ChirpBarView.
 *  ChesterView also can be used as a button via ChirpBarViewDelegate to do something what you want.
 */
@property (nonatomic, strong) ChesterView *chester;

/**
 * ChirpBarView is tapped.
 *
 * @param block Block to execute when the ChirpBarView is tapped.
 */
- (void) setChirpBarTappedBlock:(void (^)())block;

/**
 * ChesterView is tapped.
 *
 * @param block Block to execute when the ChesterView is tapped.
 */
- (void) setChirpBarChesterTappedBlock:(void (^)())block;


/**
 * Audio buffer containing the most recent samples heard by the microphone
 * (typically 64 frames). Can be used to create ChirpWaveformView as a part of ChirpBarView.
 */
@property (nonatomic, assign) AudioBuffer *audioBuffer;


- (void)hideNetworkWarning;

@end
