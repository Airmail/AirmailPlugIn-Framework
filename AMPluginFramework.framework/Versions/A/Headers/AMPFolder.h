//
//  AMPFolder.h
//  AMPluginFramework
//
//  Created by Joe  on 18/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMPAccount;
#import "AMPObject.h"
@interface AMPFolder : AMPObject
{
}

/**
 *  The account of the folder
 *
 *  @return The account of the folder
 */
- (AMPAccount*) account;

/**
 *  The parent folder of the current folder
 *
 *  @return The parent folder of the current folder
 */
- (AMPFolder*)  parentFolder;

/**
 *  The subfolder folder of the current folder
 *
 *  @return an array of the subfolder
 */
- (NSArray*)    subFolders;

/**
 *  Unique identifier of the object
 *
 *  @return Unique identifier of the object
 */
- (NSNumber*) idx;

/**
 *  An integer for the folder type amp_foldertype
 *
 *  @return An integer for the folder type amp_foldertype
 */
- (NSNumber*) standardFolderid;

/**
 *  A bool value if the folder is completly fetched
 *
 *  @return A bool value if the folder is completly fetched
 */
- (NSNumber*) fetched;

/**
 *  The indentation level of the folder
 *
 *  @return The indentation level of the folder
 */
- (NSNumber*) indent;

/**
 *  The order position of the folder
 *
 *  @return The order position of the folder
 */
- (NSNumber*) position;

/**
 *  The message Count
 *
 *  @return The message Count
 */
- (NSNumber*) count;

/**
 *  The messages Unread Count for that folder
 *
 *  @return The messages Unread Count for that folder
 */
- (NSNumber*) unreadCount;

/**
 *  A bool value if the folder is enabled or not (not used)
 *
 *  @return A bool value if the folder is enabled or not (not used)
 */
- (NSNumber*) disabled;

/**
 *  A bool value if the folder is hided
 *
 *  @return A bool value if the folder is hided
 */
- (NSNumber*) hided;

/**
 *  A bool value if the folder is selectable, IMAP only
 *
 *  @return A bool value if the folder is selectable
 */
- (NSNumber*) selectable;

/**
 *  A bool value if the folder is a local Folder, like MUTE
 *
 *  @return A bool value if the folder is a local Folder
 */
- (NSNumber*) localTag;

/**
 *  The path name of the folder /folder/folder or .folder.folder
 *
 *  @return The path name of the folder
 */
- (NSString*) name;

/**
 *  The name of the folder EXCHANGE Only
 *
 *  @return The name of the folder
 */
- (NSString*) displayName;

/**
 *  The localised name of the folder
 *
 *  @return The name of the folder
 */
- (NSString*) cleanedName;

/**
 *  The unique id of the Exchange Folder
 *
 *  @return The id
 */
- (NSString*) uniqueIdx;

/**
 *  The sync state of the Exchange folder
 *
 *  @return A String of the sync state
 */
- (NSString*) syncState;

/**
 *  A bool indicating that the folder have a custom color
 *
 *  @return A bool value
 */
- (NSNumber*) colorTheme;

/**
 *  The custom color of the folder
 *
 *  @return The folder color
 */
- (id) colorCustom;

/**
 *  The date of the last folder update
 *
 *  @return The date
 */
- (NSDate*)  lastUpdate;

@end
