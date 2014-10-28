//
//  AMPSwitchButton.h
//  AMPSmime
//
//  Created by Gio on 15/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMPGpgButton : NSButton
{
    
}
- (id)initWithFrame:(NSRect)frame
              image:(NSImage*)image
                alt:(NSImage*)altImage
                tag:(NSInteger)tag
     rememberChoice:(NSInteger)rememberChoiceIn;
- (void) ManageState:(BOOL)enable;
- (BOOL) isActive;

@end
