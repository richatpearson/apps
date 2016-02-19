//
//  PGMSmsUserProfileParser.h
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsUserProfile.h"

extern NSString *const PGMSmsAcceptSubscriptionNode;
extern NSString *const PGMSmsUserNode;
extern NSString *const PGMSmsUserIdAttrib;
extern NSString *const PGMSmsFirstNameNode;
extern NSString *const PGMSmsLastNameNode;
extern NSString *const PGMSmsLoginNameNode;
extern NSString *const PGMSmsEmailAddressNode;
extern NSString *const PGMSmsInstitutionNameNode;
extern NSString *const PGMSmsModuleNode;
extern NSString *const PGMSmsModuleIsTrialAttrib;
extern NSString *const PGMSmsModuleIsExpWithWarningAttrib;
extern NSString *const PGMSmsModuleisExpiredAttrib;
extern NSString *const PGMSmsModuleAbbrevNode;
extern NSString *const PGMSmsLastSignOnDateNode;
extern NSString *const PGMSmsExpirationDateNode;
extern NSString *const PGMSmsProductTypeNode;
extern NSString *const PGMSmsProductTypeIdAttrib;
extern NSString *const PGMSmsMarketNameNode;
extern NSString *const PGMSmsLicenseTypeNode;
extern NSString *const PGMSmsProductRoleNameNode;

extern NSString *const PGMSmsDenySubscriptionNode;
extern NSString *const PGMSmsReasonCode;
extern NSString *const PGMSmsErrorDetails;
extern NSString *const PGMSmsNilData;
extern NSString *const PGMSmsInvalidData;

@interface PGMSmsUserProfileParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) PGMSmsUserProfile *userProfile;

@property (nonatomic, strong) NSMutableString *smsErrorMessage;

-(void) parseWithData:(NSData*)data;

@end
