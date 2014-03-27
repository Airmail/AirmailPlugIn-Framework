//
//  AMPUidFlag.h
//  AMPluginFramework
//
//  Created by Joe on 19/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPUidFlag : NSObject
{
    
}

/**
 *  the uid of the message for a folder
 */
@property NSInteger uid;

/**
 *  the flags of the message for a folder (amp_flags)
 */
@property NSInteger flags;
@end
