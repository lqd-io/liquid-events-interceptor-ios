//
//  AppDelegate.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 20/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "AppDelegate.h"
#import "LiquidLocalyticsInterceptor.h"
#import "LiquidMixpanelInterceptor.h"
#import <Google/Analytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Liquid sharedInstanceWithToken:@"YOUR-LIQUID-TOKEN"]; // before Localytics, Mixapnel or Google Analytics
    [Localytics autoIntegrate:@"YOUR-LOCALYTICS-APP-KEY" launchOptions:launchOptions];
    [Mixpanel sharedInstanceWithToken:@"YOUR-MIXPANEL-TOKEN"];

    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = NO;
    gai.logger.logLevel = kGAILogLevelInfo;

    return YES;
}

@end
