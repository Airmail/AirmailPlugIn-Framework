//
//  AMPSendResult.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 18/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPSendResult : NSObject
{
    
}
/**
 *  the result of the sending (encrypt/sign) type amp_send_result
 */
@property NSInteger result;

/**
 *  the result of the sending (encrypt/sign)
 */
@property (strong) NSString *rfc;

/**
 *  the error of the sending (encrypt/sign)
 */
@property (strong) NSString *err;
@end
