//
//  AMPMessageParser.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMPMCOAbstractMessage.h"
@class AMPMCOAbstractPart;
//@class AMPMCOAbstractMessage;
@interface AMPMCOMessageParser : AMPMCOAbstractMessage

/** returns a parsed message from the given RFC 822 data.*/
+ (AMPMCOMessageParser *) messageParserWithData:(NSData *)data;

/** It's the main part of the message. It can be MCOMessagePart, MCOMultipart or MCOAttachment.*/
- (AMPMCOAbstractPart *) mainPart;

/** data of the RFC 822 formatted message. It's the input of the parser.*/
- (NSData *) data;

/** HTML rendering of the body of the message to be displayed in a web view.*/
- (NSString *) htmlBodyRendering;

/** Text rendering of the message.*/
- (NSString *) plainTextRendering;

/** Text rendering of the body of the message. All end of line will be removed and white spaces cleaned up.
 This method can be used to generate the summary of the message.*/
- (NSString *) plainTextBodyRendering;

- (NSString *) plainBody;
@end
