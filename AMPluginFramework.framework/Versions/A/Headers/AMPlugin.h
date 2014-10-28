//
//  AMPlugin.h
//  AirMail
//
//  Created by Joe  on 11/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMPAccount;
@class AMPMessage;
@class AMPView;
@class AMPComposerInfo;
@class AMPMCOMessageParser;
@class AMPMCOMessageBuilder;
@class AMPSignatureVerify;
@class AMPSendResult;

@interface AMPlugin : NSObject
{
    
}
/**
 *  The plugin data path
 */
@property (strong) NSString *dataPath;

/**
 *  The plugin bundle
 */
@property (strong) NSBundle *bundle;

/**
 *  The plugin preferences
 */
@property (strong) NSMutableDictionary *preferences;

/**
 *  The plugin view (in plugin prefernece of AM)
 */
@property (strong) AMPView *myView;

- (id)initWithbundle:(NSBundle*)bundleIn path:(NSString*)pathIn;

/**
 *  The Load is called int the plugin init
 *
 *  @return Boolean if NO the plugin will not be loaded
 */
- (BOOL) Load;

//Must Have
/**
 *  The view to show in the AM preference (must override)
 *
 *  @return the view
 */
- (AMPView*)  pluginview;
    
/**
 *  The plugin name (must override)
 *
 *  @return the name
 */
- (NSString*) nametext;
    
/**
 *  A short description of the plugin (must override)
 *
 *  @return the description
 */
- (NSString*) descriptiontext;

/**
 *  The plugin author (must override)
 *
 *  @return The author
 */
- (NSString*) authortext;
    
/**
 *  The plugin version (from bundle)
 *
 *  @return plugin version
 */
- (NSString*) versiontext;
    
/**
 *  The plugin support link (must override)
 *
 *  @return support link
 */
- (NSString*) supportlink;
    
/**
 *  The plugin icon (must override)
 *
 *  @return icon
 */
- (NSImage*)  icon;

//Logs
/**
 *  Log an error
 *
 *  @param desc text for the log
 */
- (void) LogError:(NSString*)desc;
    
/**
 *  Trace log for debug
 *
 *  @param desc text for the log
 */
- (void) LogTrace:(NSString*)desc;

//Events
/**
 *  Called when the plugin is enabled
 */
- (void) Enable;
    
/**
 *  Called when the plugin is disabled
 */
- (void) Disable;
    
/**
 *  Called when the plugin is set to invalid state
 */
- (void) Invalid;
    
/**
 *  Called when the user decide to reload the plugin
 */
- (void) Reload;

//Utilities
/**
 *  load an image from the plugin bundle
 *
 *  @return the image
 */
- (NSImage*) loadImage:(NSString*)imageName;

/**
 *  the suggested path for saving data
 *
 *  @return the path
 */
- (NSString*) suggestedpath;
    
/**
 *  The plugin bundle identifier
 *
 *  @return the identifier
 */
- (NSString*) identifier;
    
/**
 *  A method to save a preference (key,value) in a plist 
 *  in the suggested path folder
 *
 *  @return Yes if successful
 */
- (BOOL) SavePreferences;
    
/**
 *  The path of the preference plist
 *
 *  @return the path
 */
- (NSString*) preferencesPath;
    
/**
 *  A list of the files under the plugin data folder (suggested path)
 *
 *  @return an array of paths
 */
- (NSArray*)  suggestedpathContents;
    
/**
 *  A list of the files under the plugin bundle resources
 *
 *  @return an array of paths
 */
- (NSArray*)  bundlepathContents;

//Account / Folders
/**
 *  All Accounts of Airmail
 *
 *  @return an array of AMPAccount
 */
- (NSArray*) Accounts;
    
/**
 *  All the folders for an account
 *
 *  @param ampacc the account of the requested folders
 *
 *  @return an array of AMPFolder
 */
- (NSArray*) Folders:(AMPAccount*)ampacc;
    
/**
 *  All the folders for an account standard folders(inbox,starred,...) first
 *
 *  @param ampacc the account of the requested folders
 *
 *  @return an array of AMPFolder
 */
