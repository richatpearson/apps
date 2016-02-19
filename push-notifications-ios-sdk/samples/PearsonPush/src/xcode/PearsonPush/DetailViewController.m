//
//  DetailViewController.m
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setNotificationForDetail:(PearsonNotification *)newNotification
{
    if (self.notification != newNotification)
    {
        self.notification = newNotification;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.notification)
    {
        self.soundLabel.text        = [self.notification sound];
        self.badgeLabel.text        = [[self.notification badge] stringValue];
        if([self.notification alert])
        {
            self.messageTextView.text   = [NSString stringWithFormat:@"%@", [self.notification alert]];
        }
        else
        {
            self.messageTextView.text   = [NSString stringWithFormat:@"%@", [self.notification alertDict]];
        }
        
        // Custom Payload
        if([self.notification customPayload])
        {
            NSMutableString* customPayloadText = [NSMutableString new];
            for (NSString* key in [self.notification customPayload])
            {
                NSLog(@"DETAILVIEW CUSTOMPAYLOAD: %@: %@", key, [[self.notification customPayload] objectForKey:key]);
                NSString* payloadLine = [NSString stringWithFormat:@"%@: %@ \n", key, [[self.notification customPayload] objectForKey:key]];
                [customPayloadText appendString:payloadLine];
                
                self.customPayloadTextView.text = customPayloadText;
            }
        }
        else
        {
            self.customPayloadTextView.text = @"";
        }
        // Timestamp
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd, yyyy HH:mm:ss"];
        
        self.timestampLabel.text    = [formatter stringFromDate:self.notification.timestamp];
        
        // Application State Image
        UIImage *cellImage = nil;
        
        switch (self.notification.applicationState)
        {
            case UIApplicationStateActive:
                cellImage = [UIImage imageNamed:@"ApplicationActive.png"];
                break;
            case UIApplicationStateInactive:
                cellImage = [UIImage imageNamed:@"ApplicationInactive.png"];
                break;
            case UIApplicationStateBackground:
                cellImage = [UIImage imageNamed:@"ApplicationBackground.png"];
                break;
            default:
                cellImage = [UIImage imageNamed:@"ApplicationUnknown.png"];
                break;
        }
        self.appStateImg.image = cellImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
