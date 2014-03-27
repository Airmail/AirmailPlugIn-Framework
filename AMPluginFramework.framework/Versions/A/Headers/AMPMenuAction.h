//
//  AMPMenuAction.h
//  AMPluginFramework
//
//  Created by Joe  on 18/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPMenuAction : NSObject
{
    
}

/**
 *  The objec passed by the plugin in the represented object menu item
 */
@property (strong) NSObject *representedObject;

/**
 *  An array og AMPMessages involved in the action
 */
@property (strong) NSArray  *messages;

@end
