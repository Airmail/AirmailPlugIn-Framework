//
//  AMPNotifyView.m
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import "AMPSimpleNotifierView.h"
#import "AMPSimpleNotifier.h"

@implementation AMPSimpleNotifierView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
        
        NSInteger x = 20;
        NSInteger y = 20;
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y+5, 250, 20)];
		[textField setStringValue:NSLocalizedString(@"Notification Sound:",@"Notification Sound:")];
        [textField setBezeled:NO];
        [textField setDrawsBackground:NO];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        [textField setFont:[NSFont systemFontOfSize:13]];
        [[textField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [textField setAlignment: NSRightTextAlignment];
		[self addSubview:textField];
        
        popUpBtn = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(x+270, y, 200, 30) pullsDown:NO];
        [(NSPopUpButtonCell *)[popUpBtn cell] setBezelStyle:NSTexturedRoundedBezelStyle];
        [[popUpBtn cell] setArrowPosition:NSPopUpArrowAtBottom];
        [popUpBtn setAutoresizingMask:NSViewMaxYMargin];
        [self addSubview:popUpBtn];

        [self LoadView];
    }
    return self;
}

- (AMPSimpleNotifier*) myPlugin
{
    return (AMPSimpleNotifier*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    NSMenu *menu = [self.myPlugin soundsMenu];
    [popUpBtn setMenu:menu];
    
    //Selection
    NSString *pathRender = [self.myPlugin savedPath];
    if(pathRender && [pathRender isKindOfClass:[NSString class]])
    {
        for(NSMenuItem *item in popUpBtn.menu.itemArray)
        {
            if([item.representedObject isEqualToString:pathRender])
            {
                [popUpBtn selectItem:item];
                break;
            }
        }
    }
}

- (void) RenderView
{
    
}

@end
