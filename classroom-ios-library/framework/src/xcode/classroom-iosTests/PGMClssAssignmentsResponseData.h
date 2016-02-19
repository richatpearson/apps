//
//  PGMClssAssignmentsResponseData.h
//  classroom-ios
//
//  Created by Joe Miller on 10/20/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMClssAssignmentsResponseData : NSObject
/*
 NSString *aID1 = @"assignmentID1";
 NSString *aTitle1 = @"aTitle1";
 NSString *aTemplateID1 = @"aTemplateID1";
 NSString *aDescription1 = @"aDescription1";
 NSString *aLastModified1 = @"2014-01-01T23:59:59.000Z";
 
 NSString *aID2 = @"assignmentID2";
 NSString *aTitle2 = @"aTitle2";
 NSString *aTemplateID2 = @"aTemplateID2";
 NSString *aDescription2 = @"aDescription2";
 NSString *aLastModified2 = @"2014-02-02T23:59:59.000Z";
 
 NSString *aaID1 = @"aaID1";
 NSString *aaTitle1 = @"aaTitle1";
 NSString *aaDueDate1 = @"2014-01-01T23:59:59.000Z";
 NSString *aaThumbnailURL1 = @"aaThumbnailURL1";
 NSString *aaDescription1 = @"aaDescription1";
 NSString *aaLastModifiedDate1 = @"2014-01-01T23:59:59.000Z";
 
 NSString *aaID2 = @"aaID2";
 NSString *aaTitle2 = @"aaTitle2";
 NSString *aaDueDate2 = @"2014-02-02T23:59:59.000Z";
 NSString *aaThumbnailURL2 = @"aaThumbnailURL2";
 NSString *aaDescription2 = @"aaDescription2";
 NSString *aaLastModifiedDate2 = @"2014-02-02T23:59:59.000Z";
 */
@property (strong, nonatomic) NSString *assignment1Id;
@property (strong, nonatomic) NSString *assignment1Title;
@property (strong, nonatomic) NSString *assignment1TemplateId;


- (NSString *)jsonResponse;

@end
