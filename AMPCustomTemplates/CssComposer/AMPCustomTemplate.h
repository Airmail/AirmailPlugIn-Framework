//
//  AMPCssComposer.h
//  CssComposer
//
//  Created by Joe on 16/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface AMPCustomTemplate : AMPlugin
{
  
}
@property (strong) NSMutableArray *cssList;
@property (strong) NSString *cssString,*cssStringComposer;

-(NSString*)savedPath;
-(void)     changeCss:(NSString*)str;
- (NSMenu*) stylesMenuComposerButton;
- (NSMenu*) stylesMenu;

@end
