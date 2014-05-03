//
//  PluginView.h
//  AirmailCss
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AMPlugin;
@interface AMPView : NSView
{
    
}
@property (weak) AMPlugin *plugin;
- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin*)pluginIn;


/**
 *  When the view is displayed on the Plugin selection in the preference section
 */
- (void) RenderView;

/**
 *  When all plugin is reloaded
 */
- (void) ReloadView;
@end
