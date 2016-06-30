/*------------------------------------------------------------------------------
 *
 *  ChirpSDK.h
 *
 *  Core SDK functionality.
 *
 *  Basic usage:
 *
 *    [[ChirpSDK sdk] setAppKey:YOUR_APP_KEY andSecret:YOUR_APP_SECRET];
 *    [[ChirpSDK sdk] chirpDictionary:@{ @"key" : @"value" }];
 *
 *  Full documentation can be found in the `docs` folder of this SDK.
 *
 *  This file is part of the Chirp SDK for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#pragma once

@import Accelerate;
@import AudioToolbox;
@import AVFoundation;
@import SystemConfiguration;

#import <ChirpSDK/Chirp.h>
#import <ChirpSDK/ChirpErrors.h>
#import <ChirpSDK/ChirpNotifications.h>

#import <ChirpSDK/NSDictionary+Chirp.h>
#import <ChirpSDK/NSString+Chirp.h>

////////////////////////////////////////////////////////////////////////////////
/// @name Constants
////////////////////////////////////////////////////////////////////////////////


#define CHIRP_SDK_VERSION @"1.1.0"

/**----------------------------------------------------------------------------*
 *  Chirp audio engine states.
 *----------------------------------------------------------------------------*/
typedef NS_ENUM(NSInteger, ChirpAudioState)
{
    /**
     *  The audio engine is currently stopped
     */
    ChirpAudioStateStopped,
    /**
     *  The audio engine is neither playing nor receiving a chirp
     */
    ChirpAudioStateReady,
    /**
     *  The audio engine is currently playing a chirp
     */
    ChirpAudioStateChirping,
    /**
     *  The audio engine is currently receiving a chirp
     */
    ChirpAudioStateReceiving
};





/**
 *  The ChirpSDK class encapsulates all of the SDK's major functionality.
 */
@interface ChirpSDK : NSObject

////////////////////////////////////////////////////////////////////////////////
/// @name Creating and configuring an SDK object
////////////////////////////////////////////////////////////////////////////////

/**-----------------------------------------------------------------------------
 *  The shared Chirp SDK instance.
 *
 *  @return Returns a singleton instance of the Chirp SDK.
 *----------------------------------------------------------------------------*/
+ (ChirpSDK *) sdk;

/**-----------------------------------------------------------------------------
 *  Set the Chirp SDK key and secret
 *
 *  @warning *Warning:* This must be set before initialising the ChirpSDK
 *  shared instance.
 *
 *  @param key        Your application key from http://developers.chirp.io
 *  @param secret     Your secret from http://developers.chirp.io
 *-----------------------------------------------------------------------------*/
- (void) setAppKey:(NSString *)key andSecret:(NSString *)secret;

/**-----------------------------------------------------------------------------
 *  Authenticate with Chirp and receive a callback after authentication has completed
 *
 *  @param key         Your application key from http://developers.chirp.io
 *  @param secret      Your secret from http://developers.chirp.io
 *  @param completion  A completion handler, called upon successful authentication
 *                     with the Chirp API server. Note that this will not 
 *                     be triggered when the SDK is used offline (or if the
 *                     app is offline when it starts), so should not be used
 *                     to `startListening` or other mission-critical activities.
 *
 *----------------------------------------------------------------------------*/
- (void) setAppKey:(NSString *)key
         andSecret:(NSString *)secret
    withCompletion:(void (^)(BOOL authenticated, NSError *error))completion;

/**-----------------------------------------------------------------------------
 *  The current version of the SDK.
 *
 *  @return Returns a semantic version string.
 *----------------------------------------------------------------------------*/
- (NSString *) version;



////////////////////////////////////////////////////////////////////////////////
/// @name Sending data
////////////////////////////////////////////////////////////////////////////////


/**-----------------------------------------------------------------------------
 * Encode a dictionary of data as a Chirp shortcode.
 *
 * This merely creates the identifier that can be used to chirp the data.
 * To immediately chirp the data via the speaker, use `chirpDictionary:`
 * or add a [chirp chirp] call in your completion handler.
 *
 * Keys must be instances of NSString.
 * Values can be instances of NSString, NSNumber, NSArray, NSDictionary.
 *
 * @param data Dictionary of content to be chirped.
 * @param completion Completion block, called when the chirp has been created.
 *                   Can be null.
 *
 *                   If successful, `chirp` contains the completed chirp object.
 *
 *                   If an error occurs, `error` is non-null.
 *----------------------------------------------------------------------------*/
- (void) createChirpWithDictionary:(NSDictionary *)data
                     andCompletion:(void (^)(Chirp *chirp, NSError *error))completion;


/**-----------------------------------------------------------------------------
 * Encode and chirp a dictionary of data.
 *
 * This encapsulates the specified NSDictionary as a chirp code, and plays
 * it from the device's speaker.
 *
 * Keys must be instances of NSString.
 * Values can be instances of NSString, NSNumber, NSArray, NSDictionary.
 *
 * @param dictionary Dictionary of content to be chirped.
 * @param completion Completion block, called when the chirp has been played.
 *                   Can be null.
 *
 *                   If successful, `chirp` contains the completed chirp object.
 *
 *                   If an error occurs, `error` is non-null.
 *----------------------------------------------------------------------------*/

- (void) chirpDictionary:(NSDictionary *)dictionary
          withCompletion:(void (^)(Chirp *chirp, NSError *error))completion;


