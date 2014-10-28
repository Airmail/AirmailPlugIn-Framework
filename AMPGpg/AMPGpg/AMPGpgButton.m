//
//  AMPSwitchButton.m
//  AMPSmime
//
//  Created by Gio on 15/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import "AMPGpgButton.h"

@interface AMPGpgButton()
{
    BOOL firstInit;
    NSInteger rememberChoice;
    NSInteger savedState;
}
@end

@implementation AMPGpgButton

- (id)initWithFrame:(NSRect)frame
              image:(NSImage*)image
                alt:(NSImage*)altImage
                tag:(NSInteger)tag
     rememberChoice:(NSInteger)rememberChoiceIn
{
    self = [super initWithFrame:frame];
    if (self)
    {
        rememberChoice = rememberChoiceIn;

        [self setAction:@selector(SwitchBtn:)];
        [self setTarget:self];
        [self setBordered:NO];
        [self setButtonType:NSToggleButton];
        [self setTitle:@""];
        [self setTag:tag];
        [self setImage:altImage];
        [self setAlternateImage:image];
        savedState = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"AMPGpgButton_%ld",self.tag]];
        [self setState:NSOffState];

    }
    return self;
}

- (void) SwitchBtn:(NSButton*)btn
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.state forKey:[NSString stringWithFormat:@"AMPGpgButton_%ld",self.tag]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isActive;
{
    return (BOOL)self.state;
}

- (void) ManageState:(BOOL)enable
{
    if(enable)
    {
        [self setEnabled:YES];
        if(rememberChoice == 2 && !firstInit)
        {
            firstInit = YES;
            [self setState:savedState];
        }
        else
        {
            [self setState:enable];
        }
    }
    else
    {
        [self setState:NSOffState];
        [self setEnabled:NO];
    }
}



@end
