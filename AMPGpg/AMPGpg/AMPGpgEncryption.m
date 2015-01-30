//
//  AMPGpgEncryption.m
//  AMPGpg
//
//  Created by Giovanni Simonicca on 16/04/14.
//  Copyright (c) 2014 bloop. All rights reserved.
//

#import "AMPGpgEncryption.h"
#import <AMPluginFramework/AMPluginFramework.h>
#import <Libmacgpg/Libmacgpg.h>
//#import "Libmacgpg.h"

NSString * const AMPGpgEncryptionException = @"AMPGpgEncryption_Exception";

@implementation AMPGpgEncryption

#pragma mark - Calls
- (NSInteger) isEncrypted:(AMPMCOMessageParser*)parser
{
    NSInteger flag = AMP_ENCRYPTED_NONE;
    if(!parser)
        return flag;
    
    for(AMPMCOAbstractPart *part in  [parser.mainPart AllParts])
    {
        if(part.mimeType)
        {
            //NSLog(@"%@",part.mimeType);
            if([part.mimeType isEqualToString:@"application/pgp-signature"])
                flag |= AMP_ENCRYPTED_SIGNED;
            
            if([part.mimeType isEqualToString:@"application/pgp-encrypted"]) //or check multipart/encrypted
                flag |= AMP_ENCRYPTED;
        }
    }
    return flag;
}

- (NSInteger) CheckSender:(AMPComposerInfo *)info
{
    GPGKey *key = [self GetValidKeyForMail:info.localMessage.from.mail];
    if(key.canAnySign)
        return 1;
    return 0;
}

- (GPGKey*) GetValidKeyForMail:(NSString*)mail
{
    for(GPGKey *key in [[GPGKeyManager sharedInstance] allKeys])
    {
        if(key.validity < GPGValidityInvalid) {
            for (GPGUserID *uid in key.userIDs) {
                if([uid.email isEqualToString:mail])
                {
                    NSLog(@"AMPGpgEncryption GetKeyForMail GPGKey %@ canAnySign %d canAnyEncrypt %d key.validity %d %@",mail, key.canSign, key.canAnyEncrypt, key.validity, key.keyID);
                    return key;
                }
            }
        }
    }
    return nil;
}


- (NSInteger) CheckRecipients:(AMPComposerInfo *)info
{
    NSArray *mails   = [info.localMessage GetMails];
    if(mails.count == 0)
        return 0;
        
    NSSet   *keys    = [[GPGKeyManager sharedInstance] allKeys];
    if(keys.count == 0)
        return 0;
    
    for(NSString *mail in mails)
    {
        GPGKey *key = [self GetValidKeyForMail:mail];
        if(!key || !key.canAnyEncrypt || key.validity >= GPGValidityInvalid)
            return 0;
    }
    return 1;
}

- (NSString*) Envelope:(NSString*)rfc info:(AMPComposerInfo*)info enc:(BOOL)enc sign:(BOOL)sign
{
    if(!rfc)
        @throw [NSException exceptionWithName:AMPGpgEncryptionException reason:@"GPG Envelope missing rfc input" userInfo:nil];
    
    NSString *from              = info.localMessage.from.mail;
    if(!from)
        @throw ([NSException exceptionWithName:AMPGpgEncryptionException reason:@"GPG Envelope cannot get the from of the message" userInfo:nil]);

    NSDictionary *maps          = [info.localMessage GetMailsMaps];
    
    NSMutableArray *recipients  = [NSMutableArray array];
    [recipients addObjectsFromArray:maps[@"to"]];
    [recipients addObjectsFromArray:maps[@"cc"]];
    [recipients addObject:from];                  //Encrypt also with my key to read it in sent messages
    NSArray *hiddenRecipients  = maps[@"bcc"];
    
    NSString *rfcFinal = rfc;
    //SIGN
    if(sign)
        rfcFinal = [self Sign:rfc from:from recipients:recipients hiddenRecipients:hiddenRecipients];
    
    if(!rfcFinal)
        @throw ([NSException exceptionWithName:AMPGpgEncryptionException reason:@"GPG Envelope cannot sign the message" userInfo:nil]);
    
    //ENCRYPT
    if(enc)
        rfcFinal = [self Encrypt:rfcFinal from:from recipients:recipients hiddenRecipients:hiddenRecipients];
    
    if(!rfcFinal)
        @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Envelope cannot encrypt the message" userInfo:nil];

    return rfcFinal;
}

