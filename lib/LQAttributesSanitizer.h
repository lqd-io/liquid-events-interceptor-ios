//
//  LQAttributesSanitizer.h
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 17/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQAttributesSanitizer : NSObject

+ (NSDictionary *)sanitizedAttributesFrom:(NSDictionary *)attributes;
+ (NSString *)sanitizeKey:(NSString *)key;
+ (BOOL)dataTypeIsValid:(id)object;

@end
