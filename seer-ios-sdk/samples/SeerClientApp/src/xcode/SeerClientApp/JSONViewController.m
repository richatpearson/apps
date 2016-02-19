//
//  JSONViewController.m
//  SeerClientApp
//
//  Created by Richard Rosiak on 1/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "JSONViewController.h"
#import "AssetByScreenHeight.h"

@interface JSONViewController ()

@end

@implementation JSONViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.backgroundImageView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"Background")];
    
    self.jsonTextView.text = [self jsonDictionaryToString:self.json];
    NSLog(@"JSON string is : %@", [self.json description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)jsonDictionaryToString:(NSDictionary *)json {
    NSError *error;
    NSData *jsonStringData = [NSJSONSerialization dataWithJSONObject:json
                                                             options:NSJSONWritingPrettyPrinted error:&error];
    
    return [[NSString alloc] initWithData:jsonStringData encoding:NSUTF8StringEncoding];
}

@end
