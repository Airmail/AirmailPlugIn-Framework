//
//  AMPMCOAbstractMultipart.h
//  AMPluginFramework
//
//  Created by Gio on 13/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import "AMPMCOAbstractPart.h"

@interface AMPMCOAbstractMultipart : AMPMCOAbstractPart

/** Returns the subparts of that multipart.*/
-(NSArray*) /* MCOAbstractPart */ parts;


@end
