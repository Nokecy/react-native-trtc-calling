//
//  TRTCCallingManager.h
//  ACM
//
//  Created by 黎剑锋 on 2020/12/9.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "TRTCCalling/TRTCCalling.h"
#import "TRTCCalling/TRTCCallingDelegate.h"

@interface TrtcCallingManager : RCTEventEmitter<RCTBridgeModule, TRTCCallingDelegate>

@end
