//
//  AMPAccount.h
//  AirMail
//
//  Created by Joe  on 11/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@class AMPProvider;
@class AMPSignature;
@interface AMPAccount : AMPObject
{
    
}
/**
 *  The account provider model
 *
 *  @return The account provider
 */
- (AMPProvider*) provider;

/**
 *  the unique identifier of the account
 *
 *  @return The ID
 */
- (NSNumber*) idx;

/**
 *  The account order position
 *
 *  @return The account order
 */
- (NSNumber*) order;

/**
 *  The preference of the composer amp_composertype
 *
 *  @return An integer of the amp_composertype
 */
- (NSNumber*) composerType;

/**
 *  A bool value if is unified inbox
 *
 *  @return if is unified inbox
 */
- (NSNumber*) isAll;

/**
 *  If the account is enabled
 *
 *  @return A bool value
 */
- (NSNumber*) enabled;

/**
 *  A bool value preference to use signature for the account
 *
 *  @return A bool value
 */
- (NSNumber*) useSignature;

/**
 *  A bool value preference to use signature in Quick Reply for the account
 *
 *  @return A bool value
 */
- (NSNumber*) useSignatureQuickReply;

/**
 *  A bool value preference to use signature in Reply for the account
 *
 *  @return A bool value
 */
- (NSNumber*) useSignatureReply;

/**
 *  A bool value preference to use copy sent messages in the sent folder
 *
 *  @return A bool value
 */
- (NSNumber*) copySent;

/**
 *  A bool value preference if the account have the notification enabled.
 *
 *  @return A bool value
 */
- (NSNumber*) notify;

/**
 *  A bool value preference if the account have the automapped of folders enabled
 *
 *  @return A bool value
 */
- (NSNumber*) autoMapping;

/**
 *  A bool value preference if the account have the automatic download of the message body
 *
 *  @return A bool value
 */
- (NSNumber*) downloadBody;

/**
 *  A bool value preference if the account have the automatic download of the message Attachments
 *
 *  @return A bool value
 */
- (NSNumber*) downloadAttachments;

/**
 *  A bool value preference if the account have the import contacts at start
 *
 *  @return A bool value
 */
- (NSNumber*) importContacts;

/**
 *  A bool value preference if the account is the default replier
 *
 *  @return A bool value
 */
- (NSNumber*) defaultReplier;

/**
 *  A bool value preference if the account is Right Text Lanaguage
 *
 *  @return A bool value
 */
- (NSNumber*) rtl;

/**
 *  The account mail
 *
 *  @return the mail account
 */
- (NSString*) mail;

/**
 *  The account name
 *
 *  @return the name of the account
 */
- (NSString*) name;

/**
 *  Is tha path where the account files are stored
 *
 *  @return the account path
 */
- (NSString*) path;

/**
 *  Is string of the file name
 *
 *  @return the file name
 */
- (NSString*) notifySound;

/**
 *  the profile icon image
 *
 *  @return The icon image
 */
- (NSImage*)  profileIcon;

/**
 *  The aliases array
 *
 *  @return the aliases array of AMPAlias
 */
- (NSMutableArray*) aliases;

/**
 *  The signatures name array
 *
 *  @return the signatures array of AMPSignature
 */
- (NSMutableArray*) signatures;
@end
