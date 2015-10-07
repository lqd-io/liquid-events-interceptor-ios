//
//  LiquidLocalyticsInterceptor.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 17/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "LiquidLocalyticsInterceptor.h"
#import "LQAttributesSanitizer.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>
#import <Liquid/Liquid.h>
#import <Localytics/Localytics.h>

#define kLQEventsInterceptorLogLevel kLQLogLevelWarning

static Class _localyticsManagerClass = nil;

@implementation LiquidLocalyticsInterceptor

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self intercept];
        LQLog(kLQEventsInterceptorLogLevel, @"LiquidLocalyticsInterceptor loaded.");
    });
}

+ (void)intercept {
    [self interceptEvents];
    [self interceptlUserIdentify];
    [self interceptUserAttribute];
    LQLog(kLQEventsInterceptorLogLevel, @"Intercepting Localytics.");
}

+ (void)interceptEvents {
    [[self localyticsManagerClass] aspect_hookSelector:NSSelectorFromString(@"tagEvent:attributes:customerValueIncrease:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *name = [[aspectInfo arguments] objectAtIndex:0];
        NSDictionary *attributes = [LQAttributesSanitizer sanitizedAttributesFrom:[[aspectInfo arguments] objectAtIndex:1]];
        NSNumber *customerValueIncrease = [[aspectInfo arguments] objectAtIndex:2];
        [[Liquid sharedInstance] track:name attributes:attributes];
        LQLog(kLQEventsInterceptorLogLevel, @"Tracking event '%@' with attributes: %@ and customerValueIncrease %@", name, attributes, customerValueIncrease);
    } error:NULL];
}

+ (void)interceptlUserIdentify {
    [[self localyticsManagerClass] aspect_hookSelector:NSSelectorFromString(@"setCustomerId:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *identifier = [[aspectInfo arguments] objectAtIndex:0];
        [[Liquid sharedInstance] identifyUserWithIdentifier:identifier];
        LQLog(kLQEventsInterceptorLogLevel, @"Identifying user '%@'", identifier);
    } error:NULL];
}

+ (void)interceptUserAttribute {
    [[self localyticsManagerClass] aspect_hookSelector:NSSelectorFromString(@"setValue:forProfileAttribute:withScope:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        id value = [[aspectInfo arguments] objectAtIndex:0];
        NSString *key = [LQAttributesSanitizer sanitizeKey:[[aspectInfo arguments] objectAtIndex:1]];
        if ([LQAttributesSanitizer dataTypeIsValid:value]) {
            [[Liquid sharedInstance] setUserAttribute:value forKey:key];
            LQLog(kLQEventsInterceptorLogLevel, @"Setting the user attribute '%@' with the value '%@'", key, value);
        }
    } error:NULL];
}

#pragma mark - Helper methods for dynamic class & method referencing

+ (Class)classWithName:(NSString *)className {
    Class theClass = NULL;
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for (int i = 0; i < numClasses; i++) {
            Class class = classes[i];
            if ([NSStringFromClass(class) isEqualToString:className]) {
                theClass = class;
            }
        }
        free(classes);
    }
    return theClass;
}

+ (Class)localyticsManagerClass {
    if (!_localyticsManagerClass) {
        _localyticsManagerClass = [self classWithName:@"LLLocalyticsManager"];
    }
    return _localyticsManagerClass;
}

@end
