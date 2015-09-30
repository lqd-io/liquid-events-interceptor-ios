//
//  LQMixpanelInterceptor.h
//  LiquidEventsInterceptor
//
//  Created by Miguel M. Almeida on 17/09/15.
//  Copyright (c) 2015 Liquid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Liquid.h"
#import <Mixpanel/Mixpanel.h>

@interface LiquidMixpanelInterceptor : NSObject

+ (void)intercept;

@end
