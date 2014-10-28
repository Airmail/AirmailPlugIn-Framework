//
//  AMPGpgEncryption.h
//  AMPGpg
//
//  Created by Giovanni Simonicca on 16/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMPMessage;
@class AMPMCOMessageParser;
@class AMPComposerInfo;
@class AMPCertManager;
@class AMPComposerInfo;
@class AMPSignatureVerify;

@interface AMPGpgEncryption : NSObject

- (NSInteger) isEncrypted:(AMPMCOMessageParser*)parser;

- (NSInteger) CheckSender:(AMPComposerInfo *)info;

- (NSInteger) CheckRecipients:(AMPComposerInfo *)info;

- (NSString*) Envelope:(NSString*)rfc info:(AMPComposerInfo*)info enc:(BOOL)enc sign:(BOOL)sign;

- (NSData*)   Decrypt:(AMPMessage*)message;

- (AMPSignatureVerify*) VerifySignature:(AMPMessage*)message;


@end
