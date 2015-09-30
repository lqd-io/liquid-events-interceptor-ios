//
//  AppDelegate.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 20/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "AppDelegate.h"
#import <Localytics/Localytics.h>
#import "LiquidLocalyticsInterceptor.h"
#import "LiquidMixpanelInterceptor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Liquid sharedInstanceWithToken:@"YOUR-LIQUID-TOKEN"]; // before Localytics & Mixapnel
    [Localytics autoIntegrate:@"YOUR-LOCALYTICS-APP-KEY" launchOptions:launchOptions];
    [Mixpanel sharedInstanceWithToken:@"YOUR-MIXPANEL-TOKEN"];
    return YES;
}

@end
