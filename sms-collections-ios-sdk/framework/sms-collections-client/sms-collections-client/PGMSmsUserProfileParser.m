//
//  PGMSmsUserProfileParser.m
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsUserProfileParser.h"
#import "PGMSmsUserModule.h"

NSString *const PGMSmsAcceptSubscriptionNode        = @"AcceptSubscription";
NSString *const PGMSmsUserNode                      = @"User";
NSString *const PGMSmsUserIdAttrib                  = @"id";
NSString *const PGMSmsFirstNameNode                 = @"FirstName";
NSString *const PGMSmsLastNameNode                  = @"LastName";
NSString *const PGMSmsLoginNameNode                 = @"LoginName";
NSString *const PGMSmsEmailAddressNode              = @"EmailAddress";
NSString *const PGMSmsInstitutionNameNode           = @"InstitutionName";
NSString *const PGMSmsModuleNode                    = @"Module";
NSString *const PGMSmsModuleIsTrialAttrib           = @"isTrial";
NSString *const PGMSmsModuleIsExpWithWarningAttrib  = @"isExpiringWithinWarningPeriod";
NSString *const PGMSmsModuleisExpiredAttrib         = @"isExpired";
NSString *const PGMSmsModuleAbbrevNode              = @"ModuleAbbrev";
NSString *const PGMSmsLastSignOnDateNode            = @"LastSignOnDate";
NSString *const PGMSmsExpirationDateNode            = @"ExpirationDate";
NSString *const PGMSmsProductTypeNode               = @"ProductType";
NSString *const PGMSmsProductTypeIdAttrib           = @"id";
NSString *const PGMSmsMarketNameNode                = @"MarketName";
NSString *const PGMSmsLicenseTypeNode               = @"LicenseType";
NSString *const PGMSmsProductRoleNameNode           = @"ProductRoleName";

NSString *const PGMSmsDenySubscriptionNode          = @"DenySubscription"; //error scenario
NSString *const PGMSmsReasonCode                    = @"ReasonCode";
NSString *const PGMSmsErrorDetails                  = @"ErrorDetails";
NSString *const PGMSmsNilData                       = @"Nil data passed from SMS to parser";
NSString *const PGMSmsInvalidData                   = @"Invalid data sent from SMS to parser";

@interface PGMSmsUserProfileParser()

@property (nonatomic, strong) NSString *currentNodeValue;
@property (nonatomic, strong) PGMSmsUserModule *currentUserModule;
@property (nonatomic, strong) NSMutableArray *userModules;

@end

@implementation PGMSmsUserProfileParser

-(void) parseWithData:(NSData*)data {
    [self checkNilData:data];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
}

-(void) checkNilData:(NSData*)data {
    if (!data) {
        self.smsErrorMessage = [NSMutableString string];
        [self.smsErrorMessage appendString:PGMSmsNilData];
    }
}

-(void) parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"Parser started the xml...");
    self.userProfile = [PGMSmsUserProfile new];
    self.userModules = [[NSMutableArray alloc] init];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Parser did start element %@", elementName);
    
    if ([elementName isEqualToString:PGMSmsUserNode]) {
        self.userProfile.userId = [attributeDict valueForKey:PGMSmsUserIdAttrib];
    }
    else if ([elementName isEqualToString:PGMSmsModuleNode]) {
        if (self.currentUserModule) {
            self.currentUserModule = nil;
        }
        self.currentUserModule =
            [[PGMSmsUserModule alloc] initWithIsTrial:[[attributeDict valueForKey:PGMSmsModuleIsTrialAttrib] boolValue]
                        isExpiringWithinWarningPeriod:[[attributeDict valueForKey:PGMSmsModuleIsExpWithWarningAttrib] boolValue]
                                            isExpired:[[attributeDict valueForKey:PGMSmsModuleisExpiredAttrib] boolValue]];
    }
    else if ([elementName isEqualToString:PGMSmsProductTypeNode]) {
        self.currentUserModule.productTypeId = [attributeDict valueForKey:PGMSmsProductTypeIdAttrib];
    }
    else if ([elementName isEqualToString:PGMSmsDenySubscriptionNode]) {
        self.smsErrorMessage = [NSMutableString string];
    }
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"Parser did end element %@", elementName);
    
    if ([elementName isEqualToString:PGMSmsFirstNameNode]) {
        //NSLog(@"Setting %@ as first name", self.currentNodeValue);
        self.userProfile.firstName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsLastNameNode]) {
        self.userProfile.lastName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsLoginNameNode]) {
        self.userProfile.loginName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsEmailAddressNode]) {
        self.userProfile.emailAddress = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsInstitutionNameNode]) {
        self.userProfile.institutionName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsModuleAbbrevNode]) {
        self.currentUserModule.moduleId = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsLastSignOnDateNode]) {
        self.currentUserModule.lastSignOnDate = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsExpirationDateNode]) {
        self.currentUserModule.expirationDate = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsMarketNameNode]) {
        self.currentUserModule.marketName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsLicenseTypeNode]) {
        self.currentUserModule.licenseType = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsProductRoleNameNode]) {
        self.currentUserModule.productRoleName = self.currentNodeValue;
    }
    else if ([elementName isEqualToString:PGMSmsModuleNode]) {
        [self.userModules addObject:self.currentUserModule];
    }
    else if ([elementName isEqualToString:PGMSmsReasonCode] || [elementName isEqualToString:PGMSmsErrorDetails]) {
        [self.smsErrorMessage appendString:self.currentNodeValue];
        //NSLog(@"smsErrorMsg is: %@", self.smsErrorMessage);
        if ([elementName isEqualToString:PGMSmsReasonCode]) {
            [self.smsErrorMessage appendString:@": "];
        }
    }
    
    self.currentNodeValue = @"";
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentNodeValue = string;
    //NSLog(@"Found characters - currentNodeValue is now: %@", self.currentNodeValue);
    
}

-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error occurred: %@", parseError.description);
    if (parseError.code == 4) { //invalid XML sent from SMS
        self.smsErrorMessage = [NSMutableString string];
        [self.smsErrorMessage appendString:PGMSmsInvalidData];
    }
}

-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"Validation error occurred: %@", validationError.description);
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parser finished with the xml! We have %ld user modules", (long unsigned)[self.userModules count]);
    self.userProfile.userModules = self.userModules;
}

@end
