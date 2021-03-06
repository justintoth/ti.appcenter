//
//  TiAppCenterCrashes.h
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "TiProxy.h"
#import <Foundation/Foundation.h>

@interface RuNetrisMobileAppcenterCrashesProxy : TiProxy {
}

- (NSString *)getApiName;
- (void)lastSessionCrashReport:(id)arguments;
- (void)hasCrashedInLastSession:(id)arguments;
- (void)setEnabled:(id)arguments;
- (void)isEnabled:(id)arguments;
- (void)generateTestCrash:(id)arguments;
- (void)notifyWithUserConfirmation:(id)arguments;

@property (nonatomic, readonly) NSString *DONT_SEND;
@property (nonatomic, readonly) NSString *SEND;
@property (nonatomic, readonly) NSString *ALWAYS_SEND;

@end