- (NSData*) Decrypt:(AMPMessage*)message
{
    NSData *data = message.rfcData;
    if(!data)
        @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Decrypt missing data to decrypt" userInfo:nil];

    AMPMCOMessageParser *parser = [AMPMCOMessageParser messageParserWithData:data];
    if(!parser)
        @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Decrypt cannot parse the data" userInfo:nil];;
    
    NSArray *encParts = [parser.mainPart PartsForMime:@"application/octet-stream"];
    if(encParts.count == 1)
    {
        AMPMCOAbstractPart *part = encParts[0];
        if(![part.filename isEqualToString:@"encrypted.asc"])
            @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Decrypt cannot find encrypted.asc" userInfo:nil];;
        
        //NSLog(@"%@",part);
        NSData *dataAttachment = [part callSelector:@selector(data)];
        if(!dataAttachment || dataAttachment.length == 0)
            @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Decrypt cannot get data from encrypted attachment" userInfo:nil];;
        
        NSData *decodedData = [[GPGController gpgController] decryptData:dataAttachment];
        if(!decodedData || decodedData.length == 0)
            @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG Decrypt cannot decryptData" userInfo:nil];;
        
        //NSLog(@"***** ***** ***** ***** \n%@", [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding]);
        return decodedData;
    }
    return nil;

}

- (AMPSignatureVerify*) VerifySignature:(AMPMessage*)message
{
    AMPSignatureVerify *ver = [AMPSignatureVerify new];
    ver.signatureVerify = AMP_SIGNED_NONE;
    ver.mimetoRemove    = @[@"application/pgp-signature"];
    
    NSData *messageData = message.rfcData;
    if(!messageData)
        @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG VerifySignature missing data to decrypt" userInfo:nil];;
    
    NSData *detachedData = nil;
    //Se e' signed uso detached content
    AMPMCOMessageParser *parser = [AMPMCOMessageParser messageParserWithData:messageData];
    if(parser.mainPart.partType == AMPMCOPartTypeMultipartSigned)
    {
        NSString *rfc   = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
        detachedData    = [self GetSignedPart:rfc];
        if(!detachedData)
            @throw [NSException exceptionWithName:AMPGpgEncryptionException  reason:@"GPG VerifySignature cannot extract detached data" userInfo:nil];;
    }
    
    NSArray *encParts = [parser.mainPart PartsForMime:@"application/pgp-signature"];
    if(encParts.count == 1)
    {
        ver.signatureVerify = AMP_SIGNED_FAILS;
        AMPMCOAbstractPart *part = encParts[0];
        //NSLog(@"%@",part);
        if(![part.filename isEqualToString:@"signature.asc"])
            return ver;

        NSData *dataAttachment = [part callSelector:@selector(data)];
        if(!dataAttachment)
            return ver;
        
//        NSLog(@"***** dataAttachment \n%@", [[NSString alloc] initWithData:dataAttachment encoding:NSUTF8StringEncoding]);
//        NSLog(@"***** detachedData   \n%@", [[NSString alloc] initWithData:detachedData   encoding:NSUTF8StringEncoding]);

        NSArray *arr =  [[GPGController gpgController] verifySignature:dataAttachment originalData:detachedData];
        //CASE 1 Signer >> multi-signer does not work we have only 1 sender
        for(GPGSignature *sign in arr)
        {
            if(sign.trust < GPGValidityInvalid )
            {
                for(GPGKey *key in [[GPGKeyManager sharedInstance] allKeys])
                {
                    if( [sign.email isEqualToString:key.email] ) {
                        for (GPGUserID *uid in key.userIDs) {
                            if([uid.email isEqualToString:message.from.mail])
                            {
                                NSLog(@"SIGNATURE OK %@",uid.email);
                                ver.signatureVerify = AMP_SIGNED_SUCCESS;
                                return ver;
                            }
                        }
                    }
                }
            }
        }
    }
    return ver;
}

