//
//  AMPMessageHeader.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@class AMPMCOAddress;
@interface AMPMCOMessageHeader : AMPObject

@property BOOL generatedMessageID;

/** Message-ID field.*/
-(NSString*) messageID;

/** References field. It's an array of message-ids.*/
-(NSArray*) /* NSString */ references;

/** In-Reply-To field. It's an array of message-ids.*/
-(NSArray*) /* NSString */ inReplyTo;

/** Date field: sent date of the message.*/
-(NSDate*) date;

/** Received date: received date of the message.*/
-(NSDate*)  receivedDate;

/** Sender field.*/
-(AMPMCOAddress*) sender;

/** From field: address of the sender of the message.*/
-(AMPMCOAddress*) from;

/** To field: recipient of the message. It's an array of MCOAddress.*/
-(NSArray*) /* MCOAddress */ to;

/** Cc field: cc recipient of the message. It's an array of MCOAddress.*/
-(NSArray*) /* MCOAddress */ cc;

/** Bcc field: bcc recipient of the message. It's an array of MCOAddress.*/
-(NSArray*) /* MCOAddress */ bcc;

/** Reply-To field. It's an array of MCOAddress.*/
-(NSArray*) /* MCOAddress */ replyTo;

/** Subject of the message.*/
-(NSString*) subject;

/** User-Agent.*/
-(NSString*) userAgent;

/** Adds a custom header.*/
- (void)addHeaderValue:(NSString *)value forName:(NSString *)name;

/** Remove a given custom header.*/
- (void)removeHeaderForName:(NSString *)name;

/** Returns the value of a given custom header.*/
- (NSString *)headerValueForName:(NSString *)name;

/** Returns an array with the names of all custom headers.*/
- (NSArray * /* NSString */)allHeadersNames;

/** Extracted subject (also remove square brackets).*/
- (NSString *) extractedSubject;

/** Extracted subject (don't remove square brackets).*/
- (NSString *) partialExtractedSubject;

/** Fill the header using the given RFC 822 data.*/
- (void) importHeadersData:(NSData *)data;

/** Returns a header that can be used as a base for a reply message.*/
- (AMPMCOMessageHeader *) replyHeaderWithExcludedRecipients:(NSArray *)excludedRecipients;

/** Returns a header that can be used as a base for a reply all message.*/
- (AMPMCOMessageHeader *) replyAllHeaderWithExcludedRecipients:(NSArray *)excludedRecipients;

/** Returns a header that can be used as a base for a forward message.*/
- (AMPMCOMessageHeader *) forwardHeader;


@end