/**-----------------------------------------------------------------------------
 * Create a Chirp object from a 10-character string.
 * To be valid, this string must be 10 characters long, and drawn from
 * the Chirp alphabet: [0-9a-v].
 *
 * To immediately chirp the data via the speaker, use `chirpShortcode:`
 * or add a [chirp chirp] call in your completion handler.
 *
 * @param shortcode A 10-character string, from the Chirp alphabet [0-9a-v]
 * @param completion Completion block, called when the chirp has been created.
 *                   Can be null.
 *
 *                   If successful, `chirp` contains the completed chirp object.
 *
 *                   If an error occurs, `error` is non-null.
 *----------------------------------------------------------------------------*/

- (void) createChirpWithShortcode:(NSString *)shortcode
                    andCompletion:(void (^)(Chirp *chirp, NSError *error))completion;


/**-----------------------------------------------------------------------------
 * Chirp a 10-character string over the device's speaker.
 *
 * To be valid, this string must be 10 characters long, and drawn from
 * the Chirp alphabet: [0-9a-v].
 *
 * @param shortcode A 10-character string, from the Chirp alphabet [0-9a-v]
 * @param completion Completion block, called when the chirp has been played.
 *                   Can be null.
 *
 *                   If successful, `chirp` contains the completed chirp object.
 *
 *                   If an error occurs, `error` is non-null.
 *----------------------------------------------------------------------------*/

- (void) chirpShortcode:(NSString *)shortcode
         withCompletion:(void (^)(Chirp *chirp, NSError *error))completion;



////////////////////////////////////////////////////////////////////////////////
/// @name Receiving and retrieving data
////////////////////////////////////////////////////////////////////////////////

/**-----------------------------------------------------------------------------
 * Listen for chirps received via sound.
 *
 * @param block Block to execute when a chirp is received.
 *
 *              If successful, `chirp` contains the full chirp body.
 *
 *              If an error occurs, `error` is non-null.
 *----------------------------------------------------------------------------*/
- (void) startListening:(void (^)(Chirp *chirp, NSError *error))block;


/**-----------------------------------------------------------------------------
 * Stop listening for chirps.
 *----------------------------------------------------------------------------*/
- (void) stopListening;


/**-----------------------------------------------------------------------------
 * Expand a Chirp shortcode to a dictionary of JSON data.
 *
 * @param shortcode shortcode to get dictionary payload for
 * @param completion Block to execute when data has been decoded successfully.
 *----------------------------------------------------------------------------*/
- (void) getChirpWithShortcode:(NSString *)shortcode
                 andCompletion:(void (^)(Chirp *chirp, NSError *error))completion;



////////////////////////////////////////////////////////////////////////////////
/// @name Optional engine modes
////////////////////////////////////////////////////////////////////////////////

/**-----------------------------------------------------------------------------
 *  Configure whether the SDK should attempt to retrieve expanded data when a
 *  chirp tone is heard. This should be set to YES if your application sends
 *  and receives data purely within the 10-character chirp audio shortcode.
 *----------------------------------------------------------------------------*/
@property (nonatomic, assign) BOOL offlineOnly;


////////////////////////////////////////////////////////////////////////////////
/// @name Audio properties
////////////////////////////////////////////////////////////////////////////////

/**-----------------------------------------------------------------------------
 * Audio buffer containing the most recent samples heard by the microphone
 * (typically 64 frames). Can be used to visualise current audio input.
 *----------------------------------------------------------------------------*/
@property (nonatomic, readonly) AudioBuffer *audioBuffer;

/**----------------------------------------------------------------------------*
 * I/O block that is triggered when a new buffer of audio is read
 * (typically 256 frames of stereo audio).
 *
 *  @param block Callback, passed a mono AudioBuffer containing the new audio.
 *----------------------------------------------------------------------------*/
- (void)setAudioBufferUpdatedBlock:(void (^)(AudioBuffer *buffer, UInt32 numFrames))block;

/**-----------------------------------------------------------------------------*
 * ChirpAudioState indicates the current activity mode of the audio engine:
 *
 *    ChirpAudioStateStopped: Not running
 *    ChirpAudioStateReady: Inactive, awaiting new chirps
 *    ChirpAudioStateChirping: Active, outputting chirp audio
 *    ChirpAudioStateReceiving: Active, receiving chirp audio
 *
 * @return The current mode of the audio engine
 *----------------------------------------------------------------------------*/
@property (nonatomic, readonly) ChirpAudioState audioEngineState;

/**-----------------------------------------------------------------------------
 * Set and get Chirp's output volume, independent from the device hardware
 * volume (see below). Defaults to 1.0f.
 *----------------------------------------------------------------------------*/
@property (nonatomic, assign) float volume;

/**-----------------------------------------------------------------------------
 * Returns the hardware audio volume, between 0.0f and 1.0f.
 * This is set by the user using device controls and cannot be modified.
 *
 * This can be checked to generate a warning if the volume is too low.
 *
 * Changes in volume trigger a ChirpNotificationSystemAudioVolumeChanged
 * notification.
 *
 * @return The current system audio setting.
 *----------------------------------------------------------------------------*/
@property (nonatomic, readonly) float systemAudioVolume;



////////////////////////////////////////////////////////////////////////////////
/// @name Helper utilities
////////////////////////////////////////////////////////////////////////////////

/**-----------------------------------------------------------------------------
 * Generate a random valid shortcode.
 *
 * e.g. 8nk34aa0e0
 *----------------------------------------------------------------------------*/
+ (NSString *) randomShortcode;

/**----------------------------------------------------------------------------*
 *  Returns YES the given string is able to be chirped directly.
 *
 *  if ([ChirpSDK isValidShortcode:myString])
 *  {
 *     [myString chirp];
 *  }
 *
 *  @param shortcode An NSString instance.
 *
 *  @return YES if the shortcode can be chirped as-is.
 *
 *----------------------------------------------------------------------------*/
+ (BOOL) isValidShortcode:(NSString *)shortcode;

@end
