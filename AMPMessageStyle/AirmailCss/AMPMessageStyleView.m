//
//  CssView.m
//  AirmailCss
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import "AMPMessageStyleView.h"
#import "AMPMessageStyle.h"

@implementation AMPMessageStyleView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
    
        
        NSInteger x =  20;
        NSInteger y =  20;

        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y, 250, 20)];
		[textField setStringValue:NSLocalizedString(@"Style Selector:",@"Style Selector:")];
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

- (AMPMessageStyle*) myPlugin
{
    return (AMPMessageStyle*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    //Render
    NSArray *csss = [self.myPlugin.cssList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [a caseInsensitiveCompare:b];
    }];

    [popUpBtnRender.menu removeAllItems];
    NSMenuItem *itemRender = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"None", @"None") action:nil keyEquivalent:@""];
    [itemRender setRepresentedObject:@""];
    [itemRender setAction:@selector(changeCss:)];
    [itemRender setTarget:self];
    [popUpBtnRender.menu addItem:itemRender];
    
    [csss enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL *stop) {
        
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:path.lastPathComponent.stringByDeletingPathExtension action:nil keyEquivalent:@""];
        [item setRepresentedObject:path];
        [item setAction:@selector(changeCss:)];
        [item setTarget:self];
        [popUpBtnRender.menu addItem:item];
    }];
    
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

- (void) changeCss:(NSMenuItem*)item
{
    [self.myPlugin changeCss:item.representedObject];
}


//- (void)drawRect:(NSRect)dirtyRect
//{
//	[super drawRect:dirtyRect];
//	
//    // Drawing code here.
//    [[NSColor purpleColor] set];
//    NSRectFill(dirtyRect);
//}

@end
