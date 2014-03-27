//
//  AMPNotifyWindowController.h
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AMPMessage;
@class AMPNotifyWindowView;
@interface AMPNotifyWindowController : NSWindowController
{
    NSRect contentRect;
    AMPNotifyWindowView *av;
}
- (id) initWithRect:(NSRect)rect;
- (void) Render:(AMPMessage*)message;
@end
