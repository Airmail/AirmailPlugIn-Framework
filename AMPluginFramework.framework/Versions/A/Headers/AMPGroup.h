//
//  AMPGroup.h
//  AirMail
//
//  Created by Joe  on 11/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@interface AMPGroup : AMPObject
{
    
}

/**
 *  The contacts group name
 *
 *  @return The contacts group name
 */
- (NSString*) name;


/**
 *  An array of AMPAddress
 *
 *  @return An array of AMPAddress
 */
- (NSMutableArray*) addresses;

@end
