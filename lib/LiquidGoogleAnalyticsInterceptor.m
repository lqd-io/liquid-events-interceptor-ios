//
//  LiquidGoogleAnalyticsInterceptor.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 06/10/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "LiquidGoogleAnalyticsInterceptor.h"
#import "LQAttributesSanitizer.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import <Liquid/Liquid.h>
#import <Google/Analytics.h>

#define kLQEventsInterceptorLogLevel kLQLogLevelWarning

static Class _googleAnalyticsClass = nil;

@implementation LiquidGoogleAnalyticsInterceptor

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self intercept];
        LQLog(kLQEventsInterceptorLogLevel, @"LiquidMixpanelInterceptor Loaded.");
    });
}

+ (void)intercept {
    [self interceptEvents];
    [self interceptTrackerAttributes];
    LQLog(kLQEventsInterceptorLogLevel, @"Intercepting Google Analytics.");
}

+ (void)interceptTrackerAttributes {
    [[self googleAnalyticsClass] aspect_hookSelector:@selector(set:value:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *key = [[aspectInfo arguments] objectAtIndex:0];
        NSString *value = [[aspectInfo arguments] objectAtIndex:1];
        if ([key isEqualToString:@"&uid"]) {
            [[Liquid sharedInstance] identifyUserWithIdentifier:value];
            LQLog(kLQEventsInterceptorLogLevel, @"Identifying user '%@'", value);
        } else if ([key isEqualToString:kGAIScreenName]) {
            [[Liquid sharedInstance] track:value];
            LQLog(kLQEventsInterceptorLogLevel, @"Tracking event '%@'", value);
        }
    } error:NULL];
}

+ (void)interceptEvents {
    [[self googleAnalyticsClass] aspect_hookSelector:@selector(send:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSDictionary *rawAttributes = [LQAttributesSanitizer sanitizedAttributesFrom:[[aspectInfo arguments] objectAtIndex:0]];
        NSString *name = nil;
        NSDictionary *attributes = nil;
        if ([[rawAttributes objectForKey:@"&t"] isEqualToString:@"event"]) {
            name = [self eventNameWithCategory:[rawAttributes objectForKey:@"&ec"]
                                                  action:[rawAttributes objectForKey:@"&ea"]
                                                   label:[rawAttributes objectForKey:@"&el"]];
            attributes = [self eventAttributesFromValue:[rawAttributes objectForKey:@"&ev"]];
            [[Liquid sharedInstance] track:name attributes:attributes];
            LQLog(kLQEventsInterceptorLogLevel, @"Tracking event '%@' with attributes: %@", name, attributes);
        }
    } error:NULL];
}

+ (NSString *)eventNameWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label {
    NSMutableString *name = [NSMutableString stringWithFormat:@"%@:%@", category, action];
    if (label) {
        [name appendFormat:@":%@", label];
    }
    return name;
}

+ (NSDictionary *)eventAttributesFromValue:(id)value {
    if (!value || [value isKindOfClass:[NSNull class]]) return nil;
    return @{ @"value:": value };
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

+ (Class)googleAnalyticsClass {
    if (!_googleAnalyticsClass) {
        _googleAnalyticsClass = [self classWithName:@"GAITrackerImpl"];
    }
    return _googleAnalyticsClass;
}


@end
