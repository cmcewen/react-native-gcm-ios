//
//  RNGcmIOS.h
//  RNGcmIOS
//
//  Created by Connor McEwen on 4/26/16.
//  Copyright © 2016 Connor McEwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/CloudMessaging.h>
#import "RCTBridgeModule.h"

@interface RNGcmIOS : NSObject <GGLInstanceIDDelegate, RCTBridgeModule>

- (void)onTokenRefresh;

@end
