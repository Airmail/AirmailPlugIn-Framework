//
//  AMPComposerInfo.h
//  AMPluginFramework
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class AMPMessage;
@class AMPlugin;
@interface AMPComposerInfo : NSObject
{
    NSObject *back;
}

/**
 *  the local message created by the composer
 */
@property (strong) AMPMessage *localMessage;

/**
 *  the reply message in the case of a reply
 */

@property (strong) AMPMessage *replyMessage;
/**
 *  type is (amp_mailcomposertype)
 */
@property (strong) NSNumber *type;

/**
 *  the composer mode (amp_composertype)
 */
@property (strong) NSNumber *mode;

/**
 *  The web view of the composer
 */
@property (weak)   WebView  *webView;

/**
 *  The original represented object passed by the plugin in the menu item
 */
@property (strong) NSObject *representedObject;

/**
 *  All the plugins views in the composer
 */
@property (weak) NSDictionary *composerViews;

/**
 *  Get the composer button for the input plugin
 */
- (NSArray*) composerBtn:(AMPlugin*)plugin;



@end
