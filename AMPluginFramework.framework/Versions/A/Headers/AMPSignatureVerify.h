//
//  AMPSignatureVerify.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 17/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPSignatureVerify : NSObject
{
    
}
/**
 *  the result of the verify of type amp_verify_signature
 */
@property (assign) NSInteger signatureVerify;

/**
 *  the array of the mime parts to remove
 */
@property (strong) NSArray *mimetoRemove;

@end
