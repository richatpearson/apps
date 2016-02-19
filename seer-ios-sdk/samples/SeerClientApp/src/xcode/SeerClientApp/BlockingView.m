//
//  BlockingView.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 2/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "BlockingView.h"

@implementation BlockingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:64.0/255.0f green:64.0/255.0f blue:64.0/255.0f alpha:0.5f];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.color = [UIColor blackColor];
        self.activityIndicator.hidesWhenStopped = YES;
        
        CGRect rect = CGRectMake(140., 240., 40., 40.); //make it first
        self.activityIndicator.frame = rect;
        self.activityIndicator.center = CGPointMake(frame.size.width/2., frame.size.height/2.);
        
        [self addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    return self;
}


@end
