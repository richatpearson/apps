//
//  LocalizationData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PGMCoreLanguagePreference;
extern NSString* const PGMCoreLocaleSetting;

/*!
 Data specific to the Localization to be gathered and retained
 */
@interface PGMCoreLocalizationData : NSObject 

/*!
 Returns the user's top language preference (iOS can return and array of user's 
 language preferences but we take the top one for parity with Android).
 */
@property (strong, nonatomic, readonly)   NSString  *   languagePreference;

/*!
 Country code representing locale setting (locale identifies a specific user 
 community—a group of users who have similar cultural and linguistic expectations
 for human-computer interaction).
 */
@property (strong, nonatomic, readonly)   NSString  *   localeSetting;

/*!
 Gather localization data.
 */
- (void) gatherData;

/*!
 Retrieve all localization data
 
 @return Localization Data properties as key-value pairs
 */
- (NSDictionary*) dataAsDictionary;

@end
