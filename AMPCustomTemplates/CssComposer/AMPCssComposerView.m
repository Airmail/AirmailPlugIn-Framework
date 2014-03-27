//
//  AMPCssComposerView.m
//  AirmailCssComposer
//
//  Created by Joe on 16/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import "AMPCssComposerView.h"
#import "AMPCustomTemplate.h"

@implementation AMPCssComposerView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
        
        
        NSInteger x =  20;
        NSInteger y =  20;
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y+5, 250, 20)];
		[textField setStringValue:NSLocalizedString(@"Template Selector:",@"Template Selector:")];
        [textField setBezeled:NO];
        [textField setDrawsBackground:NO];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        [textField setFont:[NSFont systemFontOfSize:13]];
        [[textField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [textField setAlignment: NSRightTextAlignment];
		[self addSubview:textField];
        
        popUpBtnRender = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(x+270, y, 200, 30) pullsDown:NO];
        [(NSPopUpButtonCell *)[popUpBtnRender cell] setBezelStyle:NSTexturedRoundedBezelStyle];
        [[popUpBtnRender cell] setArrowPosition:NSPopUpArrowAtBottom];
        [popUpBtnRender setAutoresizingMask:NSViewMaxYMargin];
        [self addSubview:popUpBtnRender];
        
        [self LoadView];
    }
    return self;
}

- (AMPCustomTemplate*) myPlugin
{
    return (AMPCustomTemplate*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    NSMenu *menu = [self.myPlugin stylesMenu];
    [popUpBtnRender setMenu:menu];
    
    //Selection
    NSString *pathRender = [self.myPlugin savedPath];
    if(pathRender && [pathRender isKindOfClass:[NSString class]])
    {
        for(NSMenuItem *item in popUpBtnRender.menu.itemArray)
        {
            if([item.representedObject isEqualToString:pathRender])
            {
                [popUpBtnRender selectItem:item];
                break;
            }
        }
    }
}

- (void) RenderView
{
    
}


@end