#pragma mark - Encrypt/Sign
- (NSString*) Encrypt:(NSString*)rfc from:(NSString*)mail recipients:(NSArray*)recipients hiddenRecipients:(NSArray*)hiddenRecipients
{
    //Exctract ctype + body
    NSString *stringToEncrypt = [self GetBodyPartWithHeaders:rfc];
    if(!stringToEncrypt) return nil;
    
    NSData *dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
    if(!dataToEncrypt || dataToEncrypt.length == 0) return nil;
    
    GPGController *gpgc = [GPGController gpgController];
    gpgc.useArmor = YES;
    gpgc.useTextMode = YES;
    gpgc.trustAllKeys = YES;
    NSData *dataEncrypted = nil;
    @try {
        dataEncrypted = [gpgc processData:dataToEncrypt withEncryptSignMode:GPGPublicKeyEncrypt recipients:recipients hiddenRecipients:hiddenRecipients];
    }
    @catch (NSException *exception) {
        return nil;
    }
    if(!dataEncrypted || dataEncrypted.length == 0) return nil;
    

    //NSData *decodedData = [[GPGController gpgController] decryptData:dataEncrypted];
    
    NSString *rfcret = [self CreateRfcEncrypted:rfc dataEncrypted:dataEncrypted];
    return rfcret;
}

- (NSString*) Sign:(NSString*)rfc from:(NSString*)from recipients:(NSArray*)recipients hiddenRecipients:(NSArray*)hiddenRecipients
{
    NSString *stringToSign = [self GetBodyPartWithHeaders:rfc];
    if(!stringToSign) return nil;
   
    //Sign the content
    NSData *dataToSign = [stringToSign dataUsingEncoding:NSUTF8StringEncoding];
    if(!dataToSign) return nil;
    
    GPGController *gpgc = [GPGController gpgController];
    gpgc.useArmor = YES;
    gpgc.useTextMode = YES;
    gpgc.trustAllKeys = YES;
    GPGKey *key = [self GetValidKeyForMail:from];
    if(!key)
    {
        NSLog(@"Error no signer key %@",from);
        return nil;
    }
    
    [gpgc setSignerKey:key];
    NSData *dataSigned = [gpgc processData:dataToSign withEncryptSignMode:GPGDetachedSign recipients:NULL hiddenRecipients:NULL];
    if(!dataSigned) return nil;
    
    return [self CreateRfcSigned:rfc stringToSign:stringToSign dataSigned:dataSigned];
}

#pragma mark Mime
- (NSString*) CreateRfcEncrypted:(NSString*)rfc dataEncrypted:(NSData*)dataEncrypted
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *boundary = (__bridge_transfer NSString *)string;
    if(!boundary)
        boundary = @"------=_Part_68593_50468503.1397487740428";
    
    
