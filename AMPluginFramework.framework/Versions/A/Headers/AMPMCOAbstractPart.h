//
//  AMPAbstractPart.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 12/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"

typedef enum {
    // Used for a single part.
    // The part will be a MCOAbstractPart.
    AMPMCOPartTypeSingle,
    
    // Used for a message part (MIME type: message/rfc822).
    // The part will be a MCOAbstractMessagePart.
    // It's when a message is sent as attachment of an other message.
    AMPMCOPartTypeMessage,
    
    // Used for a multipart, multipart/mixed.
    // The part will be a MCOAbstractMultipart.
    AMPMCOPartTypeMultipartMixed,
    
    // Used for a multipart, multipart/related.
    // The part will be a MCOAbstractMultipart.
    AMPMCOPartTypeMultipartRelated,
    
    // Used for a multipart, multipart/alternative.
    // The part will be a MCOAbstractMultipart.
    AMPMCOPartTypeMultipartAlternative,
    
    // Used for a multipart, multipart/signed.
    // The part will be a MCOAbstractMultipart.
    AMPMCOPartTypeMultipartSigned,
    
    // Used for a multipart, multipart/encrypted.
    // The part will be a MCOAbstractMultipart.
    AMPMCOPartTypeMultipartEncrypted,


} AMPMCOPartType;

@interface AMPMCOAbstractPart : AMPObject

/** Returns type of the part (single / message part / multipart/mixed,
 multipart/related, multipart/alternative). See MCOPartType.*/
-(AMPMCOPartType) partType;

/** Returns filename of the part.*/
-(NSString*) filename;

/** Returns MIME type of the part. For example application/data.*/
-(NSString*) mimeType;

/** Returns charset of the part in case it's a text single part.*/
-(NSString*) charset;

/** Returns the unique ID generated for this part.
 It's a unique identifier that's created when the object is created manually
 or created by the parser.*/
-(NSString*) uniqueID;

/** Returns the value of the Content-ID field of the part.*/
-(NSString*) contentID;

/** Returns the value of the Content-Location field of the part.*/
-(NSString*) contentLocation;

/** Returns the value of the Content-Description field of the part.*/
-(NSString*) contentDescription;

/** Returns whether the part is an explicit inline attachment.*/
-(BOOL) inlineAttachment;

/** Returns the part with the given Content-ID among this part and its subparts.*/
- (AMPMCOAbstractPart *) partForContentID:(NSString *)contentID;

/** Returns the part with the given unique identifier among this part and its subparts.*/
- (AMPMCOAbstractPart *) partForUniqueID:(NSString *)uniqueID;

/** Returns a string representation of the data according to charset.*/
- (NSString *) decodedStringForData:(NSData *)data;

/** Returns all parts for a mime type*/
- (NSArray*) PartsForMime:(NSString*)mimeIn;

/** Returns all parts.*/
- (NSArray*) AllParts;

//Added out of mailcore
+ (AMPMCOAbstractPart*) partForMailCorePart:(id)part;

@end
