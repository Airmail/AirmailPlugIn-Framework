//
//  AMPMCOAttachment.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import "AMPMCOAbstractPart.h"

@interface AMPMCOAttachment : AMPMCOAbstractPart

/** Returns a MIME type for a filename.*/
+ (NSString *) mimeTypeForFilename:(NSString *)filename;

/** Returns a file attachment with the content of the given file.*/
+ (AMPMCOAttachment *) attachmentWithContentsOfFile:(NSString *)filename;

/** Returns a file attachment with the given data and filename.*/
+ (AMPMCOAttachment *) attachmentWithData:(NSData *)data filename:(NSString *)filename;

/** Returns a part with an HTML content.*/
+ (AMPMCOAttachment *) attachmentWithHTMLString:(NSString *)htmlString;

/** Returns a part with a RFC 822 messsage attachment.*/
+ (AMPMCOAttachment *) attachmentWithRFC822Message:(NSData *)messageData;

/** Returns a part with an plain text content.*/
+ (AMPMCOAttachment *) attachmentWithText:(NSString *)text;

/** Returns a part with an plain text content with mime type*/
+ (AMPMCOAttachment *) attachmentWithText:(NSString *)text mimeType:(NSString*)contentType;

/** Decoded data of the part.*/
- (NSData*) data;

/** Returns string representation according to charset*/
- (NSString *) decodedString;


@end
