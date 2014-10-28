//
//  AMPCrypto.m
//  AMPCrypto
//
//  Created by Gio on 11/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPCrypto.h"
#import "AMPCryptoView.h"
#import "SSKeychain.h"
#import "NSString+AESCrypt.h"
#import "NSData+Base64.h"

@implementation AMPCrypto

NSString *myCryptoCtype    = @"Content-Type: myCrypto";
NSString *myCryptoBoundary = @"5347b703_327b23c6_6e65_crypto";
const NSString *amp_crypto_option = @"amp_crypto_option";

- (id)init
{
    self = [super init];
    if (self)
    {

    }
	return self;
}

- (NSString*) cryptoCtype
{
    return [NSString stringWithFormat:@"%@; %@\r\nContent-Transfer-Encoding: base64",myCryptoCtype,myCryptoBoundary];
}

- (BOOL) Load
{
    if(![super Load])
        return NO;
    self.password = [self loadPswd];
    self.mail     = [self savedMail];
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
        self.myView = [[AMPCryptoView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}

- (NSString*) nametext
{
    return @"AMPlugin Crypto SDK Sample";
}

- (NSString*) description
{
    return self.nametext;
}

- (NSString*) descriptiontext
{
    return @"This plugin show how to implement an encryption system";
}


- (NSString*) authortext
{
    return @"Airmail SDK Sample";
}

- (NSString*) supportlink
{
    return @"http://airmail.zendesk.com/entries/46555427-AMPlug-Translate-SDK-Sample";
}

- (NSImage*) icon
{
    return [NSImage imageNamed:@"iconx"];
}

#pragma mark - preferences
- (NSString*) savedMail
{
    return [self.preferences objectForKey:amp_crypto_option];
}

- (void) saveMail:(NSString*)mailIn
{
    self.mail = mailIn;
    [self.preferences removeObjectForKey:amp_crypto_option];
    [self.preferences setObject:mailIn forKey:amp_crypto_option];
    [self SavePreferences];
}


#pragma mark - actions
- (void) BtnClicked:(id)sender
{
    NSButton *btn = (NSButton*)sender;
    encrypt = NO;
    if(btn.state == NSOnState)
        encrypt = YES;
    NSImage *currentImage = btn.image;
    [btn setImage:btn.alternateImage];
    [btn setAlternateImage:currentImage];
    NSLog(@"BtnClicked %d",encrypt);
}

#pragma mark - pswd

- (NSString*) loadPswd
{
    return [SSKeychain passwordForService:@"AMPCrypto" account:@"MyAccount"];
}

- (BOOL) savePswd:(NSString*)pswd
{
    if(pswd)
    {
        if([SSKeychain setPassword:pswd forService:@"AMPCrypto" account:@"MyAccount"])
        {
            self.password = pswd;
            return YES;
        }
    }
    return NO;
}

#pragma mark - crypto_decrypto
//This is an encryption fast sample the methods used are not reliable
- (NSString*) Encrypt:(NSString*)rfc
{
    //Split Rfc to divide the body from the headers
    NSArray *arr        = [self ParseRfc:rfc];
    NSString *header    = arr[0];
    NSString *body      = arr[1];
    NSString *cType     = arr[2];
    
    header              = [header stringByReplacingOccurrencesOfString:cType withString:@""];         //remove old Content-Type
    header              = [header stringByAppendingFormat:@"%@",self.cryptoCtype];                    //add a new one Content-Type for test purpose
    body                = [cType stringByAppendingString:body];                                       //add the old Content-Type to the start of the body

    NSString* finalBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",myCryptoBoundary];
    
    NSData *data            = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encryptedBody = [[data AES256EncryptWithKey:self.password] base64Encoding];
    encryptedBody           = [encryptedBody stringByAppendingString:finalBoundary];
    NSString *ret           = [NSString stringWithFormat:@"%@\r\n\r\n%@",header,encryptedBody];
    return ret;
}

- (NSString*) Decrypt:(NSString*)rfc message:(AMPMessage*)message
{
    NSArray *arr        = [self ParseRfc:rfc];
    NSString *header    = arr[0];
    NSString *body      = arr[1];
    //NSString *cType     = arr[2];

    header                  = [header stringByReplacingOccurrencesOfString:self.cryptoCtype withString:@""];  //remove crypto Content-Type

    NSString* finalBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",myCryptoBoundary];
    body                    = [body stringByReplacingOccurrencesOfString:finalBoundary withString:@""];       //remove final boundary Content-Type
    
    NSData *decodedData     = [[NSData dataWithBase64EncodedString:body] AES256DecryptWithKey:self.password];
    NSString *decryptedBody = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSString *ret = [NSString stringWithFormat:@"%@%@",header,decryptedBody];
    return ret;
}

#pragma mark - calls
//Composer
//IS ALL TIME CALLED IN A BACKGORUND THREAD
- (NSNumber*) ampPileChangedRecipients:(AMPComposerInfo *)info
{
    NSLog(@"ampPileChangedRecipients");
    NSButton *composerBtn = [info composerBtn:self];
    if(!composerBtn)
        [self LogError:@"No Button for the plugin"];
    
    //recipients are changed we need to check if there is a mail that cparmits encryption
    NSLog(@"From: %@",info.localMessage.from.mail);
    NSMutableArray *arr = [NSMutableArray array];
    NSLog(@"To:");
    [arr addObjectsFromArray:[self GetMails:info.localMessage.to]];
    NSLog(@"Cc:");
    [arr addObjectsFromArray:[self GetMails:info.localMessage.cc]];
    NSLog(@"Bcc:");
    [arr addObjectsFromArray:[self GetMails:info.localMessage.bcc]];
    
    for(NSString *mail in arr)
    {
        if([mail.lowercaseString isEqualToString:self.mail])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [composerBtn setState:NSOnState];
                [composerBtn setEnabled:YES];
            });
            return @(YES);
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [composerBtn setState:NSOffState];
        [composerBtn setEnabled:NO];
        encrypt = NO;
    });
    return @(NO);
}

