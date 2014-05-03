//
//  NSScanner+SmimeUtility.h
//  AMPSmime
//
//  Created by Gio on 15/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSScanner (Utility)

- (unichar) currentCharacter;

- (unichar) previousCharacter;

- (BOOL) scanNext;

- (BOOL) scanNext:(NSUInteger)n;

- (BOOL) scanNext:(NSUInteger)next inString:(NSString**)string;

- (BOOL) nextCharacter:(unichar*)charx;

- (BOOL) nextString:(NSString*)string;

- (BOOL) nextCharacters:(NSUInteger)n inString:(NSString**)string;

- (BOOL) scanUpAndScan:(NSString*)str intoString:(NSString**)string;
@end
