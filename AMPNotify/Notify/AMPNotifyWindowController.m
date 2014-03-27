//
//  AMPNotifyWindowController.m
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import "AMPNotifyWindowController.h"
#import "AMPNotifyWindow.h"
#import "AMPNotifyWindowView.h"

@interface AMPNotifyWindowController ()

@end

@implementation AMPNotifyWindowController

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    return self;
//}

- (id) initWithRect:(NSRect)rect
{
    contentRect = rect;
    AMPNotifyWindow *window = [[AMPNotifyWindow alloc] initWithContentRect:contentRect defer:YES];
    [window setTitle:@"NotifyWindow"];
    self = [super initWithWindow:window];
    if (self)
    {
        av = [[AMPNotifyWindowView alloc] initWithFrame:NSMakeRect(0, 0, contentRect.size.width, contentRect.size.height)];
        [window.contentView addSubview:av];
        
    }
    return self;
}

- (void) Render:(AMPMessage*)message
{
    [av Render:message];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
