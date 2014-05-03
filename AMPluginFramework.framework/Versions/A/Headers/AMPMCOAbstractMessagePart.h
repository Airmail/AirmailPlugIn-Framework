//
//  AMPMCOAbstractMessagePart.h
//  AMPluginFramework
//
//  Created by Gio on 13/04/14.
//  Copyright (c) 2014 Bloop. All rights reserved.
//

#import "AMPMCOAbstractPart.h"
@class AMPMCOMessageHeader;

@interface AMPMCOAbstractMessagePart : AMPMCOAbstractPart

// Returns the header of the embedded message.
-(AMPMCOMessageHeader *) header;

// Returns the main part of the embedded message. It can be MCOAbstractPart, MCOAbstractMultipart
// or a MCOAbstractMessagePart.
-(AMPMCOAbstractPart *) mainPart;


@end
