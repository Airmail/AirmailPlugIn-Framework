//
//  AMPNotifyWindow.m
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import "AMPNotifyWindow.h"

@implementation AMPNotifyWindow


- (id)initWithContentRect:(NSRect)contentRect defer:(BOOL)flag {
    return [self initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
}


- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    // Regardless of what is passed via the styleMask paramenter, always create a NSBorderlessWindowMask window
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    if (self) {
        // This window is always has a shadow and is transparent. Force those setting here.
        [self setHasShadow:YES];
        [self setBackgroundColor:[[NSColor whiteColor]colorWithAlphaComponent:0.05f]];
        [self setMovableByWindowBackground:YES];
        [self setOpaque:NO];
        [self setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];

    }
    return self;
}

//- (void) dealloc
//{
//}

-(BOOL) canBecomeKeyWindow
{
    return YES;
}

-(BOOL) canBecomeMainWindow
{
    return YES;
}

@end
