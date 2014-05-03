//
//  AMPObject.h
//  AMPluginFramework
//
//  Created by Joe on 19/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPObject : NSObject
{
    
}
/**
 *  The Airmail object. is the base object used to create the AMP models
 *
 *  @return the AM object
 */
- (id) object;
- (id) initWithObject:(NSObject*)obj;

/**
 *  Simple method to call selectors on the AM object
 *
 *  @param selector the AM selector
 *  @param object   the AM object
 *
 *  @return an id with the populated property
 */
- (id) callSelector:(SEL)selector;
- (id) callSelector:(SEL)selector obj:(id)object;
- (id) callSelector:(SEL)selector obj:(id)object obj:(id)object2;

@end
