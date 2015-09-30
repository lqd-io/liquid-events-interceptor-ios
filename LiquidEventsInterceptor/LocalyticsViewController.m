//
//  ViewController.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 20/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "LocalyticsViewController.h"
#import <Localytics/Localytics.h>

#import "Liquid.h"

@interface LocalyticsViewController ()

@end

@implementation LocalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)identifyUser {
    [Localytics setCustomerId:@"user@example.com"];
}

- (IBAction)setOneUserAttribute {
    [Localytics setValue:@"female" forProfileAttribute:@"Gender"];
}

- (IBAction)setManyUserAttributes {
    [Localytics setCustomerEmail:@"user@example.com"];
    [Localytics setCustomerFullName:@"Anna Martinez"];
    [Localytics setCustomerFirstName:@"Anna"];
    [Localytics setCustomerLastName:@"Martinez"];
}

- (IBAction)trackEvent {
    [Localytics tagEvent:@"Buy Button Pressed"];
}

- (IBAction)trackEventWithAttributes {
    [Localytics tagEvent:@"Buy Button Pressed" attributes:@{ @"ProductId": @534 }];
}

- (IBAction)trackEventWithAttributesAndValueIncrement {
    [Localytics tagEvent:@"Buy Button Pressed" attributes:@{ @"ProductId": @534 } customerValueIncrease:@10];
}

@end
