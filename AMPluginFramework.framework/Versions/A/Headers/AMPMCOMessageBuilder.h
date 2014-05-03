//
//  AMPMCOMessageBuilder.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import "AMPMCOAbstractMessage.h"
@class AMPMCOAttachment;
@interface AMPMCOMessageBuilder : AMPMCOAbstractMessage

/** Main HTML content of the message.*/
-(NSString*) htmlBody;

/** Plain text content of the message.*/
-(NSString*) textBody;

/** List of file attachments.*/
-(NSArray*) /* MCOAttachment */ attachments;

/** List of related file attachments (included as cid: link in the HTML part).*/
-(NSArray*) /* MCOAttachment */ relatedAttachments;

/** Prefix for the boundary identifier. Default value is nil.*/
-(NSString*) boundaryPrefix;

/** Add an attachment.*/
- (void) addAttachment:(AMPMCOAttachment *)attachment;

/** Add a related attachment.*/
- (void) addRelatedAttachment:(AMPMCOAttachment *)attachment;

/** RFC 822 formatted message.*/
- (NSData *) data;

/** HTML rendering of the body of the message to be displayed in a web view.*/
- (NSString *) htmlBodyRendering;

/** Text rendering of the message.*/
- (NSString *) plainTextRendering;

/** Text rendering of the body of the message. All end of line will be removed and white spaces cleaned up.
 This method can be used to generate the summary of the message.*/
- (NSString *) plainTextBodyRendering;


@end
