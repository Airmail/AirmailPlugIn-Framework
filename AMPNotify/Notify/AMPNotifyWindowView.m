//
//  AMPNotifyWindowView.m
//  Notify
//
//  Created by Joe  on 17/11/13.
//  Copyright (c) 2013 Boop. All rights reserved.
//

#import "AMPNotifyWindowView.h"
#import <AMPluginFramework/AMPluginFramework.h>

@implementation AMPNotifyWindowView

- (BOOL) isFlipped
{
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        NSInteger x =  20;
        NSInteger y =  20;

        imageMsgView = [[NSImageView alloc] initWithFrame:NSMakeRect(x, y, 48 , 48)];
        [self addSubview:imageMsgView];
        
        imageAccView = [[NSImageView alloc] initWithFrame:NSMakeRect(56, 54, 24 , 24)];
        [self addSubview:imageAccView];
        


        fromTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(90 , y, self.frame.size.width-110, 20)];
		[fromTextField setStringValue:@""];
        [fromTextField setBezeled:NO];
        [fromTextField setDrawsBackground:NO];
        [fromTextField setEditable:NO];
        [fromTextField setSelectable:NO];
        [fromTextField setFont:[NSFont systemFontOfSize:12]];
        [[fromTextField cell] setTruncatesLastVisibleLine:YES];
        [[fromTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        //        [subjectTextField setAlignment: NSRightTextAlignment];
		[self addSubview:fromTextField];

        y+=30;
        subjectTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, y, self.frame.size.width-110, 20)];
		[subjectTextField setStringValue:@""];
        [subjectTextField setBezeled:NO];
        [subjectTextField setDrawsBackground:NO];
        [subjectTextField setEditable:NO];
        [subjectTextField setSelectable:NO];
        [subjectTextField setFont:[NSFont boldSystemFontOfSize:12]];
        [[subjectTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [[subjectTextField cell] setTruncatesLastVisibleLine:YES];

//        [subjectTextField setAlignment: NSRightTextAlignment];
		[self addSubview:subjectTextField];

        y+=30;
        excerptTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(x  , y, self.frame.size.width-x, self.frame.size.height - y - 60)];
		[excerptTextField setStringValue:@""];
        [excerptTextField setBezeled:NO];
        [excerptTextField setDrawsBackground:NO];
        [excerptTextField setEditable:NO];
        [excerptTextField setSelectable:NO];
        [excerptTextField setFont:[NSFont systemFontOfSize:11]];
        [[excerptTextField cell] setTruncatesLastVisibleLine:YES];

        [[excerptTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        //        [subjectTextField setAlignment: NSRightTextAlignment];
		[self addSubview:excerptTextField];
        
        
        NSInteger x1 = 20;
        NSButton *btnReply = [[NSButton alloc] initWithFrame:NSMakeRect(x1, self.frame.size.height-40, 60, 24)];
        [btnReply setTitle:@"Reply"];
        [btnReply setBezelStyle:10];
        [btnReply setAction:@selector(Reply:)];
        [btnReply setTarget:self];
        [self addSubview:btnReply];
        
        x1+=70;
        NSButton *btnForward = [[NSButton alloc] initWithFrame:NSMakeRect(x1, self.frame.size.height-40, 60, 24)];
        [btnForward setTitle:@"Forward"];
        [btnForward setBezelStyle:10];
        [btnForward setAction:@selector(Forward:)];
        [btnForward setTarget:self];
        [self addSubview:btnForward];
        
        x1+=70;
        NSButton *btnArchive = [[NSButton alloc] initWithFrame:NSMakeRect(x1, self.frame.size.height-40, 60, 24)];
        [btnArchive setTitle:@"Archive"];
        [btnArchive setBezelStyle:10];
        [btnArchive setAction:@selector(Archive:)];
        [btnArchive setTarget:self];
        [self addSubview:btnArchive];
        
        x1+=70;
        NSButton *btnTrash = [[NSButton alloc] initWithFrame:NSMakeRect(x1, self.frame.size.height-40, 60, 24)];
        [btnTrash setTitle:@"Trash"];
        [btnTrash setBezelStyle:10];
        [btnTrash setAction:@selector(Trash:)];
        [btnTrash setTarget:self];
        [self addSubview:btnTrash];

        x1+=70;
        NSButton *btnClose = [[NSButton alloc] initWithFrame:NSMakeRect(x1, self.frame.size.height-40, 60, 24)];
        [btnClose setTitle:@"Close"];
        [btnClose setBezelStyle:10];
        [btnClose setAction:@selector(Close:)];
        [btnClose setTarget:self];
        [self addSubview:btnClose];


    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
//	[super drawRect:dirtyRect];
	
    //// Color Declarations
    NSColor* color4 = [NSColor colorWithCalibratedHue:0.0 saturation:0.2f brightness:1 alpha:0.7];
    
    //// Gradient Declarations
    NSGradient* gradients = [[NSGradient alloc] initWithColorsAndLocations:
                             [NSColor whiteColor], 0.0,
                             [NSColor colorWithCalibratedHue:0.0 saturation:0.1f brightness:1 alpha:0.95], 0.5,
                             color4, 1.0, nil];
    
    //// Rounded Rectangle Drawing
    NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height) xRadius: 10 yRadius: 10];
    [gradients drawInBezierPath: roundedRectanglePath angle: -90];
    [[NSColor colorWithCalibratedHue:0.0 saturation:0.0f brightness:1 alpha:0.8] setStroke];
//    [roundedRectanglePath setLineWidth: 1];
//    [roundedRectanglePath stroke];


    // Drawing code here.
}

- (void) Render:(AMPMessage*)messageIn
{
    self.message = messageIn;
    
    if(self.message.account.profileIcon)
        [imageAccView setImage:self.message.account.profileIcon];
    
    NSImage *im = [[AMPCallBack shared] MessageImage:self.message];
    if(im)
    {
        NSImage *flipim = [[NSImage alloc] initWithData:im.TIFFRepresentation];
        [flipim setFlipped:NO];
        [imageMsgView setImage:flipim];
    }
    
    if(self.message.from.description)
        [fromTextField    setStringValue:self.message.from.description];
    
    if(self.message.subject)
        [subjectTextField setStringValue:self.message.subject];
    
    if(self.message.excerpt)
        [excerptTextField setStringValue:self.message.excerpt];
}

- (void) Reply:(NSButton*)btn
{
    if(self.message)
        [[AMPCallBack shared] ReplyMessages:@[self.message]];
}

- (void) Archive:(NSButton*)btn
{
    if(self.message)
        [[AMPCallBack shared] ArchiveMessages:@[self.message]];
}

- (void) Forward:(NSButton*)btn
{
    if(self.message)
        [[AMPCallBack shared] ForwardMessages:@[self.message]];
}

- (void) Trash:(NSButton*)btn
{
    if(self.message)
        [[AMPCallBack shared] TrashMessages:@[self.message]];
}

- (void) Close:(NSButton*)btn
{
    [self.window close];
}


@end
