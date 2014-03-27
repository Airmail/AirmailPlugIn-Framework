//
//  AirmailCss.m
//  AirmailCss
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import "AirmailCss.h"
#import "AMPCssView.h"

@implementation AirmailCss

- (id)init
{
    self = [super init];
    if (self)
    {
        

	}
	return self;
}


- (BOOL) Load
{
    if([super Load])
    {

        NSError *err = nil;
        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.suggestedpath error:&err];
        if(err)
        {
            NSLog(@"Load directory %@ %@", self,self.suggestedpath);
            return NO;
        }
        
        self.cssList = [NSMutableArray array];
        if(arr && arr.count > 0)
        {
            for(NSString *s in arr)
            {
                if([s hasPrefix:@"."] == NO)
                {
                    NSString *sx = [self.suggestedpath stringByAppendingPathComponent:s];
                    [self.cssList addObject:sx];
                }
            }
        }
    }
    return NO;
}

- (void) Enable
{
    
}

- (void) Disable
{
    
}

- (void) Invalid
{
    
}

- (AMPView*) pluginview
{
    if(!self.myView)
        self.myView = [[AMPCssView alloc] initWithFrame:NSZeroRect];
    return self.myView;
}

- (NSString*) nametext
{
    return @"Airmail Css";
}

- (NSString*) description
{
    return @"Airmail Css Plugin";
}

- (NSString*) descriptiontext
{
    return @"Airmail Css Description";
}

- (NSImage*) icon
{
    return [NSImage imageNamed:@"iconx"];
}




@end
