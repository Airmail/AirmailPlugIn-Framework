//
//  AMPNotifyWindowView.h
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AMPMessage;
@interface AMPNotifyWindowView : NSView
{
    NSImageView *imageMsgView, *imageAccView;
    NSTextField *fromTextField, *subjectTextField, *excerptTextField;
}
@property (strong) AMPMessage *message;
- (void) Render:(AMPMessage*)messageIn;
@end
