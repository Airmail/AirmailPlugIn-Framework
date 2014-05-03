//
//  AMPMessage.h
//  AirMail
//
//  Created by Joe  on 11/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@class AMPAccount;
@class AMPAddress;
@class AMPComposerInfo;
@interface AMPMessage : AMPObject
{
    
}


/**
 *  The account name
 *
 *  @return The Account Name
 */
- (AMPAccount*) account;

/**
 *  The email address of the sender
 *
 *  @return The email address
 */
- (AMPAddress*) from;


/**
 *  Unique identifier of the message in Airmail
 *
 *  @return the Unique identifier
 */
- (NSNumber*) idx;

/**
 *  The local flags number
 *
 *  @return the number of the local flag
 */
- (NSNumber*) localflags;

/**
 *  The thread count number
 *
 *  @return the number of the thread count
 */
- (NSNumber*) threadCount;

/**
 *  The Xpriority value
 *
 *  @return the Xpriority value
 */
- (NSNumber*) xPriority;

/**
 *  The subject of the message
 *
 *  @return the messag subject vlue
 */
- (NSString*) subject;

/**
 *  the message ID of th RFC Message
 *
 *  @return the message ID
 */
- (NSString*) messageId;

/**
 *  The HMTL body of the message
 *
 *  @return The string with the HTML
 */
- (NSString*) htmlBody;

/**
 *  The Plain Text body of the message
 *
 *  @return The string with the Plain text
 */
- (NSString*) plainBody;

/**
 *  The message excerpt
 *
 *  @return the plain text excerpt
 */
- (NSString*) excerpt;

/**
 *  The message date
 *
 *  @return The message date
 */
- (NSDate*) date;


/**
 *  The attachments array of AMPAttachment model
 *
 *  @return The attachment array
 */
- (NSArray*) attachments;

/**
 *  The message references (message id) for a conversation
 *
 *  @return an array of strings
 */
- (NSArray*) references;

/**
 *  The message in reply to (message id) for a conversation
 *
 *  @return an array of strings
 */
- (NSArray*) inReplyTo;


/**
 *  The message TO field
 *
 *  @return an array of AMPAddress or AMPGroup
 */
- (NSArray*) to;

/**
 *  The message CC field
 *
 *  @return an array of AMPAddress or AMPGroup
 */
- (NSArray*) cc;

/**
 *  The message BCC field
 *
 *  @return an array of AMPAddress or AMPGroup
 */
- (NSArray*) bcc;

/**
 *  The message replyTO field
 *
 *  @return an array of AMPAddress or AMPGroup
 */
- (NSArray*) replyTo;

/**
 *  The message rfc
 *
 *  @return the full rfc of the message
 */
- (NSData*) rfcData;


/**
 *  A dictionary,the key is the folder idx, the objec is an AMPUidFlag (uid and flag) for the folder
 *  a message can belogn to multiple folders with different uids/flags
 *
 *  @return a dictionary
 */
- (NSDictionary*) folderUids;


/**
 *  The composer that has generated the message in the case of a send
 *
 *  @return a the composer info
 */
- (AMPComposerInfo*) composerInfo;


/**
 *  The encypted status fo the message
 *
 *  @return an encypted based on amp_encryption_type
 */
- (NSNumber*) encrypted;

/**
 *  Get the mails in the local message
 */
-(NSArray*) GetMails;

/**
 *  Get a dictionary with to,cc,bcc as keys and an array of mails for each entry
 */
-(NSDictionary*) GetMailsMaps;
@end
