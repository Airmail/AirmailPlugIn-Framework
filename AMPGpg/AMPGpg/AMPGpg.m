//
//  AMPGpg.m
//  AMPGpg
//
//  Created by Gio on 16/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPGpg.h"
#import "AMPGpgView.h"
#import "AMPGpgEncryption.h"
#import "AMPGpgButton.h"
#import "AMPGpgBodyView.h"
//#import "Libmacgpg.h"
#import <Libmacgpg/Libmacgpg.h>

enum amp_composer_gpg_btn_type {
    AMP_GPG_COMPOSER_TYPE_BTN_ENCRYPT = 123456,
    AMP_GPG_COMPOSER_TYPE_BTN_SIGN    = 234567,
};

NSString * const AMPGpgRemeberChoice = @"AMPGpgRemeberChoices";

@interface  AMPGpg()
{
    
}
@property (strong) AMPGpgEncryption *encryption;
@property (strong) NSImage *imSignOn,*imSignOff,*imEncryptOn,*imEncryptOff,*imSignedOK,*imSignedBad,*imLockedKPI,*imUnLockedKPI,*imIcon;
@property (strong) NSMutableDictionary *encryptedMessages, *signedMessages,*composerViews;

@end

@implementation AMPGpg
@synthesize rememberChoice;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.encryptedMessages  = [NSMutableDictionary dictionary];
        self.signedMessages     = [NSMutableDictionary dictionary];

        self.encryption = [AMPGpgEncryption new];
    }
	return self;
}

- (BOOL) Load
{
    if(![super Load])
        return NO;
    
    self.imIcon         = [self loadImage:@"pluginsGPG.psd"];
    self.imSignOn       = [self loadImage:@"g_active.psd"];
    self.imSignOff      = [self loadImage:@"g_inactive.psd"];
    self.imEncryptOn    = [self loadImage:@"g_locked.psd"];
    self.imEncryptOff   = [self loadImage:@"g_unlocked.psd"];
    self.imSignedOK     = [self loadImage:@"gpg_active.psd"];
    self.imSignedBad    = [self loadImage:@"gpg_bad.psd"];
    self.imLockedKPI    = [self loadImage:@"gpg_locked.psd"];
    self.imUnLockedKPI  = [self loadImage:@"gpg_unlocked.psd"];
    
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
        self.myView = [[AMPGpgView alloc] initWithFrame:NSZeroRect plugin:self];
    return self.myView;
}

- (NSString*) nametext
{
    return @"GPG BETA";
}

- (NSString*) description
{
    return self.nametext;
}

- (NSString*) descriptiontext
{
    return @"This plug-in implements the PGP/GPG email security standard for encryption and signing.";
}

- (NSString*) authortext
{
    return @"Airmail GPG Beta";
}

- (NSString*) supportlink
{
    return @"http://airmailapp.com/gpg";
}

- (NSImage*) icon
{
    return self.imIcon;
}

#pragma mark - calls
//GIVES AM A BUTTON IN THE COMPOSER WINDOW
- (NSArray*) ampPileComposerView:(AMPComposerInfo *)info
{
    //Return a new composer btn for new created the composer
    NSView *v = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 44, 20)];
    
    AMPGpgButton *lockBtn = [[AMPGpgButton alloc] initWithFrame:NSMakeRect(0, 0, 22, 20)
                                                          image:self.imEncryptOn
                                                            alt:self.imEncryptOff
                                                            tag:AMP_GPG_COMPOSER_TYPE_BTN_ENCRYPT
                                                 rememberChoice:self.rememberChoice];
    [lockBtn setToolTip:NSLocalizedString(@"PGP Encrypt/Decrypt",@"PGP Sign/Unsign")];
    [v addSubview:lockBtn];
    
    AMPGpgButton *signBtn = [[AMPGpgButton alloc] initWithFrame:NSMakeRect(22, 0, 22, 20)
                                                          image:self.imSignOn
                                                            alt:self.imSignOff
                                                            tag:AMP_GPG_COMPOSER_TYPE_BTN_SIGN
                                                 rememberChoice:self.rememberChoice];
    [signBtn setToolTip:NSLocalizedString(@"PGP Sign/Unsign",@"PGP Sign/Unsign")];
    [v addSubview:signBtn];
    return @[v];
}


//Composer
//IS ALL TIME CALLED IN A BACKGROUND THREAD
- (NSNumber*) ampPileChangedRecipients:(AMPComposerInfo *)info
{
    AMPGpgButton *encryptBtn = [self btnForTag:AMP_GPG_COMPOSER_TYPE_BTN_ENCRYPT info:info];
    AMPGpgButton *signBtn    = [self btnForTag:AMP_GPG_COMPOSER_TYPE_BTN_SIGN    info:info];
    NSInteger canSign        = [self.encryption CheckSender:info];
    NSInteger canEncrypt     = [self.encryption CheckRecipients:info];
  
    //Some unicors will die for such nested if... structure :)
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if(canSign)
        {
            [signBtn ManageState:YES];
            if(canEncrypt)
                [encryptBtn ManageState:YES];
            else
                [encryptBtn ManageState:NO];
        }
        else
        {
            [encryptBtn ManageState:NO];
            [signBtn ManageState:NO];
        }
    });
    return @(1);
}


