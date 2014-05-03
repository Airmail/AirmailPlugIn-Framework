//
//  NSData+AMPBase64.h
//  AMPluginFramework
//
//  Created by Giovanni Simonicca on 17/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AMPBase64)

//void *NewBase64Decode(
//                      const char *inputBuffer,
//                      size_t length,
//                      size_t *outputLength);
//
//char *NewBase64Encode(
//                      const void *inputBuffer,
//                      size_t length,
//                      bool separateLines,
//                      size_t *outputLength);

+ (NSData *)ampDataFromBase64String:(NSString *)aString;
- (NSString *)ampBase64EncodedString;


@end
