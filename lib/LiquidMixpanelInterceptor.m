//
//  LQMixpanelInterceptor.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 17/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "LiquidMixpanelInterceptor.h"
#import "LQAttributesSanitizer.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import <Liquid/Liquid.h>
#import <Mixpanel/Mixpanel.h>

#define kLQEventsInterceptorLogLevel kLQLogLevelWarning

@implementation LiquidMixpanelInterceptor

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self intercept];
        LQLog(kLQEventsInterceptorLogLevel, @"LiquidMixpanelInterceptor Loaded.");
    });
}

+ (void)intercept {
    [self interceptEvents];
    [self interceptlUserIdentify];
    [self interceptUserAttributes];
    [self interceptUserAttribute];
    LQLog(kLQEventsInterceptorLogLevel, @"Intercepting Mixpanel.");
}

+ (void)interceptEvents {
    [Mixpanel aspect_hookSelector:@selector(track:properties:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *name = [[aspectInfo arguments] objectAtIndex:0];
        NSDictionary *attributes = [LQAttributesSanitizer sanitizedAttributesFrom:[[aspectInfo arguments] objectAtIndex:1]];
        
        [[Liquid sharedInstance] track:name attributes:attributes];
        LQLog(kLQEventsInterceptorLogLevel, @"Tracking event '%@' with attributes: %@", name, attributes);
    } error:NULL];
}

+ (void)interceptlUserIdentify {
    [Mixpanel aspect_hookSelector:@selector(identify:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *identifier = [[aspectInfo arguments] objectAtIndex:0];
        
        [[Liquid sharedInstance] identifyUserWithIdentifier:identifier];
        LQLog(kLQEventsInterceptorLogLevel, @"Identifying user '%@'", identifier);
    } error:NULL];
}

+ (void)interceptUserAttributes {
    [MixpanelPeople aspect_hookSelector:@selector(set:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSDictionary *attributes = [LQAttributesSanitizer sanitizedAttributesFrom:[[aspectInfo arguments] objectAtIndex:0]];
        
        [[Liquid sharedInstance] setUserAttributes:attributes];
        LQLog(kLQEventsInterceptorLogLevel, @"Setting many euser attributes attributes: %@", attributes);
    } error:NULL];
}

+ (void)interceptUserAttribute {
    [MixpanelPeople aspect_hookSelector:@selector(set:to:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *key = [[aspectInfo arguments] objectAtIndex:0];
        id value = [[aspectInfo arguments] objectAtIndex:1];
        
        if ([LQAttributesSanitizer dataTypeIsValid:value]) {
            [[Liquid sharedInstance] setUserAttribute:value forKey:key];
            LQLog(kLQEventsInterceptorLogLevel, @"Setting the user attribute '%@' with the value '%@'", key, value);
        }
    } error:NULL];
}

@end
