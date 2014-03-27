//
//  AMPTranslate.h
//  AMPTranslate
//
//  Created by Joe on 19/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <AMPluginFramework/AMPluginFramework.h>

@interface AMPTranslate : AMPlugin
{
    
}
@property (strong) NSString *lang;
- (NSMenu*) langMenu;
- (NSString*) savedLang;
@end
