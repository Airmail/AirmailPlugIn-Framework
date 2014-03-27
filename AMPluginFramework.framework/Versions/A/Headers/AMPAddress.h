//
//  AMPAddress.h
//  AirMail
//
//  Created by Joe  on 11/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@interface AMPAddress : AMPObject
{
    
}


/**
 *  The name of the contact
 *
 *  @return The name of the contact
 */
- (NSString*) name;

/**
 *  The contact mail
 *
 *  @return The mail address
 */
- (NSString*) mail;

@end
