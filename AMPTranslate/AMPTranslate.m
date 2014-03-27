//
//  AMPTranslate.m
//  AMPTranslate
//
//  Created by Joe on 19/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import "AMPTranslate.h"
#import "AMPTranslateView.h"
#import "NSString+HTML.h"

const NSString *amp_translate_option = @"amp_translate_option";


@implementation AMPTranslate


- (id)init
{
    self = [super init];
    if (self)
    {
        self.lang = @"";
	}
	return self;
}


- (BOOL) Load
{
    if(![super Load])
        return NO;
    self.lang = self.savedLang;
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
    return [self.myView ReloadView];
}

- (AMPView*) pluginview
{
    if(!self.myView)
        self.myView = [[AMPTranslateView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}

- (NSString*) nametext
{
    return @"Airmail Translate SDK";
}

- (NSString*) description
{
    return self.nametext;
}

- (NSString*) descriptiontext
{
    return @"Airmail Translate Description, Airmail Translate Description";
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

- (NSMenu*) langMenu
{
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *itemRender = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Auto", @"Auto") action:@selector(changeLang:) keyEquivalent:@""];
    [itemRender setRepresentedObject:@""];
    [itemRender setTarget:self];
    [menu addItem:itemRender];
    
    
    NSMenuItem *itemSupport1 = [[NSMenuItem alloc] initWithTitle:@"English"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport1 setRepresentedObject:@"en"];
    [itemSupport1 setTarget:self];
    [menu addItem:itemSupport1];
    
    NSMenuItem *itemSupport4 = [[NSMenuItem alloc] initWithTitle:@"Français" action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport4 setRepresentedObject:@"fr_FR"];
    [itemSupport4 setTarget:self];
    [menu addItem:itemSupport4];
    
    NSMenuItem *itemSupport2 = [[NSMenuItem alloc] initWithTitle:@"Deutsch" action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport2 setRepresentedObject:@"de"];
    [itemSupport2 setTarget:self];
    [menu addItem:itemSupport2];
    
    NSMenuItem *itemSupport3 = [[NSMenuItem alloc] initWithTitle:@"Español" action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport3 setRepresentedObject:@"es"];
    [itemSupport3 setTarget:self];
    [menu addItem:itemSupport3];
    
    NSMenuItem *itemSupport5 = [[NSMenuItem alloc] initWithTitle:@"Italiano"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport5 setRepresentedObject:@"it"];
    [itemSupport5 setTarget:self];
    [menu addItem:itemSupport5];
    
    NSMenuItem *itemSupport51 = [[NSMenuItem alloc] initWithTitle:@"Hebrew"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport51 setRepresentedObject:@"he"];
    [itemSupport51 setTarget:self];
    [menu addItem:itemSupport51];
    
    NSMenuItem *itemSupport52 = [[NSMenuItem alloc] initWithTitle:@"Greek"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport52 setRepresentedObject:@"el"];
    [itemSupport52 setTarget:self];
    [menu addItem:itemSupport52];

    NSMenuItem *itemSupport8 = [[NSMenuItem alloc] initWithTitle:@"日本語"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport8 setTarget:self];
    [itemSupport8 setRepresentedObject:@"ja"];
    [menu addItem:itemSupport8];
    
    NSMenuItem *itemSupport85 = [[NSMenuItem alloc] initWithTitle:@"中文简体"  action:@selector(changeLang:) keyEquivalent:@""];
    [itemSupport85 setTarget:self];
    [itemSupport85 setRepresentedObject:@"zh-Hans"];
    [menu addItem:itemSupport85];
    
    return menu;
    
}

- (NSString *)urlencode:(NSString*)str
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


- (NSString*) savedLang
{
    return [self.preferences objectForKey:amp_translate_option];
}

- (void) changeLang:(NSMenuItem*)item
{
    NSString *str = item.representedObject;
    if(str.length == 0)
    {
        [self.preferences removeObjectForKey:amp_translate_option];
        self.lang = @"";
    }
    else
    {
        [self.preferences removeObjectForKey:amp_translate_option];
        [self.preferences setObject:str forKey:amp_translate_option];
        self.lang = str;
    }
    [self SavePreferences];
}

- (NSMenuItem*) ampMenuActionItem:(NSArray*)messages
{
    NSMenuItem *itemNotes = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"Translate") action:nil keyEquivalent:@""];
    [itemNotes setRepresentedObject:@""];
    [itemNotes setAction:@selector(translateAction:)];
    [itemNotes setTarget:self];
    return itemNotes;
}

- (NSNumber*) ampRuleActionItem:(AMPMessage*)message
{
    NSString *s = @"http://translate.google.com/?sl=auto#auto/";
    if(self.lang.length > 0)
        s = [s stringByAppendingFormat:@"%@/",self.lang];
    else
        s = [s stringByAppendingFormat:@"destination_language/"];

    NSString *sbody = [s stringByAppendingFormat:@"%@",[self urlencode:message.plainBody]];
    NSURL *url = [NSURL URLWithString:sbody];
    if(url)
        [[NSWorkspace sharedWorkspace] openURL:url];
    return @(YES);
}

-(void) translateAction:(NSMenuItem*)item
{
    NSString *s = @"http://translate.google.com/?sl=auto#auto/";
    if(self.lang.length > 0)
        s = [s stringByAppendingFormat:@"%@/",self.lang];
    else
        s = [s stringByAppendingFormat:@"destination_language/"];

    AMPMenuAction *action = item.representedObject;
    if(action && [action isKindOfClass:[AMPMenuAction class]])
    {
        //http://translate.google.com/#origin_language_or_auto|destination_language|encoded_phrase
        //http://translate.google.com/translate?js=n&sl=auto&tl=destination_language&text=encoded_phrase
        //http://translate.google.com/?sl=auto#auto/it/gfrcdx%0Agrfcdsx%0Ab3gfcd%0A%0Ab3gvrwcda

        for(AMPMessage *message in action.messages)
        {
            NSString *sbody = [s stringByAppendingFormat:@"%@",[self urlencode:[message.plainBody stringByConvertingHTMLToPlainText]]];
            NSURL *url = [NSURL URLWithString:sbody];
            if(url)
                [[NSWorkspace sharedWorkspace] openURL:url];
        }
    }
    
}





@end