//    Content-Type: multipart/encrypted;
//        boundary="Apple-Mail=_A3AEE18D-B565-4A74-B695-C9C48DBE43AC";
//        protocol="application/pgp-encrypted";
    NSString *multipartSignedCtype = @"Content-Type: multipart/encrypted;\r\n";
    multipartSignedCtype = [multipartSignedCtype stringByAppendingFormat:@"\tboundary=\"%@\";\r\n",boundary];
    multipartSignedCtype = [multipartSignedCtype stringByAppendingString:@"\tprotocol=\"application/pgp-encrypted\";\r\n"];
    multipartSignedCtype = [multipartSignedCtype stringByAppendingString:@"Content-Description: OpenPGP encrypted message"];

    NSString *body = @"This is an OpenPGP/MIME encrypted message (RFC 2440 and 3156)\r\n";
    body = [body stringByAppendingFormat:@"--%@\r\n",boundary];
    body = [body stringByAppendingString:@"Content-Transfer-Encoding: 7bit\r\n"];
    body = [body stringByAppendingString:@"Content-Type: application/pgp-encrypted\r\n"];
    body = [body stringByAppendingString:@"Content-Description: PGP/MIME Versions Identification\r\n"];
    body = [body stringByAppendingString:@"\r\n"];
    body = [body stringByAppendingString:@"Version: 1\r\n"];
    body = [body stringByAppendingString:@"\r\n"];
    body = [body stringByAppendingFormat:@"--%@\r\n",boundary];
    body = [body stringByAppendingString:@"Content-Transfer-Encoding: 7bit\r\n"];
    body = [body stringByAppendingString:@"Content-Disposition: inline; filename=encrypted.asc\r\n"];
    body = [body stringByAppendingString:@"Content-Type: application/octet-stream; name=encrypted.asc\r\n"];
    body = [body stringByAppendingString:@"Content-Description: OpenPGP encrypted message\r\n"];
    body = [body stringByAppendingString:@"\r\n"];
    body = [body stringByAppendingString:@"-----BEGIN PGP MESSAGE-----\r\n"];
    body = [body stringByAppendingString:@"Comment: GPGTools - https://gpgtools.org\r\n"];
    body = [body stringByAppendingString:@"\r\n"];
    body = [body stringByAppendingString:[dataEncrypted ampBase64EncodedString]];
    body = [body stringByAppendingString:@"\r\n-----END PGP MESSAGE-----\r\n"];
    body = [body stringByAppendingString:@"\r\n"];
    body = [body stringByAppendingFormat:@"--%@--",boundary];
    
    NSMutableString *rfcOut = [NSMutableString new];
    NSString *headersWithNewCType = [self TrascriptHeaders:rfc withNewContentType:multipartSignedCtype];
    [rfcOut appendString:headersWithNewCType];
    [rfcOut appendString:body];
    
    return rfcOut;
}

- (NSString*) CreateRfcSigned:(NSString*)rfc stringToSign:(NSString*)stringToSign dataSigned:(NSData*)dataSigned
{
    //    Recreate RFC
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *boundary = (__bridge_transfer NSString *)string;
    if(!boundary)
        boundary = @"------=_Part_68593_50468503.1397487740428";
    
    //Content-Type: multipart/signed; boundary="Apple-Mail=_1DF223E0-8C6F-4931-9C66-57559AD94CB5"; protocol="application/pgp-signature"; micalg=pgp-sha512

    NSString *multipartSignedCtype = @"Content-Type: multipart/signed;\r\n";
    multipartSignedCtype = [multipartSignedCtype stringByAppendingFormat:@"\tboundary=\"%@\";\r\n",boundary];
    multipartSignedCtype = [multipartSignedCtype stringByAppendingString:@"\tprotocol=\"application/pgp-signature\"; micalg=pgp-sha512"];

    //    ------=_Part_68593_50468503.1397487740429
    NSString *partSigned = [NSString stringWithFormat:@"--%@\r\n",boundary];
    
//    --Apple-Mail=_1DF223E0-8C6F-4931-9C66-57559AD94CB5
//    Content-Transfer-Encoding: 7bit
//    Content-Disposition: attachment; filename=signature.asc
//    Content-Type: application/pgp-signature; name=signature.asc
//    Content-Description: Message signed with OpenPGP using GPGMail
    NSString *partSignature = [NSString stringWithFormat:@"--%@\r\n",boundary];
    partSignature = [partSignature stringByAppendingString:@"Content-Transfer-Encoding: 7bit\r\n"];
    partSignature = [partSignature stringByAppendingString:@"Content-Disposition: attachment; filename=signature.asc\r\n"];
    partSignature = [partSignature stringByAppendingString:@"Content-Type: application/pgp-signature; name=signature.asc\r\n"];
    partSignature = [partSignature stringByAppendingString:@"Content-Description: Message signed with OpenPGP using AMPGpg\r\n"];
    partSignature = [partSignature stringByAppendingString:@"\r\n"];
    partSignature = [partSignature stringByAppendingString:@"-----BEGIN PGP SIGNATURE-----\r\n"];
    partSignature = [partSignature stringByAppendingString:@"Comment: GPGTools - https://gpgtools.org\r\n\r\n"];
    partSignature = [partSignature stringByAppendingString:[dataSigned ampBase64EncodedString]];
    partSignature = [partSignature stringByAppendingString:@"\r\n-----END PGP SIGNATURE-----\r\n"];
    partSignature = [partSignature stringByAppendingString:@"\r\n"];
    partSignature = [partSignature stringByAppendingFormat:@"--%@--",boundary];

    NSMutableString *rfcOut = [NSMutableString new];
    NSString *headersWithNewCType = [self TrascriptHeaders:rfc withNewContentType:multipartSignedCtype];
    [rfcOut appendString:headersWithNewCType];
    [rfcOut appendString:partSigned];
    [rfcOut appendString:stringToSign];
    [rfcOut appendString:@"\r\n"];
    [rfcOut appendString:partSignature];
    return rfcOut;
}

