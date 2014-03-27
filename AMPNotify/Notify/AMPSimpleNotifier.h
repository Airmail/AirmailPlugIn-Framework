//
//  AMPNotify.h
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface AMPSimpleNotifier : AMPlugin <NSWindowDelegate>
{
    
}
@property (strong) NSSound *sound;
@property (strong) NSMutableArray *soundsarray;
@property (strong) NSMutableArray *windows;
- (NSMenu*) soundsMenu;
- (NSString*)savedPath;

@end
