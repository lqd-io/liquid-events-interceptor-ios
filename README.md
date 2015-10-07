Liquid Events Interceptor
==================

Quick way to integrate Liquid basic analytics using your current Localytics or Mixpanel integration.

With this Pod installed, all events being tracked by Localytics or Mixpanel will also be automatically tracked by Liquid, as well as user attributes.


### Install

1. Install [CocoaPods](http://cocoapods.org/) in your system.

2. Open your Xcode project folder and create/edit a file called `Podfile` with the following content, depending on the analytics service you're already using. **Use only one of them**:

    ```ruby
    pod 'Liquid-Localytics-Interceptor/Localytics'
    pod 'Liquid-Localytics-Interceptor/Mixapanel'
    pod 'Liquid-Localytics-Interceptor/GoogleAnalytics'
    ```

3. Run `pod install` and wait for CocoaPod to install Liquid SDK.

4. Open your `AppDelegate.m`, and initialize Liquid, **before** initializing your current analytics service:

If your using Localytics:
```obj-c
// AppDelegate.m
#import "AppDelegate.h"
#import <Localytics/Localytics.h>
#import <Liquid/Liquid.h>
#import "LiquidLocalyticsInterceptor.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Liquid sharedInstanceWithToken:@"YOUR-LIQUID-TOKEN"]; // before Localytics
    [Localytics autoIntegrate:@"YOUR-LOCALYTICS-APP-KEY" launchOptions:launchOptions];
    return YES;
}
```

If you're using Mixpanel:

```obj-c
// AppDelegate.m
#import "AppDelegate.h"
#import <Mixpanel/Mixpanel.h>
#import <Liquid/Liquid.h>
#import "LiquidMixpanelInterceptor.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Liquid sharedInstanceWithToken:@"YOUR-LIQUID-TOKEN"]; // before Mixpanel
    [Mixpanel sharedInstanceWithToken:@"YOUR-MIXPANEL-TOKEN"];
    return YES;
}
```

If you're using Google Analytics:

```obj-c
// AppDelegate.m
#import "AppDelegate.h"
#import <Google/Analytics.h>
#import <Liquid/Liquid.h>
#import <LiquidMixpanelInterceptor.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Liquid sharedInstanceWithToken:@"YOUR-LIQUID-TOKEN"];
    return YES;
}
```


### Full integration

To use all the Liquid features please integrate our  [SDK](https://github.com/lqd-io/liquid-sdk-ios).

We recommend you to read the full [documentation](https://www.onliquid.com/documentation/ios).


# Author

Liquid Data Intelligence, S.A.

# License

Liquid is available under the Apache license. See the LICENSE file for more info.

