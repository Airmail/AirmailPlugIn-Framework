//
//  AMPCrypto.h
//  AMPCrypto
//
//  Created by Gio on 11/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import <AMPluginFramework/AMPluginFramework.h>

@interface AMPCrypto : AMPlugin
{
    BOOL encrypt;
}
@property (strong) NSString *password, *mail;
- (BOOL) savePswd:(NSString*)pswd;
- (void) saveMail:(NSString*)mailIn;
@end
