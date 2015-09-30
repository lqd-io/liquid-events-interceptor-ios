//
//  ViewController.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 20/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "MixpanelViewController.h"
#import <Mixpanel/Mixpanel.h>

@interface MixpanelViewController ()

@end

@implementation MixpanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)identifyUser {
    [[Mixpanel sharedInstance] identify:@"user@example.com"];
}

- (IBAction)setOneUserAttribute {
    [[[Mixpanel sharedInstance] people] set:@"Gender" to:@"female"];
}

- (IBAction)setManyUserAttributes {
    [[[Mixpanel sharedInstance] people] set:@{ @"Plan": @"Premium" }];
}

- (IBAction)trackEvent {
    [[Mixpanel sharedInstance] track:@"Buy Button Pressed"];
}

- (IBAction)trackEventWithAttributes {
    [[Mixpanel sharedInstance] track:@"Buy Button" properties:@{ @"ProductId": @534}];
}

@end
