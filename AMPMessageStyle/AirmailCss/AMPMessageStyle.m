//
//  AirmailCss.m
//  AirmailCss
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import "AMPMessageStyle.h"
#import "AMPMessageStyleView.h"

const NSString *ampcss_render_css_option   = @"ampcss_render_css_option";
@implementation AMPMessageStyle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.cssString = @"";
	}
	return self;
}


- (BOOL) Load
{
    if(![super Load])
        return NO;
    
    self.cssList = [NSMutableArray array];

    //Load Bundle
    NSMutableArray *allpaths = [NSMutableArray array];
    
    NSArray *bundlesPath     = [self bundlepathContents];
    if(!bundlesPath)
        return NO;
    [allpaths addObjectsFromArray:bundlesPath];
    
    NSArray *dirPaths       = [self suggestedpathContents];
    if(!dirPaths)
        return NO;
    [allpaths addObjectsFromArray:dirPaths];
    
    for(NSString *path in allpaths)
    {
        if([path.pathExtension isEqualToString:@"css"])
            [self.cssList addObject:path];
    }
    
    //Load Preference
    NSString *path = [self.preferences objectForKey:ampcss_render_css_option];
    if(path && [path isKindOfClass:[NSString class]])
        self.cssString = [self LoadCssStringForPath:path];
    
    [self Reload];
    return YES;
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

- (void) Reload
{
    [self.myView ReloadView];
}

- (AMPView*) pluginview
{
    if(!self.myView)
        self.myView = [[AMPMessageStyleView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}

- (NSString*) nametext
{
    return @"Message Style SDK";
}

- (NSString*) description
{
    return self.nametext;
}

- (NSString*) descriptiontext
{
    return @"With this plugin you can override the rendering css of the messages.";
}

- (NSString*) authortext
{
    return @"Airmail SDK Sample";
}

- (NSString*) supportlink
{
    return @"http://adv.bloop.info/airmail/sdk.php";
}

- (NSImage*) icon
{
    return [NSImage imageNamed:@"iconx"];
}

#pragma mark - AM called methods
- (NSString*) ampStackMessageRenderFromHtml:(NSString*)html message:(AMPMessage*)message
{
    if(self.cssString.length == 0 || !message)
        return html;
    
    NSString *htmlRet = [NSString stringWithFormat:@"<style>%@</style>%@",self.cssString,html];
    return htmlRet;
}

#pragma mark - manage css
-(NSString*) savedPath
{
    return [self.preferences objectForKey:ampcss_render_css_option];
}

- (NSString*) LoadCssStringForPath:(NSString*)path
{
    NSError *err  = nil;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if(err)
    {
        str = @"";
        [self LogError:[NSString stringWithFormat:@"Cannot load css %@",path]];
    }
    return str;
}

- (void) changeCss:(NSString*)str
{
    if(str.length == 0)
    {
        [self.preferences removeObjectForKey:ampcss_render_css_option];
        self.cssString = @"";
    }
    else
    {
        [self.preferences removeObjectForKey:ampcss_render_css_option];
        [self.preferences setObject:str forKey:ampcss_render_css_option];
        self.cssString = [self LoadCssStringForPath:str];
    }
    [self SavePreferences];
    
}


@end
