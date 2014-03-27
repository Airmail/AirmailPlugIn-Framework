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
 *  The web view of the compose
 */
@property (weak)   WebView  *webView;

/**
 *  The original represented object passed by the plugin in the menu item
 */
@property (strong) NSObject *representedObject;

@end
