//
//  JSONViewController.h
//  SeerClientApp
//
//  Created by Richard Rosiak on 1/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (strong, nonatomic) IBOutlet UITextView *jsonTextView;
@property (strong, nonatomic) NSDictionary *json;

- (NSString *)jsonDictionaryToString:(NSDictionary *)json;

@end
