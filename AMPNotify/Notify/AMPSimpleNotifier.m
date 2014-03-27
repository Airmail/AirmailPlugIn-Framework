//
//  AMPNotify.m
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import "AMPSimpleNotifier.h"
#import "AMPSimpleNotifierView.h"
#import "AMPNotifyWindowController.h"

const NSString *amp_notify_option = @"amp_notify_option";

@implementation AMPSimpleNotifier
{
    
}

- (BOOL) Load
{
    if(![super Load])
        return NO;
    
    self.windows     = [NSMutableArray array];
    self.soundsarray = [NSMutableArray array];
    
    //Load Bundle
    NSMutableArray *allpaths = [NSMutableArray array];
    
    NSArray *bundlesPath     = [self bundlepathContents];
    if(!bundlesPath)
        return NO;
    [allpaths addObjectsFromArray:bundlesPath];
    
    NSArray *dirPaths       = [self suggestedpathContents];
    if(!dirPaths)
        return NO;
    [allpaths addObjectsFromArray:dirPaths];
    
    for(NSString *path in allpaths)
    {
        if([path.pathExtension isEqualToString:@"wav"])
            [self.soundsarray addObject:path];
    }
    
    //Load Preference
    NSString *path = [self.preferences objectForKey:amp_notify_option];
    if(path && [path isKindOfClass:[NSString class]])
        self.sound = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
    
    [self Reload];
    return YES;
}

- (void) Enable
{
    
}

- (void) Disable
{
    
}

- (void) Invalid
{
    
}

- (void) Reload
{
    return [self.myView ReloadView];
}

- (AMPView*) pluginview
{
    if(!self.myView)
        self.myView = [[AMPSimpleNotifierView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}


- (NSString*) description
{
    return self.nametext;
}

- (NSString*) nametext
{
    return @"Simple Notifier SDK";
}

- (NSString*) descriptiontext
{
    return @"This plugin is a side note for messages, is asample where you can store additional data to your messages.";
}

- (NSString*) supportlink
{
    return @"http://adv.bloop.info/airmail/sdk.php";
}

- (NSString*) authortext
{
    return @"Airmail SDK Sample";
}


- (NSImage*) icon
{
    return [NSImage imageNamed:@"iconx"];
}

- (NSNumber*) ampQueueNotify:(AMPMessage*)message
{
    return @([self CallNotifier:message]);
}

- (NSNumber*) ampRuleActionItem:(AMPMessage*)message
{
    return @([self CallNotifier:message]);
}

- (BOOL) CallNotifier:(AMPMessage*)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.sound)
            [self.sound play];
        
        AMPNotifyWindowController *con = [[AMPNotifyWindowController alloc] initWithRect:NSMakeRect(0,0, 400, 200)];
        
        NSScreen *screen    = [NSScreen mainScreen];
        NSRect screenRect   = [screen visibleFrame];
        NSRect frame        = NSZeroRect;
        frame.origin.x      = screenRect.size.width  - con.window.frame.size.width-20;
        frame.origin.y      = screenRect.size.height - con.window.frame.size.height;
        frame.size.width    = con.window.frame.size.width;
        frame.size.height   = con.window.frame.size.height;
        
        [con.window setDelegate:self];
        [con.window setFrame:frame display:NO];
        [con Render:message];
        [con showWindow:con];
        [self.windows addObject:con];
    });
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSWindow *win = notification.object;
    if([win.windowController isKindOfClass:[AMPNotifyWindowController class]])
    {
        AMPNotifyWindowController *con = win.windowController;
        [self.windows removeObject:con];
    }
}

#pragma mark - manage sounds
- (NSMenu*) soundsMenu
{
    NSMenu *menu = [NSMenu new];
    NSArray *soundsss = [self.soundsarray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [a caseInsensitiveCompare:b];
    }];
    
    NSMenuItem *itemRender = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"No Sound", @"No Sound") action:nil keyEquivalent:@""];
    [itemRender setRepresentedObject:@""];
    [itemRender setAction:@selector(changeSound:)];
    [itemRender setTarget:self];
    [menu addItem:itemRender];
    
    [soundsss enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL *stop) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:path.lastPathComponent.stringByDeletingPathExtension action:nil keyEquivalent:@""];
        [item setRepresentedObject:path];
        [item setAction:@selector(changeSound:)];
        [item setTarget:self];
        [menu addItem:item];
    }];
    return menu;
    
}


-(NSString*) savedPath
{
    return [self.preferences objectForKey:amp_notify_option];
}


-(void) changeSound:(NSMenuItem*)item
{
    NSString *str = item.representedObject;
    if(str.length == 0)
    {
        [self.preferences removeObjectForKey:amp_notify_option];
        self.sound = nil;
    }
    else
    {
        [self.preferences removeObjectForKey:amp_notify_option];
        [self.preferences setObject:str forKey:amp_notify_option];
        self.sound = [[NSSound alloc] initWithContentsOfFile:str byReference:NO];
        [self.sound play];
    }
    [self SavePreferences];

}

@end
