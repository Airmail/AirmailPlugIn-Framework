//
//  AMPTranslateView.m
//  AMPTranslate
//
//  Created by Joe on 19/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import "AMPTranslateView.h"
#import "AMPTranslate.h"

@implementation AMPTranslateView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
        
        
        NSInteger x =  20;
        NSInteger y =  20;
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y, 250, 20)];
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

- (AMPTranslate*) myPlugin
{
    return (AMPTranslate*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    NSMenu *menu = [self.myPlugin langMenu];
    [popUpBtnRender setMenu:menu];
    
    //Selection
    NSString *lang = [self.myPlugin savedLang];
    if(lang && [lang isKindOfClass:[NSString class]])
    {
        for(NSMenuItem *item in popUpBtnRender.menu.itemArray)
        {
            if([item.representedObject isEqualToString:lang])
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
