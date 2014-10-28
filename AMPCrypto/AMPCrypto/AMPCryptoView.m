//
//  AMPCryptoView.m
//  AMPCrypto
//
//  Created by Gio on 11/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPCryptoView.h"
#import "AMPCrypto.h"
#import "SSKeychain.h"

@implementation AMPCryptoView

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        // Initialization code here.
        
        NSInteger x =  20;
        NSInteger y =  20;
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y, 100, 20)];
		[textField setStringValue:NSLocalizedString(@"Password:",@"Password:")];
        [textField setBezeled:NO];
        [textField setDrawsBackground:NO];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        [textField setFont:[NSFont systemFontOfSize:13]];
        [[textField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [textField setAlignment: NSRightTextAlignment];
		[self addSubview:textField];

        secureField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(x+170, y, 150, 20)];
        [secureField setBezeled:NO];
        [secureField setDrawsBackground:YES];
        [secureField setEditable:YES];
        [secureField setSelectable:YES];
        [secureField setFont:[NSFont systemFontOfSize:13]];
        [[secureField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [self addSubview:secureField];
        
        x  = 20;
        y += 30;
        NSTextField *textField2 = [[NSTextField alloc] initWithFrame:NSMakeRect(x+3, y, 100, 20)];
		[textField2 setStringValue:NSLocalizedString(@"Email:",@"Email:")];
        [textField2 setBezeled:NO];
        [textField2 setDrawsBackground:NO];
        [textField2 setEditable:NO];
        [textField2 setSelectable:NO];
        [textField2 setFont:[NSFont systemFontOfSize:13]];
        [[textField2 cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [textField2 setAlignment: NSRightTextAlignment];
		[self addSubview:textField2];
        
        mailField = [[NSTextField alloc] initWithFrame:NSMakeRect(x+170, y, 150, 20)];
        [mailField setBezeled:NO];
        [mailField setDrawsBackground:YES];
        [mailField setEditable:YES];
        [mailField setSelectable:YES];
        [mailField setFont:[NSFont systemFontOfSize:13]];
        [[mailField cell] setBackgroundStyle:NSBackgroundStyleRaised];
		[self addSubview:mailField];
        
        NSButton *btn = [[NSButton alloc] initWithFrame:NSMakeRect(x+170, y+60, 200, 30)];
        [btn setTitle:@"Save"];
        [btn setTarget:self];
        [btn setAction:@selector(Save:)];
		[self addSubview:btn];

        [self LoadView];
    }
    return self;
}


- (AMPCrypto*) myPlugin
{
    return (AMPCrypto*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    
}

- (void) RenderView
{
    if(secureField.stringValue.length == 0 && self.myPlugin.password)
        [secureField setStringValue:self.myPlugin.password];
    
    if(mailField.stringValue.length == 0 && self.myPlugin.mail)
        [mailField setStringValue:self.myPlugin.mail];

//    [[secureField currentEditor] setSelectedRange:NSMakeRange([[secureField stringValue] length], 0)];
}

-(void) Save:(id)sender
{
    [self.myPlugin saveMail:mailField.stringValue];
    
    if(![self.myPlugin savePswd:secureField.stringValue])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Save Password"];
        [alert setInformativeText:@"Cannot save the password"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    
}


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
