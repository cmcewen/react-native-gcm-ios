//
//  RNGcmIOS.m
//  RNGcmIOS
//
//  Created by Connor McEwen on 4/26/16.
//  Copyright © 2016 Connor McEwen. All rights reserved.
//

#import "RNGcmIOS.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"

@interface RNGcmIOS()

@property(nonatomic, strong) void (^registrationHandler)(NSString *registrationToken, NSError *error);
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;
@property(nonatomic, readonly, strong) NSString *registrationKey;

@end

NSString *const RNGcmRegistered = @"RNGcmRegistered";
NSString *const RNGcmRegistrationFailed = @"RNGcmRegistrationFailed";

@implementation RNGcmIOS

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

- (void)setBridge:(RCTBridge *)bridge
{
    _bridge = bridge;
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    if (configureError) {
        RCTLogError([NSString stringWithFormat:@"[RNGcmIOS] Error configuring Google services: %@", configureError.localizedDescription]);
    }
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    
    GGLInstanceIDConfig *instanceIDConfig = [GGLInstanceIDConfig defaultConfig];
    instanceIDConfig.delegate = self;
    [[GGLInstanceID sharedInstance] startWithConfig:instanceIDConfig];
    
    __weak typeof(self) weakSelf = self;
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        [weakSelf handleRegistration:registrationToken withError:error];
    };
}

RCT_EXPORT_METHOD(registerToken:(NSString *)deviceToken) {
    NSData* deviceTokenData = [self dataByIntepretingHexString:deviceToken];
    [self didRegisterForRemoteNotificationsWithDeviceToken:deviceTokenData];
}

- (NSData*)dataByIntepretingHexString:(NSString *)string {
    
    NSString* hexString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [hexString length]/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

-(void)handleRegistration:(NSString*)registrationToken withError:(NSError*)error {
    if (registrationToken != nil) {
        [_bridge.eventDispatcher sendAppEventWithName:RNGcmRegistered
                                                 body:@{@"registrationToken": registrationToken}];
    } else {
        [_bridge.eventDispatcher sendAppEventWithName:RNGcmRegistrationFailed
                                                 body:@{@"error": error.localizedDescription}];
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
#ifdef DEBUG
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
#else
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@NO};
#endif
    
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}

- (void)onTokenRefresh {
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}

@end
