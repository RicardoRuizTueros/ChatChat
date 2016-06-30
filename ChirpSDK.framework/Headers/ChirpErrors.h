/*------------------------------------------------------------------------------
 *
 *  ChirpErrors.h
 *
 *  Errors and exceptions associated with the Chirp SDK.
 *
 *  This file is part of the Chirp SDK for iOS.
 *  For full information on usage and licensing, see http://chirp.io/
 *
 *  Copyright © 2011-2016, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

#ifndef ChirpErrors_h
#define ChirpErrors_h

/**
 *  Chirp error states
 */
typedef NS_ENUM(NSInteger, ChirpError)
{
    /**
     *  The specified data could not be serialised as a chirp.
     *  The following classes can be chirped:
     *    NSString, NSNumber, NSDictionary, NSArray
     */
    ChirpErrorInvalidData,
    /**
     *  Invalid app key or secret.
     */
    ChirpErrorInvalidAppKey,
    /**
     *  Error connecting to the Chirp API server.
     */
    ChirpErrorNetworkError,
    /**
     *  Insufficient permissions to carry out the requested operation.
     *  Please contact Chirp technical support for
     */
    ChirpErrorInsufficientPermissions,
    /**
     *  A problem occurred during audio decoding.
     */
    ChirpErrorReceiveFailed,
    /**
     *  The device is muted and cannot generate chirp audio.
     */
    ChirpErrorDeviceMuted,
    /**
     *  The shortcode specified was badly formed.
     *  It should be 10 characters drawn from the Chirp alphabet, [0-9a-v].
     */
    ChirpErrorInvalidShortcode
};

#define ChirpErrorDomain @"io.chirp.error"

#define ChirpErrorMake(_code, _userInfo) [NSError errorWithDomain:ChirpErrorDomain code:(int)_code userInfo:_userInfo]

#define ChirpUserInfoMake(description, failure_reason, recovery_suggestion) @{ NSLocalizedDescriptionKey : description, NSLocalizedFailureReasonErrorKey : failure_reason, NSLocalizedRecoverySuggestionErrorKey : recovery_suggestion }

#define ChirpErrorUserInfoInvalidShortcode ChirpUserInfoMake(@"Invalid shortcode", @"Invalid shortcode", @"Chirp shortcodes must be 10 characters drawn in 0..9 or a..v.")

#define ChirpErrorUserInfoDeviceMuted ChirpUserInfoMake(@"The device is muted", @"The device is muted", @"Please turn up the volume to be able to send chirps.")

#define ChirpErrorUserInfoCannotConvertDataToJSON @{NSLocalizedDescriptionKey:NSLocalizedString(@"Cannot get JSON from NSDictionary", nil),NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"could not convert data to JSON", nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Make sure your data (NSDictionary) is convertable to JSON (NSJSONSerialization)", nil)}

#define ChirpErrorUserInfoDataPayloadTooBig @{NSLocalizedDescriptionKey:NSLocalizedString(@"Data body is too big", nil),NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Data could not be added to request", nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Reduce the size of your data payload", nil)}

#define ChirpErrorUserInfoNoAppKeyOrSecret @{NSLocalizedDescriptionKey:NSLocalizedString(@"Cannot get access token", nil),NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"App Key and app Secret not set", nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Set app key and secret before requesting token", nil)}

#define ChirpErrorUserInfoCouldNotMakeChirpableDictionary @{NSLocalizedDescriptionKey:NSLocalizedString(@"Cannot make dictionary chirpable", nil),NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"dictionary contains non serialisable objects", nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Make sure the dictionary conforms to NSJSONSerialisable + UIImage + NSData", nil)}

#define ChirpErrorUserInfoFailedRequest(_string) @{NSLocalizedDescriptionKey:_string, NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Request failed", nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Request failed", nil)}

#endif /* ChirpErrors_h */
