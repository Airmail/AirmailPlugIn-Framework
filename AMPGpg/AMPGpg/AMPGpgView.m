//
//  AMPGpgView.m
//  AMPGpg
//
//  Created by Giovanni Simonicca on 16/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPGpgView.h"
#import "AMPGpg.h"
#import <AMPluginFramework/AMPluginFramework.h>

@interface  AMPGpgView()
{
    NSPopUpButton *popUpBtnRender;
}
@end

@implementation AMPGpgView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
        NSInteger x =  20;
        NSInteger y =  20;
        
        NSTextField *textSystem = [[NSTextField alloc] initWithFrame:NSMakeRect(x, y+5, 140, 30)];
		[textSystem setStringValue:NSLocalizedString(@"Composer:",@"Composer:")];
        [textSystem setBezeled:NO];
        [textSystem setDrawsBackground:NO];//deprecated
        [textSystem setEditable:NO];
        [textSystem setSelectable:NO];
        [textSystem setAlignment: NSRightTextAlignment];
		[self addSubview:textSystem];
        
        NSButton *savePref = [[NSButton alloc] initWithFrame:NSMakeRect(x+160, y, 250, 30)];        //[savePref AssignTEXTUREDROUNDED];
        [savePref setButtonType:NSSwitchButton];
		[savePref setTitle:NSLocalizedString(@"Remember Choice",@"Remember Choice")];
        [savePref setAction:@selector(RememberChoice:)];
        [savePref setTarget:self];
		[self addSubview:savePref];
        [savePref setState:self.myPlugin.rememberChoice-1];
        [self LoadView];
    }
    return self;
}


- (void) RememberChoice:(id)sender
{
    self.myPlugin.rememberChoice = [sender state]+1;
    [[NSUserDefaults standardUserDefaults] setInteger:self.myPlugin.rememberChoice forKey:AMPGpgRemeberChoice];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (AMPGpg*) myPlugin
{
    return (AMPGpg*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
//    NSDictionary *xxx = [AMPCertManager listCertificates];
//    NSMenu *menu = [NSMenu new];
//    
//    [xxx enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSArray *mails, BOOL *stop) {
//        
//        if(mails.count == 0)
//            return;
//        
//        NSMenuItem *itemRender = [[NSMenuItem alloc] initWithTitle:name action:nil keyEquivalent:@""];
//        [itemRender setRepresentedObject:@""];
//        [itemRender setTarget:self];
//        
//        NSMenu *menu2 = [NSMenu new];
//        for(NSString *mail in mails)
//        {
//            NSMenuItem *itemRender2 = [[NSMenuItem alloc] initWithTitle:mail action:@selector(selectedMail:) keyEquivalent:@""];
//            [itemRender2 setRepresentedObject:@""];
//            [itemRender2 setTarget:self];
//            [menu2 addItem:itemRender2];
//        }
//        [itemRender setSubmenu:menu2];
//        [menu addItem:itemRender];
//    }];
//    [popUpBtnRender setMenu:menu];
}

- (void) selectedMail:(id)sender
{
    
}

- (void) RenderView
{
    
}

-(void) Save:(id)sender
{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
