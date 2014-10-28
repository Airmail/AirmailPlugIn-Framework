//
//  AMPGpgBodyView.m
//  AMPGpg
//
//  Created by Giovanni Simonicca on 17/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPGpgBodyView.h"

@implementation AMPGpgBodyView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor redColor] set];
    NSRectFill(dirtyRect);
}

@end
