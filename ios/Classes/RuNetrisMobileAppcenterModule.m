/**
 * ti.appcenter
 *
 * Created by Your Name
 * Copyright (c) 2019 Your Company. All rights reserved.
 */

#import "RuNetrisMobileAppcenterModule.h"
#import "RuNetrisMobileAppcenterAnalyticsProxy.h"
#import "RuNetrisMobileAppcenterCrashesProxy.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <AppCenter/MSAppCenter.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>
#import <AppCenterCrashes/AppCenterCrashes.h>

NSString *const PropertyStartCrashesOnCreate = @"ti.appcenter.crashes.start-on-create";
NSString *const PropertyStartAnalyticsOnCreate = @"ti.appcenter.analytics.start-on-create";
NSString *const PropertySecret = @"ti.appcenter.secret.ios";
NSString *const Tag = @"TiAppCenterModule";

@implementation RuNetrisMobileAppcenterModule

@synthesize isStarted;

#pragma mark Internal

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"0443bb65-2ff4-47a3-b9b0-e09f3b41b542";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"ru.netris.mobile.appcenter";
}

#pragma mark Lifecycle

- (void)startup
{
  [super startup];

  services = [NSMutableArray new];

  NSDictionary *properties = [TiApp tiAppProperties];

  secret = [TiUtils stringValue:[properties objectForKey:PropertySecret]];

  if ([TiUtils boolValue:[properties objectForKey:PropertyStartAnalyticsOnCreate]]) {
    [services addObject:MSAnalytics.self];
  }

  if ([TiUtils boolValue:[properties objectForKey:PropertyStartCrashesOnCreate]]) {
    [services addObject:MSCrashes.self];
  }

  if (services.count > 0) {
    [MSAppCenter start:secret withServices:services];

    isStarted = TRUE;
  }
}

#pragma Public APIs

- (void)start:(id)arguments
{
  if (isStarted) {
    return;
  }

  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to start()"]);
    return;
  }

  NSArray *args = (NSArray *)arguments;

  if (args.count == 0) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to start()"]);
    return;
  }

  NSString *secret = [TiUtils stringValue:[[TiApp tiAppProperties] objectForKey:PropertySecret]];
  if (secret == nil) {
    secret = [TiUtils stringValue:[args objectAtIndex:0]];
  }

  NSMutableArray<Class> *services = [NSMutableArray new];
  NSObject *item;
  NSUInteger length = args.count;
  for (int i = 1; i < length; ++i) {
    item = [args objectAtIndex:i];
    if ([item isKindOfClass:[RuNetrisMobileAppcenterCrashesProxy class]]) {
      [services addObject:MSAnalytics.self];
    } else if ([item isKindOfClass:[RuNetrisMobileAppcenterAnalyticsProxy class]]) {
      [services addObject:MSCrashes.self];
    } else {
      NSLog([[Tag stringByAppendingString:@": Wrong argument passed to start() "] stringByAppendingString:[item description]]);
    }
  }

  if (services.count > 0) {
    [MSAppCenter start:secret withServices:services];

    isStarted = TRUE;
  }
}

- (RuNetrisMobileAppcenterCrashesProxy *)Crashes
{
  if (crashes == nil) {
    crashes = [[RuNetrisMobileAppcenterCrashesProxy alloc] _initWithPageContext:[self executionContext]];
  }
  return crashes;
}

- (RuNetrisMobileAppcenterAnalyticsProxy *)Analytics
{
  if (analytics == nil) {
    analytics = [[RuNetrisMobileAppcenterAnalyticsProxy alloc] _initWithPageContext:[self executionContext]];
  }
  return analytics;
}

- (NSString *)getApiName
{
  return Tag;
}

#pragma Private methods

- (BOOL)startModule
{
  if (secret == nil) {
    NSLog([Tag stringByAppendingString:@": No secret key"]);
    return FALSE;
  }

  if (services.count == 0) {
    NSLog([Tag stringByAppendingString:@": No services"]);
    return FALSE;
  }

  [MSAppCenter start:secret withServices:services];

  isStarted = TRUE;

  return TRUE;
}

@end
