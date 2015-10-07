Pod::Spec.new do |s|
  s.name              = "Liquid-Events-Interceptor"
  s.version           = "0.1.1"
  s.summary           = "This Pod allows the integration of Liquid without any coding, if you already have Localytics or Mixpanel SDK installed in your application."
  s.homepage          = "https://onliquid.com/"
  s.license           = 'Apache, Version 2.0'
  s.author            = { "Liquid Data Intelligence S.A." => "support@onliquid.com" }
  s.source            = { :git => "https://github.com/lqd-io/liquid-events-interceptor-ios.git", :tag => "v#{s.version}" }
  s.social_media_url  = 'https://twitter.com/onliquid'
  s.documentation_url = "https://lqd.io/documentation/ios"
  s.library           = 'Liquid-Events-Interceptor'

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.preserve_paths = [ 'LiquidEventsInterceptor.xcodeproj' ]

  s.frameworks = %w(Foundation SystemConfiguration CoreTelephony CoreLocation CoreGraphics UIKit)

  s.xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load'
  }
  s.dependency 'Liquid'
  s.dependency 'Aspects'

  s.subspec 'Localytics' do |localytics|
    localytics.source_files = ['lib/LiquidLocalyticsInterceptor.{m,h}', 'lib/**/LQ*.{m,h}']
    localytics.public_header_files = ['lib/LiquidLocalyticsInterceptor.h', 'lib/**/LQ*.h']
    localytics.dependency 'Localytics'
    localytics.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(SRC_ROOT)/Pods/Localytics/*' }
  end

  s.subspec 'Mixpanel' do |mixpanel|
    mixpanel.source_files = ['lib/LiquidMixpanelInterceptor.{m,h}', 'lib/**/LQ*.{m,h}']
    mixpanel.public_header_files = ['lib/LiquidMixpanelInterceptor.h', 'lib/**/LQ*.h']
    mixpanel.dependency 'Mixpanel'
  end

  s.subspec 'GoogleAnalytics' do |google|
    google.source_files = ['lib/LiquidGoogleAnalyticsInterceptor.{m,h}', 'lib/**/LQ*.{m,h}']
    google.public_header_files = ['lib/LiquidGoogleAnalyticsInterceptor.h', 'lib/**/LQ*.h']
    google.dependency 'Google/Analytics'
  end
end