//Extract the detached content signed
- (NSData*) GetSignedPart:(NSString*)rfc
{
    //Content-Type: multipart/signed; boundary="Apple-Mail=_9A3F1E72-6E76-46E6-A41E-A410E2637A5A"; protocol="application/pkcs7-signature"; micalg=sha1
    if(!rfc) return nil;
    
    NSScanner *scan  = [NSScanner scannerWithString:rfc];
    [scan setCharactersToBeSkipped:nil];
    
    if(![scan scanUpAndScan:@"Content-Type:" intoString:nil]) return nil;
    
    NSString *boundary  = [self ParseBoundary:scan];
    if(!boundary) return nil;
    //NSLog(@"%@",boundary);
    
    NSArray *boundaries = [self ParsePartsForBoundary:scan boundary:boundary];
    if(boundaries && boundaries.count > 0)
    {
        NSString *detachedString = boundaries[0];
        if(detachedString)
            return [detachedString dataUsingEncoding:NSASCIIStringEncoding];
        
    }
    return nil;
}

//Extract the part to sign/encrypt with its headers
- (NSString*) GetBodyPartWithHeaders:(NSString*)rfc
{
    //Content-Type: multipart/signed; boundary="Apple-Mail=_9A3F1E72-6E76-46E6-A41E-A410E2637A5A"; protocol="application/pkcs7-signature"; micalg=sha1
    if(!rfc)
        return nil;
    NSScanner *scanner  = [NSScanner scannerWithString:rfc];
    [scanner setCharactersToBeSkipped:nil];
    
    NSString  *ctype    = [self GetHeader:scanner header:@"Content-Type"];
    if(!ctype) return nil;
    
    NSScanner *scanner2  = [NSScanner scannerWithString:ctype];
    [scanner2 setCharactersToBeSkipped:nil];
    NSString  *boundary = [self ParseBoundary:scanner2];
    if(!boundary)
    {
        NSScanner *scannerSinglePart  = [NSScanner scannerWithString:rfc];
        [scannerSinglePart setCharactersToBeSkipped:nil];
        if(![scannerSinglePart scanUpAndScan:@"\r\n\r\n" intoString:nil])return nil;
        
        NSString *rfcToSign = [rfc substringFromIndex:scannerSinglePart.scanLocation];
        return rfcToSign;
    }
    
    NSString *preBoundary    = [NSString stringWithFormat:@"--%@",boundary];
    NSString *closeBoundary  = [NSString stringWithFormat:@"--%@--",boundary];
    
    if(![scanner scanUpToString:preBoundary intoString:nil]) return nil;
    
    NSString *detachedString = nil;
    if(![scanner scanUpToString:closeBoundary intoString:&detachedString]) return nil;
    if(!detachedString) return nil;
    
    detachedString = [NSString stringWithFormat:@"Content-Type:%@\r\n\r\n%@%@",ctype,detachedString,closeBoundary];
    return detachedString; //[detachedString dataUsingEncoding:NSASCIIStringEncoding];
}