- (NSArray*) OrderedFoldersWithStandardFirst:(AMPAccount*)ampacc;

#pragma mark - Composer
/**
 *  Get the html from a message to render in the composer
 *  Unique methods are called only one time from AM, if more than one plugin
 *  support Unique methods only one of them (randomly) will be used
 *
 *  @param info the message to render
 *
 *  @return the html to render
 */
- (NSString*)  ampUniqueComposerRenderHtml:(AMPComposerInfo*)info;
/**
 *  Get the html for the new created composer
 *
 *  @param info of the current composer
 *
 *  @return the html to render
 */
- (NSString*)  ampStackComposerRenderHtmlFromHtml:(NSString*)html composerInfo:(AMPComposerInfo*)info;

/**
 *  The menu item that AM will add in the composer
 *
 *  @return the menu item
 */
- (id) ampMenuComposerItem:(AMPComposerInfo*)info;

/**
 *  Called to add a button on the composer
 *
 *  @param info of the current composer
 *
 *  @return the button to show
 */
- (NSArray*) ampPileComposerView:(AMPComposerInfo *)info;

/**
 *  Called on a recipients change in the composer
 *
 *  @param info of the current composer
 *
 *  @return void
 */
- (NSNumber*) ampPileChangedRecipients:(AMPComposerInfo*)info;

#pragma mark - Render BodyView
/**
 *  Get the html from a message to render in the bodyview
 *  Unique methods are called only one time from AM, if more than one plugin
 *  support Unique methods only one of them (randomly) will be used
 *
 *  @param message the message to render
 *
 *  @return info of the current composer
 */
- (NSString*) ampUniqueMessageRender:(AMPMessage*)message;

/**
 *  Get the html from the html that AM create from a message, to render in the
 *  bodyview. Stack methods can be queued, so AM will call all the plugins with 
 *  a stack method in a random order.
 *
 *  @param html the html to process
 *
 *  @return the html to render
 */
- (NSString*) ampStackMessageRenderFromHtml:(NSString*)html message:(AMPMessage*)message;

/**
 *  Get the a message and create an array of  NSView to render in the bodyview
 *
 *  @param message the message to render
 *
 *  @return the array of views to render
 */
- (NSArray*) ampPileMessageView:(AMPMessage*)message;

#pragma mark - Notify
/**
 *  Called after the standard AM notify. Is called for each message that AM will notify in the notification center
 *
 *  @param message the message to notify
 *
 *  @return a number with a boolean YES/NO
 */
- (NSNumber*) ampQueueNotify:(AMPMessage*)message;

#pragma mark - Action
/**
 *  The menu item that AM will add to the message menu
 *
 *  @param messages the selected messages when the item is activated
 *
 *  @return the menu item
 */
- (id) ampMenuActionItem:(NSArray*)messages;

#pragma mark - Rule
/**
 *  Called as rule action
 *
 *  @param message the message filtered by the rule condition
 *
 *  @return the Number for a bool if the rule is applied to the message
 */
- (NSNumber*) ampRuleActionItem:(AMPMessage*)message;

#pragma mark - Crypto
/**
 *  Called to let AM know if the message is encrypted
 *
 *  @param the parser of the rfc to analyze
 *
 *  @return a Number with the amp_encryption_type 
 */
- (NSNumber*)  ampPileIsEncrypted:(AMPMCOMessageParser*)parser;

/**
 *  Called to decrypt the message
 *
 *  @param the message
 *
 *  @return the decrypted rfc data to render
 */
- (NSData*) ampStackDecrypt:(AMPMessage*)message;

/**
 *  Called to verify the signature of the message
 *
 *  @param the message
 *
 *  @return a Number with the amp_verify_signature value
 */
- (AMPSignatureVerify*) ampPileVerifySignature:(AMPMessage*)message;


#pragma mark - Send
/**
 *  Called to before to send a mail
 *
 *  @param the builder of the rfc to change
 *
 *  @return the builder of the rfc to send
 */
- (AMPSendResult*) ampStackSendRfc:(NSString*)rfc composer:(AMPComposerInfo*)info;

@end
