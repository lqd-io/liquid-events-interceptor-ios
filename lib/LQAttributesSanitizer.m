//
//  LQAttributesSanitizer.m
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 17/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import "LQAttributesSanitizer.h"
#import <UIKit/UIKit.h>

@implementation LQAttributesSanitizer

+ (NSDictionary *)sanitizedAttributesFrom:(NSDictionary *)attributes {
    if (!attributes || [attributes isKindOfClass:[NSNull class]]) {
        return [[NSDictionary alloc] init];
    }
    NSMutableDictionary *sanitizedAttributes = [[NSMutableDictionary alloc] init];
    for (NSString *key in attributes) {
        id value = attributes[key];
        if ([self dataTypeIsValid:value]) {
            [sanitizedAttributes setObject:value forKey:key];
        }
    }
    return sanitizedAttributes;
}

+ (NSString *)sanitizeKey:(NSString *)key {
    return [[key stringByReplacingOccurrencesOfString:@"$" withString:@""]
            stringByReplacingOccurrencesOfString:@"." withString:@"-"];
}

+ (BOOL)dataTypeIsValid:(id)object {
    return ([object isKindOfClass:[NSString class]] ||
            [object isKindOfClass:[NSNumber class]] ||
            [object isKindOfClass:[NSDate class]] ||
            [object isKindOfClass:[UIColor class]] ||
            [object isKindOfClass:[NSNull class]]);
}

@end
