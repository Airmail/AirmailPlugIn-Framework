//
//  AMPCssComposer.m
//  CssComposer
//
//  Created by Joe on 16/11/13.
//  Copyright (c) 2013 Joe. All rights reserved.
//

#import "AMPCustomTemplate.h"
#import "AMPCssComposerView.h"
const NSString *ampcss_composer_css_option = @"ampcss_composer_css_option";
@implementation AMPCustomTemplate


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
    NSString *path = [self.preferences objectForKey:ampcss_composer_css_option];
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
    return [(AMPCssComposerView*)self.myView ReloadView];
}

- (AMPView*) pluginview
{
    if(!self.myView)
        self.myView = [[AMPCssComposerView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}

- (NSString*) nametext
{
    return @"Composer Template SDK";
}

- (NSString*) description
{
    return self.nametext;
}

- (NSString*) descriptiontext
{
    return @"This plugin is a Composert Template sample to show how to customize your message,";
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
-(NSMenuItem*) ampMenuComposerItem:(AMPComposerInfo *)info
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Change Style", @"Change Style") action:nil keyEquivalent:@""];
    [item setState:NSOffState];
    
    NSMenu *menu = [self stylesMenuComposerButton];
    [item setSubmenu:menu];
    return item;
}

- (NSString*)  ampStackComposerRenderHtmlFromHtml:(NSString *)html composerInfo:(AMPComposerInfo *)info
{
    if(self.cssString.length == 0)
        return html;
    
    NSString *htmlRet = [NSString stringWithFormat:@"<style id=\"%@\">%@</style>%@",ampcss_composer_css_option,self.cssString,html];
    return htmlRet;
}

#pragma mark - manage css
-(NSString*) savedPath
{
    return [self.preferences objectForKey:ampcss_composer_css_option];
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

- (NSMenu*) stylesMenu
{
    NSMenu *menu = [NSMenu new];
    NSArray *csss = [self.cssList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [a caseInsensitiveCompare:b];
    }];
    
    NSMenuItem *itemRender = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"None", @"None") action:nil keyEquivalent:@""];
    [itemRender setRepresentedObject:@""];
    [itemRender setAction:@selector(changeCss:)];
    [itemRender setTarget:self];
    [menu addItem:itemRender];
    
    [csss enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL *stop) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:path.lastPathComponent.stringByDeletingPathExtension action:nil keyEquivalent:@""];
        [item setRepresentedObject:path];
        [item setAction:@selector(changeCss:)];
        [item setTarget:self];
        [menu addItem:item];
    }];
    return menu;
    
}

- (NSMenu*) stylesMenuComposerButton
{
    NSMenu *menu = [self stylesMenu];
    [menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
        
        if([item.representedObject isEqualToString:self.cssStringComposer])
            [item setState:NSOnState];
        
        [item setAction:@selector(changeCssComposer:)];
        [item setTarget:self];


    }];
    return menu;
}

- (void) changeCss:(NSMenuItem*)item
{
    [self changeCssString:item.representedObject];
}

- (void) changeCssString:(NSString*)str
{
    if(str.length == 0)
    {
        [self.preferences removeObjectForKey:ampcss_composer_css_option];
        self.cssString = @"";
    }
    else
    {
        [self.preferences removeObjectForKey:ampcss_composer_css_option];
        [self.preferences setObject:str forKey:ampcss_composer_css_option];
        self.cssString = [self LoadCssStringForPath:str];
    }
    [self SavePreferences];
}

//From composer
- (void) changeCssComposer:(NSMenuItem*)item
{
    //NSLog(@"changeCssComposer %@",str);
    if([item.representedObject isKindOfClass:[AMPComposerInfo class]])
    {
        AMPComposerInfo *info = item.representedObject;
        if([info.representedObject isKindOfClass:[NSString class]])
        {
            NSString *path = (NSString*)info.representedObject;
            
            self.cssStringComposer   = [self LoadCssStringForPath:path];
            if(info.webView)
            {
                DOMDocument *domDoc  = [[info.webView mainFrame] DOMDocument];

                NSString *idx                   = [NSString stringWithFormat:@"%@",ampcss_composer_css_option];
                DOMHTMLStyleElement *cssNode    = (DOMHTMLStyleElement*)[domDoc createElement:@"style"];
                [cssNode setInnerHTML:self.cssStringComposer];
                [cssNode setIdName:idx];

                DOMElement *el = [domDoc getElementById:idx];
                if(el && el.parentNode)
                {
                    [el.parentNode replaceChild:cssNode oldChild:el];
                }
                else
                {
                    DOMNodeList *list = [domDoc getElementsByTagName:@"head"];;
                    if(list.length > 0)
                    {
                        DOMHTMLHeadElement *head = (DOMHTMLHeadElement*)[list item:0];
                        [head appendChild:cssNode];
                    }
                }
            }
        }
    }
}


@end