- (NSString*) ParseBoundary:(NSScanner*)scanner
{
    if(![scanner scanUpToString:@"boundary"    intoString:nil]) return nil;
    if(![scanner scanUpToString:@"="           intoString:nil]) return nil;
    if(![scanner scanUpToString:@"\""          intoString:nil]) return nil;
    if(![scanner scanString:@"\""              intoString:nil]) return nil;
    
    NSString *boundary  = nil;
    if(![scanner scanUpToString:@"\"" intoString:&boundary]) return nil;
    
    if(!boundary) return nil;
    return boundary;
}

//Extract the part2 for a given boudary
- (NSArray*) ParsePartsForBoundary:(NSScanner*)scanner boundary:(NSString*)boundary
{
    NSMutableArray *ret     = [NSMutableArray array];
    NSString *preBoundary   = [NSString stringWithFormat:@"--%@",boundary];
    
    while(YES)
    {
        //Start Boundary (-boundary\r\n)
        if(![scanner scanUpAndScan:preBoundary intoString:nil]) break;
        if([scanner scanString:@"--" intoString:nil]) //chiusura
            break;

        if(![scanner scanUpAndScan:@"\n"        intoString:nil]) break;
        
        //        NSString *log;
        //        [scanner nextCharacters:10 inString:&log];
        //        NSLog(@"%@",log);
        
        NSString *detachedString = nil;
        if(![scanner scanUpToString:[NSString stringWithFormat:@"\n%@",preBoundary] intoString:&detachedString])
            break;
        
        [ret addObject:detachedString];
    }
    return ret;
}

//Extract an header from an rfc
- (NSString*) GetHeader:(NSScanner*)scanner header:(NSString*)headerName
{
    NSString *header        = [headerName stringByAppendingString:@":"];
    NSString *newline       = @"\r\n";
    
    //Content-Type: application/pkcs7-mime; name=smime.p7m; smime-type=enveloped-data
    //Content-Transfer-Encoding: base64
    //Content-Disposition:
    
    //Se e' il primo o e' dopo alcuni caratteri
    if(![scanner scanUpAndScan:header intoString:nil]) return nil;
    
    NSMutableString *valuex = [NSMutableString new];
    while(YES)
    {
        NSString *valueNext = nil;
        if([scanner nextString:newline])
        {
            valueNext = @"";
        }
        else  if(![scanner scanUpToString:newline intoString:&valueNext])
        {
            NSLog(@"Error Cannot parse multi header next values in ParseHeader %@",headerName);
            return nil;
        }
        //[valuex appendString:valueNext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [valuex appendString:valueNext];
        
        //skippo la newline
        if(![scanner scanNext:2])
        {
            NSLog(@"Error Cannot scan multi header next 2 chars MA_NEWLINE in ParseHeader %@",headerName);
            return nil;
        }
        
        unichar c = scanner.currentCharacter;
        if ([[NSCharacterSet letterCharacterSet] characterIsMember:c] ||
            [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c] ||
            [scanner nextString:newline])
        {
            if(!valuex)
            {
                NSLog(@"Error value is null in ParseHeader %@",headerName);
                return nil;
            }
            break;
        }
        else
        {
            [valuex appendString:newline]; //appendo la newline che ho torvato e continuo a parsare l'header
        }
    }
    return valuex;
}

//Rewrite headers with a new ContentType
- (NSString*) TrascriptHeaders:(NSString*)rfc withNewContentType:(NSString*)ctype
{
    NSMutableString *rfcOut = [NSMutableString new];
    __block NSInteger ctypeMode = 0;
    [rfc enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        
        if([line isEqualToString:@""]) //end of header
        {
            [rfcOut appendString:@"\r\n"];
            *stop = YES;
            return;
        }
        
        if([line hasPrefix:@"Content-Type"])
            ctypeMode = 1; //start
        
        switch (ctypeMode)
        {
            case 0:
            {
                [rfcOut appendFormat:@"%@\r\n",line];
            }
                break;
                
            case 1: //start ctype
            {
                [rfcOut appendFormat:@"%@\r\n",ctype];
                ctypeMode = 2;
            }
                break;
                
            case 2: //during ctype
            {
                if([line rangeOfString:@":"].location != NSNotFound) //nuovo header
                    ctypeMode = 0;
            }
                break;
        }
    }];
    return rfcOut;
}

@end
