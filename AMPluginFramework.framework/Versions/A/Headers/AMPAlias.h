//
//  AMPAlias.h
//  AMPluginFramework
//
//  Created by Joe on 17/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMPAccount;
@class AMPProvider;
#import "AMPObject.h"
@interface AMPAlias : AMPObject
{
    
}
/**
 *  The provider of the alias
 *
 *  @return The provider of the alias
 */
- (AMPProvider*) provider;

/**
 *  The account of the alias
 *
 *  @return The account of the alias
 */
- (AMPAccount*) account;

/**
 *  The alias name
 *
 *  @return The alias name
 */
- (NSString*) name;

/**
 *  The alias mail
 *
 *  @return The alias mail
 */
- (NSString*) mail;

/**
 *  The unique identifier
 *
 *  @return The unique identifier
 */
- (NSNumber*) idx;

/**
 *  A boolean if is the default sender
 *
 *  @return   A boolean if is the default sender
 */
- (NSNumber*) defaultSender;

/**
 *  A boolean if have a custom SMTP
 *
 *  @return A boolean if have a custom SMTP
 */
- (NSNumber*) customSmtp;

/**
 *  A boolean if the alias copy the mail in the sent folder
 *
 *  @return A boolean
 */
- (NSNumber*) copySent;

/**
 *  A boolean if is the default replier
 *
 *  @return A boolean if is the default replier
 */
- (NSNumber*) defaultReplier;

@end
