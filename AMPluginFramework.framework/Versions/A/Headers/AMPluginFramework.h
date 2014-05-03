//
//  AMPluginFramework.h
//  AMPluginFramework
//
//  Created by Joe  on 12/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMPlugin.h"
//Objects
#import "AMPObject.h"
#import "AMPAccount.h"
#import "AMPAddress.h"
#import "AMPGroup.h"
#import "AMPMessage.h"
#import "AMPProvider.h"
#import "AMPAttachment.h"
#import "AMPAlias.h"
#import "AMPSignature.h"
#import "AMPFolder.h"

//Utility
#import "AMPCallBack.h"
#import "AMPUidFlag.h"
#import "AMPComposerInfo.h"
#import "AMPMenuAction.h"
#import "AMPView.h"
#import "AMPSignatureVerify.h"
#import "AMPSendResult.h"

//Mailcore
#import "AMPMCOAddress.h"
#import "AMPMCOAttachment.h"
#import "AMPMCOAbstractPart.h"
#import "AMPMCOMultiPart.h"
#import "AMPMCOAbstractMultiPart.h"
#import "AMPMCOMessagePart.h"
#import "AMPMCOAbstractMessagePart.h"
#import "AMPMCOMessageHeader.h"
#import "AMPMCOAbstractMessage.h"
#import "AMPMCOMessageParser.h"
#import "AMPMCOMessageBuilder.h"

//Categories
#import "NSScanner+Utility.h"
#import "NSData+AMPBase64.h"

enum amp_message_localflags {
    
    AMP_FLAG1 = 1,
    AMP_FLAG2 = 2,
    AMP_FLAG3 = 3,
    AMP_FLAG4 = 4,
    AMP_FLAG5 = 5,
    AMP_FLAG6 = 6,
    AMP_FLAG7 = 7,
};

enum amp_provderType {
    
    AMP_PROVIDER_GMAIL   = 0,
    AMP_PROVIDER_ICLOUD  = 1,
    AMP_PROVIDER_YAHOO   = 2,
    AMP_PROVIDER_AOL     = 3,
    AMP_PROVIDER_YAHOOJP = 5,
    AMP_PROVIDER_OUTLOOK = 6,
    
    //other imap here
    AMP_PROVIDER_GENERICIMAP         = 10,
    
    AMP_PROVIDER_GENERICPOP3         = 100,
    //all pop here
    AMP_PROVIDER_HOTMAIL             = 101,
    
    AMP_PROVIDER_GENERICEXCHANGE     = 200,
    
    AMP_PROVIDER_GENERICLOCAL        = 300
};

enum amp_encryption_type {
    AMP_ENCRYPTED_NONE      = 0,
    AMP_ENCRYPTED_SIGNED    = 1 << 0,
    AMP_ENCRYPTED           = 1 << 1,
};

enum amp_send_result {
    AMP_SEND_RESULT_NONE    = 0,
    AMP_SEND_RESULT_FAIL    = 1 << 0,
    AMP_SEND_RESULT_SUCCESS = 1 << 1,
};

enum amp_verify_signature {
    AMP_SIGNED_NONE       = 0,
    AMP_SIGNED_FAILS      = 1 << 0,
    AMP_SIGNED_SUCCESS    = 1 << 1,
};

enum amp_composertype {
    AMP_COMPOSER_RICHTEXT,
    AMP_COMPOSER_PLAINTEXT,
    AMP_COMPOSER_MARKDOWNTEXT
};

enum amp_mailcomposertype {
    AMP_COMPOSER_NEW        = 0,
    AMP_COMPOSER_REPLY      = 1,
    AMP_COMPOSER_REPLYALL   = 2,
    AMP_COMPOSER_FORWARD    = 3,
    AMP_COMPOSER_EDITOR     = 4,
    AMP_COMPOSER_NEWFORFILE = 5,
    AMP_COMPOSER_MAILTO     = 6,
    AMP_COMPOSER_QUICKREPLY = 7,
    AMP_COMPOSER_SENDAGAIN  = 8,
    AMP_COMPOSER_SCRIPT     = 9,
    AMP_COMPOSER_REDIRECT   = 10,
    
};

enum amp_foldertype {
    
    AMP_STANDARDFOLDER  = 0,
    AMP_INBOX           = 1,
    AMP_STARRED         = 2,
    AMP_IMPORTANT       = 3,
    AMP_DRAFTS          = 4,
    AMP_SENTMAIL        = 5,
    AMP_ALLMAIL         = 6,
    AMP_TRASH           = 7,
    AMP_SPAM            = 8,
    AMP_ARCHIVE         = 9,
    AMP_NOTES           = 10,
    AMP_TODO            = 11,
    AMP_MEMO            = 12,
    AMP_DONE            = 13,
    AMP_AIRMAIL         = 14,
    
    AMP_LOCAL           = 51,
    AMP_SENDING         = 52,
    AMP_UNREAD          = 53,
    AMP_TODAY           = 54,
    //YESTERDAY       = 54,
    AMP_SEARCH          = 55,
    AMP_ALLVIRTUAL      = 56,
    AMP_LOCALSENT       = 57,
    
    AMP_MUTE            = 101
    
};

enum amp_flags {
    AMP_FlagNone          = 0,
    AMP_FlagAnswered      = 1 << 0,
    AMP_FlagSeen          = 1 << 1,
    AMP_FlagFlagged       = 1 << 2,
    AMP_FlagDeleted       = 1 << 3,
    AMP_FlagDraft         = 1 << 4,
    AMP_FlagMDNSent       = 1 << 5,
    AMP_FlagForwarded     = 1 << 6,
    AMP_FlagSubmitPending = 1 << 7,
    AMP_FlagSubmitted     = 1 << 8,
};


extern NSString * const amp_enabledDisabledAccount;

@interface AMPluginFramework : NSObject

@end