//USED BY AM TO CHECK IF THE RFC IS ENCRYPTED
- (NSNumber*)  ampPileIsEncrypted:(AMPMCOMessageParser*)parser
{
    return @([self.encryption isEncrypted:parser]);
}

//USED BY AM TO CHECK IF THE RFC IS Signed
- (AMPSignatureVerify*) ampPileVerifySignature:(AMPMessage*)message
{
    AMPSignatureVerify *sv = nil;
    @try
    {
        sv = [self.encryption VerifySignature:message];
        if(sv)
            [self.signedMessages setObject:@(sv.signatureVerify) forKey:message.idx];
    }
    @catch (NSException *exception) {
        [self LogError:exception.reason];
    }
    return sv;
}

//USED BY AM TO DECRYPT BEFORE RENDERING
- (NSData*)  ampStackDecrypt:(AMPMessage*)message
{
    NSData *data = nil;
    @try{
        data = [self.encryption Decrypt:message];
        if(data)
            [self.encryptedMessages setObject:@(YES) forKey:message.idx];
    }
    @catch (NSException *exception) {
        [self LogError:exception.reason];
        [self.encryptedMessages setObject:@(NO) forKey:message.idx];
    }
    @finally {
    }
    return data;
}

//USED BY AM TO CHANGE THE RFC BEFORE SENDING
- (AMPSendResult*) ampStackSendRfc:(NSString*)rfc composer:(AMPComposerInfo*)info
{
    AMPSendResult *sr   = [AMPSendResult new];
    sr.result           = AMP_SEND_RESULT_NONE;

    AMPGpgButton *encryptBtn = [self btnForTag:AMP_GPG_COMPOSER_TYPE_BTN_ENCRYPT info:info];
    AMPGpgButton *signBtn    = [self btnForTag:AMP_GPG_COMPOSER_TYPE_BTN_SIGN info:info];
    if(encryptBtn.isActive || signBtn.isActive)
    {
        @try{
            sr.rfc      = [self.encryption Envelope:rfc info:info enc:encryptBtn.isActive sign:signBtn.isActive];
            sr.result   = AMP_SEND_RESULT_SUCCESS;
        }
        @catch (NSException *exception) {
            [self LogError:exception.reason];
            sr.err      = exception.reason;
            sr.result   = AMP_SEND_RESULT_FAIL;
        }
    }
    return sr;
}

//USED BY AM TO RENDER IN THE BODYVIEW
- (NSArray*) ampPileMessageView:(AMPMessage*)message
{
    NSMutableArray *ret = [NSMutableArray array];
    
    NSNumber *enc = [self.encryptedMessages objectForKey:message.idx];
    if(enc.integerValue > 0)
    {
        NSImageView *imvEncrypted = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [imvEncrypted setImageAlignment:NSImageAlignTopLeft];
        [imvEncrypted setImageScaling:NSImageScaleProportionallyUpOrDown];
        if(enc.boolValue)
        {
            [imvEncrypted setImage:self.imUnLockedKPI];
            [imvEncrypted setToolTip:NSLocalizedString(@"Decrypted",@"Decrypted")];

        }
        else
        {
            [imvEncrypted setImage:self.imLockedKPI];
            [imvEncrypted setToolTip:NSLocalizedString(@"Failed to Decrypt",@"Failed to Decrypt")];

        }
        [ret addObject:imvEncrypted];
        [self.encryptedMessages removeObjectForKey:message.idx];
    }
    
    NSNumber *sign = [self.signedMessages objectForKey:message.idx];
    if(sign.integerValue > 0)
    {
        NSImageView *imvSign = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        if(sign.integerValue == AMP_SIGNED_SUCCESS)
        {
            [imvSign setImage:self.imSignedOK];
            [imvSign setToolTip:NSLocalizedString(@"Verified",@"Verified")];
            
        }
        else if(sign.integerValue == AMP_SIGNED_FAILS)
        {
            [imvSign setImage:self.imSignedBad];
            [imvSign setToolTip:NSLocalizedString(@"Not Verified",@"Not Verified")];
            
        }
        [ret addObject:imvSign];
        [self.signedMessages    removeObjectForKey:message.idx];
    }
        
    return ret;
}

#pragma mark - utilities
-(AMPGpgButton*) btnForTag:(NSInteger)tag info:(AMPComposerInfo*)info
{
    NSArray *composerBtns = [info composerBtn:self];
    if(!composerBtns || composerBtns.count == 0)
    {
        [self LogError:@"No Button for the plugin"];
        return nil;
    }
    
    NSView *v = composerBtns[0];
    for(AMPGpgButton *btn in v.subviews)
    {
        if(btn.tag == tag)
            return btn;
    }
    return nil;
}


@end
