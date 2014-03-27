//
//  AMPSignature.h
//  AMPluginFramework
//
//  Created by Joe on 17/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMPAccount;
#import "AMPObject.h"
@interface AMPSignature : AMPObject
{
    
}
/**
 *  The Account of the signature
 *
 *  @return the account
 */
-(AMPAccount*) account;

/**
 *  Unique identifier of the object
 *
 *  @return unique identifier
 */
-(NSNumber*) idx;

/**
 *  A boolean if the signature is the default one
 *
 *  @return A boolean
 */
-(NSNumber*) defaultSign;

/**
 *  The HTML of the signature
 *
 *  @return HTML String
 */
-(NSString*) html;

/**
 *  the mail of the signature
 *
 *  @return the mailof the signature
 */
-(NSString*) mail;

/**
 *  The name of the signature
 *
 *  @return The name of the signature
 */
-(NSString*) name;

/**
 *  An array of the attachments file paths
 *
 *  @return An array of the attachments file paths
 */
-(NSArray*) attachments;


@end
