//
//  GoogleAnalyticsViewController.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 01/10/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "GoogleAnalyticsViewController.h"
#import <Google/Analytics.h>

@interface GoogleAnalyticsViewController ()

@property (strong, nonatomic) id<GAITracker> tracker;

@end

@implementation GoogleAnalyticsViewController

@synthesize tracker = _tracker;

- (id<GAITracker>)tracker {
    if (!_tracker) {
        _tracker = [[GAI sharedInstance] defaultTracker];
    }
    return _tracker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tracker set:kGAIScreenName value:@"GoogleAnalyticsViewController"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (IBAction)identifyUser {
    [self.tracker set:@"&uid" value:@"user@example.com"];
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"            // Event category (required)
                                                               action:@"User Sign In"  // Event action (required)
                                                                label:nil              // Event label
                                                                value:nil] build]];    // Event value
}

- (IBAction)trackEvent {
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                               action:@"button_press"  // Event action (required)
                                                                label:@"buy"           // Event label
                                                                value:nil] build]];    // Event value
}

- (IBAction)trackEventWithLabel {
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                               action:@"button_press"  // Event action (required)
                                                                label:@"buy"           // Event label
                                                                value:nil] build]];    // Event value
}

- (IBAction)trackEventWithLabelAndValue {
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                               action:@"button_press"  // Event action (required)
                                                                label:@"buy"           // Event label
                                                                value:@123] build]];   // Event value
}

@end
