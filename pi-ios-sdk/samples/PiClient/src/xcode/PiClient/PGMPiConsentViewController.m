//
//  PGMPiConsentViewController.m
//  PiClient
//
//  Created by Richard Rosiak on 6/17/14.
//  Copyright (c) 2014 Richard Rosiak. All rights reserved.
//

#import "PGMPiConsentViewController.h"
#import "PGMPiAppDelegate.h"
#import <Pi-ios-client/PGMPiConsentPolicy.h>

@interface PGMPiConsentViewController ()

@property (nonatomic, strong) NSString *currentPolicyId;

@end

@implementation PGMPiConsentViewController

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
    // Do any additional setup after loading the view.
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setDelegate:appDelegate.loginView];
    
    self.consentWebView.scalesPageToFit = YES;
    NSURL *url = [[NSURL alloc] initWithString:[self getConsentUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.consentWebView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"WEB VIEW DID FINISH LOADING");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) getConsentUrl {
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url = @"";
    for (PGMPiConsentPolicy *currentPolicy in appDelegate.consentPolicies) {
        if (!currentPolicy.isConsented && !currentPolicy.isReviewed) {
            url = currentPolicy.consentPageUrl;
            NSLog(@"Returning url for policy id %@", currentPolicy.policyId);
            self.currentPolicyId = currentPolicy.policyId;
            break;
        }
    }
    return url;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)acceptConsentButton:(id)sender {
    [self expressConsent];
    [self processCurrentConsents];
}

-(void) processCurrentConsents {
    if ([self areAllPoliciesReviewed]) {
        
        [self postConsentsToPi];
    } else {
        NSString *nextUrlForConsent = [self getConsentUrl];
        
        if (![nextUrlForConsent isEqualToString:@""]) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:nextUrlForConsent]];
            [self.consentWebView loadRequest:request];
        }
    }
}

-(void) postConsentsToPi {
    [[self navigationController] popViewControllerAnimated:NO];
    
    if ([self.delegate respondsToSelector:@selector(submitConsentAfterAcceptance)]) {
        [self.delegate submitConsentAfterAcceptance];
    }
}

- (BOOL) expressConsent {
    if (self.currentPolicyId) {
        [self markPolicyAsConsentedForPolicyId:self.currentPolicyId];
    }
    
    return true;
}

- (void) markPolicyAsConsentedForPolicyId:(NSString*)policyId {
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (PGMPiConsentPolicy *currentPolicy in appDelegate.consentPolicies) {
        if ([currentPolicy.policyId isEqualToString:policyId]) {
            currentPolicy.isConsented = YES;
            currentPolicy.isReviewed = YES;
        }
    }
}

-(BOOL) areAllPoliciesReviewed {
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (PGMPiConsentPolicy *currentPolicy in appDelegate.consentPolicies) {
        if (!currentPolicy.isReviewed) {
            return false;
        }
    }
    return true;
}

- (IBAction)declineConsentButton:(id)sender {
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (PGMPiConsentPolicy *currentPolicy in appDelegate.consentPolicies) {
        if ([currentPolicy.policyId isEqualToString:self.currentPolicyId]) {
            currentPolicy.isConsented = NO;
            currentPolicy.isReviewed = YES;
        }
    }
    
    [self processCurrentConsents];
}
@end
