//
//  AMPAbstractMessage.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@class AMPMCOMessageHeader;
@class AMPMCOAbstractPart;

@interface AMPMCOAbstractMessage : AMPObject

/** Header of the message. */
- (AMPMCOMessageHeader*) header;

/** Returns the part with the given Content-ID.*/
- (AMPMCOAbstractPart *) partForContentID:(NSString *)contentID;

/** Returns the part with the given unique identifier.*/
- (AMPMCOAbstractPart *) partForUniqueID:(NSString *)uniqueID;

/** All attachments in the message.
 It will return an array of MCOIMAPPart for MCOIMAPMessage.
 It will return an array of MCOAttachment for MCOMessageParser.
 It will return an array of MCOAttachment for MCOMessageBuilder. */
- (NSArray * /* MCOAbstractPart */) attachments;

/** All image attachments included inline in the message through cid: URLs.
 It will return an array of MCOIMAPPart for MCOIMAPMessage.
 It will return an array of MCOAttachment for MCOMessageParser.
 It will return an array of MCOAttachment for MCOMessageBuilder. */
- (NSArray * /* MCOAbstractPart */) htmlInlineAttachments;


@end