//GIVES AM A BUTTON IN THE COMPOSER WINDOW
- (NSArray*) ampPileComposerView:(AMPComposerInfo *)info
{
    //Return a new composer btn for new created the composer
    NSButton *composerBtn = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)]; //it will be rendered with the size 20,20
    [composerBtn setTitle:@"En"];
    [composerBtn setTarget:self];
    [composerBtn setAction:@selector(BtnClicked:)];
    [composerBtn setEnabled:NO];
    [composerBtn setState:NSOffState];
    [composerBtn setBordered:NO];
    [composerBtn setImage:[NSImage imageNamed:@"locked"]];
    [composerBtn setAlternateImage:[NSImage imageNamed:@"unlocked"]];
    [composerBtn setButtonType:NSToggleButton];
    [[composerBtn cell] setRepresentedObject:self];
    return composerBtn;
}

//USED BY AM TO CHECK IF THE RFC IS ENCRYPTED
- (NSNumber*)  ampPileIsEncrypted:(AMPMCOMessageParser*)parser
{
//    //Is encrypted?
//    if([rfc rangeOfString:myCryptoCtype].location != NSNotFound)
//        return @(YES);
    return @(NO);
}

//USED BY AM TO DECRYPT BEFORE RENDERING
- (NSData*) ampStackDecrypt:(AMPMessage*)message
{
    return nil; //[self Decrypt:message];
}

//USED BY AM TO CHANGETHE RFC BEFORE SENDING
- (AMPSendResult*) ampStackSendRfc:(NSString*)rfc composer:(AMPComposerInfo*)info
{
    if(encrypt)
        return [self Encrypt:rfc];
    return rfc;
}


#pragma mark - utilities
-(NSArray*) GetMails:(NSArray*)arr
{
    NSMutableArray *ret = [NSMutableArray array];
    for(id obj in arr)
    {
        if([obj isKindOfClass:[AMPAddress class]])
        {
            AMPAddress *addr = (AMPAddress*)obj;
            if(addr.mail)
            {
                NSLog(@"%@",addr.mail);
                [ret addObject:addr.mail];
            }
        }
        else if([obj isKindOfClass:[AMPGroup class]])
        {
            AMPGroup *group = (AMPGroup*)obj;
            for(AMPAddress *addr in group.addresses)
            {
                if(addr.mail)
                {
                    NSLog(@"Group %@ %@",group.name, addr.mail);
                    [ret addObject:addr.mail];
                }
            }
        }
    }
    return ret;
}

-(NSArray*) ParseRfc:(NSString*)rfc
{
    NSMutableArray *ret = [NSMutableArray array];
    //Split Rfc to divide the body from the headers
    NSScanner *scanner = [NSScanner scannerWithString:rfc];
    NSString *header = nil;
    [scanner scanUpToString:@"\r\n\r\n" intoString:&header]; //split body from headers
    if(!header)
        return nil;
    [ret addObject:header];
    
    NSString *body =  [rfc substringFromIndex:scanner.scanLocation];
    if(!body)
        return nil;
    [ret addObject:body];

    //Search for Content-Type
    //Content-Type: multipart/alternative; boundary="5347b703_327b23c6_6e65"
    NSString *contentType = nil;
    NSScanner *scanner2   = [NSScanner scannerWithString:header];
    [scanner2 scanUpToString:@"\r\nContent-Type:" intoString:nil];
    [scanner2 scanUpToString:@"\r\n" intoString:&contentType];       //scan till the boundary
    if(!contentType)
        return nil;
    [ret addObject:contentType];
    return ret;
}


@end
