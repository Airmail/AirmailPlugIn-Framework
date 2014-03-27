//
//  AirmailCss.h
//  AirmailCss
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>
@interface AMPMessageStyle : AMPlugin
{
    
}
@property (strong) NSMutableArray *cssList;
@property (strong) NSString *cssString;
- (NSString*) savedPath;
- (void)      changeCss:(NSString*)str;
@end
