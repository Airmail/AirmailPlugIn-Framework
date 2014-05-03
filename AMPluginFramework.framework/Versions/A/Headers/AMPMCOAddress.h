//
//  AMPMCOAddress.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"

@interface AMPMCOAddress : AMPObject

/** Creates an address with a display name and a mailbox.
 
 Example: [MCOAddress addressWithDisplayName:@"DINH Viêt Hoà" mailbox:@"hoa@etpan.org"] */
+ (AMPMCOAddress *) addressWithDisplayName:(NSString *)displayName
                                mailbox:(NSString *)mailbox;

/** Creates an address with only a mailbox.
 
 Example: [MCOAddress addressWithMailbox:@"hoa@etpan.org"]*/
+ (AMPMCOAddress *) addressWithMailbox:(NSString *)mailbox;

/** Creates an address with a RFC822 string.
 
 Example: [MCOAddress addressWithRFC822String:@"DINH Vi=C3=AAt Ho=C3=A0 <hoa@etpan.org>"]*/
+ (AMPMCOAddress *) addressWithRFC822String:(NSString *)RFC822String;

/** Creates an address with a non-MIME-encoded RFC822 string.
 
 Example: [MCOAddress addressWithRFC822String:@"DINH Viêt Hoà <hoa@etpan.org>"]*/
+ (AMPMCOAddress *) addressWithNonEncodedRFC822String:(NSString *)nonEncodedRFC822String;

/**
 Returns an NSArray of MCOAddress objects that contain the parsed
 forms of the RFC822 encoded addresses.
 
 For example: @[ @"DINH Vi=C3=AAt Ho=C3=A0 <hoa@etpan.org>" ]*/
+ (NSArray *) addressesWithRFC822String:(NSString *)string;

/**
 Returns an NSArray of MCOAddress objects that contain the parsed
 forms of non-encoded RFC822 addresses.
 
 For example: @[ "DINH Viêt Hoà <hoa@etpan.org>" ]*/
+ (NSArray *) addressesWithNonEncodedRFC822String:(NSString *)string;


/** Returns the display name of the address.*/
-(NSString*) displayName;

/** Returns the mailbox of the address.*/
-(NSString*) mailbox;

/** Returns the RFC822 encoding of the address.
 
 For example: "DINH Vi=C3=AAt Ho=C3=A0 <hoa@etpan.org>"*/
- (NSString *) RFC822String;

/** Returns the non-MIME-encoded RFC822 encoding of the address.
 
 For example: "DINH Viêt Hoà <hoa@etpan.org>"*/
- (NSString *) nonEncodedRFC822String;


@end
