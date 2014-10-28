//
//  AMPCallBack.h
//  AMPluginFramework
//
//  Created by Joe  on 18/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMPAccount;
@class AMPMessage;
@class AMPComposerInfo;
@interface AMPCallBack : NSObject
{
    id callback;
}
+(AMPCallBack*)shared;

/**
 *  Open a window to read the message
 *
 *  @param messages the message to read
 */
- (void) OpenReaderMessages:(NSArray*)messages;

/**
 *  Reply message action, it will open a composer for each message passed
 *
 *  @param messages the message to reply
 */
- (void) ReplyMessages:(NSArray*)messages;

/**
 *  Mark as read action, it will mark as read the messages passed
 *
 *  @param messages the message to mark
 */
- (void) MarkAsReadMessages:(NSArray*)messages;


/**
 *  Forward message action, it will open a composer for each message passed
 *
 *  @param messages the message to forward
 */
- (void) ForwardMessages:(NSArray*)messages;

/**
 *  Trash message action, it will move to trash all the messages passed
 *
 *  @param messages the message to trash
 */
- (void) TrashMessages:(NSArray*)messages;

/**
 *  Archive message action, it will archive all the messages passed
 *
 *  @param messages the message to reply
 */
- (void) ArchiveMessages:(NSArray*)messages;

/**
 *  Return the current selected messages in the message list
 */
- (NSArray*) SelectedMessages;

/**
 *  The accounts list of Airmail
 */
- (NSArray*) Accounts;

/**
 *  Folders of an account
 *
 *  @param account the account owner of the folders
 *
 *  @return the folders
 */
- (NSArray*) Folders:(AMPAccount*)account;

/**
 *  the ordered folders (hierarchy) for an account. the standard folders are
 *  all grouoed in the first positions of the array
 *
 *  @param account the account owner of the folders
 *
 *  @return the ordered folders
 */
- (NSArray*) OrderedFoldersWithStandardFirst:(AMPAccount*)account;

/**
 *  The image for a message
 *
 *  @param message the message owner of the image
 *
 *  @return the image
 */
- (NSImage*) MessageImage:(AMPMessage*)message;

@end
