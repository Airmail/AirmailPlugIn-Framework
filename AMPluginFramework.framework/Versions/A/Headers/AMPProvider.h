//
//  AMPProvider.h
//  AMPluginFramework
//
//  Created by Joe on 16/11/13.
//  Copyright (c) 2013 Bloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPObject.h"
@interface AMPProvider : AMPObject
{
    
}

/**
 *  An integer for the provider type (see amp_provderType enum)
 *
 *  @return a a number with the value
 */
-(NSNumber*) key;

/**
 *  The provider name, gmail,aol,...
 *
 *  @return The provider name
 */
-(NSString*) name;

/**
 *  The provider domain, gmail.com, aol.com ...
 *
 *  @return The provider domain
 */
-(NSString*) domain;

/**
 *  The provider mail user@domain.com
 *
 *  @return The provider mail
 */
-(NSString*) mail;


/**
 *  The provider username the user add in account settings
 *
 *  @return The provider username
 */
-(NSString*) userName;

-(NSString*) descriptionName;

/**
 *  The receiving server imap.domain.com, pop.domain.com
 *
 *  @return The receiver server
 */
-(NSString*) rServer;

/**
 *  The receiving user user@domain.com or user
 *
 *  @return The receiving user
 */
-(NSString*) rUser;

/**
 *  The receiving authentication type NONE,PLAIN,LOGIN,CRAM-MD5,GSSAPI,DIGEST-MD5,SRP,NTLM,KERBEROS_V4
 *
 *  @return The receiving authentication
 */
-(NSString*) rAuthType;
/**
 *  The Exchange endpoint https://domain.com/EWS/Exchange.asmx
 *
 *  @return The Exchange endpoint
 */
-(NSString*) endPoint;

/**
 *  The receiving port 993, 143, ...
 *
 *  @return The receiving port
 */
-(NSNumber*) rPort;

/**
 *  TLS connection value: 0 clear connection, 1 Start TLS, 2 TLS.
 *
 *  @return TLS connection value
 */
-(NSNumber*) rTls;

/**
 *  Sending Server smtp.domain.com ...
 *
 *  @return Sending Server
 */
-(NSString*) sServer;

/**
 *  The sending user user@domain.com or user
 *
 *  @return The sending user
 */
-(NSString*) sUser;

/**
 *  The sending authentication type type PLAIN,LOGIN,CRAM-MD5,GSSAPI,DIGEST-MD5,NTLM,KERBEROS_V4
 *
 *  @return The sending authentication type
 */
-(NSString*) sAuthType;

/**
 *  The sending port 587, 25, ...
 *
 *  @return The sending port
 */
-(NSNumber*) sPort;

/**
 *  A boolean for the sending authentication if NO user and password are not used
 *
 *  @return  A boolean for the sending authentication
 */
-(NSNumber*) sAuth;

/**
 *  TLS connection value: 0 clear connection, 1 Start TLS, 2 TLS.
 *
 *  @return TLS connection value
 */
-(NSNumber*) sTls;


@end
