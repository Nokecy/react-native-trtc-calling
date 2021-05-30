//
//  TRTCCallingManager.m
//  ACM
//
//  Created by 黎剑锋 on 2020/12/9.
//

#import "TrtcCallingManage.h"

@implementation TrtcCallingManager

RCT_EXPORT_MODULE();

-(NSArray<NSString *> *)supportedEvents{
  NSArray<NSString*>* array = @[
      @"onError",
            @"onInvited",
            @"onGroupCallInviteeListUpdate",
            @"onUserEnter",
            @"onUserLeave",
            @"onUserAudioAvailable",
            @"onUserVoiceVolume",
            @"onReject",
            @"onNoResp",
            @"onLineBusy",
            @"onCallingCancel",
            @"onCallingTimeOut",
            @"onCallEnd",
  ];
  return array;
}

RCT_EXPORT_METHOD(init:(int)imBusinessID deviceToken:(NSArray*)deviceToken)
{
  unsigned long c = [deviceToken count];
  uint8_t *bytes = malloc(sizeof(*bytes) * c);
  
  unsigned i;
  for (i = 0; i < c; i++)
  {
      NSNumber *number = [deviceToken objectAtIndex:i];
      int byte = [number intValue];
      bytes[i] = byte;
  }
  NSData *dataMessage = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
  
  [TRTCCalling shareInstance].imBusinessID = imBusinessID;
  [TRTCCalling shareInstance].deviceToken = dataMessage;
}

RCT_EXPORT_METHOD(login:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
 int sdkAppId = [options[@"sdkAppId"] intValue];
 NSString* userId = options[@"userId"];
 NSString* userSig = options[@"userSig"];
  
  [[TRTCCalling shareInstance] login:sdkAppId user:userId userSig:userSig success:^{
    resolve(@"");
  } failed:^(int code, NSString * _Nonnull des) {
    reject(@"",@"",nil);
  }];
  
  [[TRTCCalling shareInstance] addDelegate:self];
}

RCT_EXPORT_METHOD(logout:(NSDictionary *)options)
{
  [[TRTCCalling shareInstance] logout:^{
    
  } failed:^(int code, NSString * _Nonnull des) {
    
  }];
}

RCT_EXPORT_METHOD(call:(NSDictionary *)options)
{
  NSString* userId = options[@"userId"];
  int callType = [options[@"callType"] intValue];
  
  [[TRTCCalling shareInstance] call:userId type:callType];
}

//进入房间
RCT_EXPORT_METHOD(startLocalAudio)
{
  [[TRTCCalling shareInstance] startLocalAudio];
}

//接受会话
RCT_EXPORT_METHOD(accept)
{
  [[TRTCCalling shareInstance] accept];
}

//挂断会话
RCT_EXPORT_METHOD(hangup)
{
  [[TRTCCalling shareInstance] hangup];
}

//拒绝会话
RCT_EXPORT_METHOD(reject)
{
  [[TRTCCalling shareInstance] reject];
}

//拒绝会话
RCT_EXPORT_METHOD(setMicMute:(BOOL)isMicMute)
{
  [[TRTCCalling shareInstance] setMicMute:isMicMute];
}

//拒绝会话
RCT_EXPORT_METHOD(setHandsFree:(BOOL)isHandsFree)
{
  [[TRTCCalling shareInstance] setHandsFree:isHandsFree];
}


// 接听/拒绝
// 此时 B 如果也登录了IM系统，会收到 onInvited(A, null, false) 回调
// 可以调用 TRTCCalling的accept方法接受 / TRTCCalling的reject 方法拒绝
-(void)onInvited:(NSString *)sponsor userIds:(NSArray<NSString *> *)userIds isFromGroup:(BOOL)isFromGroup callType:(CallType)callType {
  [self sendEventWithName:@"onInvited" body:@{
    @"sponsor": sponsor,
    @"userIds": userIds,
    @"isFromGroup": @(isFromGroup),
    @"callType": @(callType)
  }
   ];
}

//观看对方的画面
// 由于 A 打开了摄像头，B 接受通话后会收到 onUserVideoAvailable(A, true) 回调
- (void)onUserVideoAvailable:(NSString *)uid available:(BOOL)available {
  if (available) {
    UIView* renderView =[[UIView alloc] init];
    [[TRTCCalling shareInstance] startRemoteView:uid view:renderView]; // 就可以看到对方的画面了
  } else {
    [[TRTCCalling shareInstance] stopRemoteView:uid]; // 停止渲染画面
  }
}

/// sdk内部发生了错误 | sdk error
-(void)onError:(int)code msg:(NSString * _Nullable)msg{
  [self sendEventWithName:@"onError" body:@{@"msg": msg}];
}

/// 群聊更新邀请列表回调 | update current inviteeList in group calling
/// - Parameter userIds: 邀请列表 | inviteeList
-(void)onGroupCallInviteeListUpdate:(NSArray *)userIds{
  [self sendEventWithName:@"onGroupCallInviteeListUpdate" body:@{@"userIds": userIds == nil ? [NSNull null] : userIds}];
}

/// 进入通话回调 | user enter room callback
/// - Parameter uid: userid
-(void)onUserEnter:(NSString *)uid{
  [self sendEventWithName:@"onUserEnter" body:@{@"uid": uid}];
}

/// 离开通话回调 | user leave room callback
/// - Parameter uid: userid
-(void)onUserLeave:(NSString *)uid{
    [self sendEventWithName:@"onUserLeave" body:@{@"uid": uid}];
}

/// 用户是否开启音频上行回调 | is user audio available callback
/// - Parameters:
///   - uid: 用户ID | userID
///   - available: 是否有效 | available
-(void)onUserAudioAvailable:(NSString *)uid available:(BOOL)available{
      [self sendEventWithName:@"onUserAudioAvailable" body:@{@"uid": uid,@"available": @(available)}];
}

/// 用户音量回调
/// - Parameter uid: 用户ID | userID
/// - Parameter volume: 说话者的音量, 取值范围0 - 100
-(void)onUserVoiceVolume:(NSString *)uid volume:(UInt32)volume{
  [self sendEventWithName:@"onUserVoiceVolume" body:@{@"uid": uid,@"volume":@(volume)}];
}

/// 拒绝通话回调-仅邀请者受到通知，其他用户应使用 onUserEnter |
/// reject callback only worked for Sponsor, others should use onUserEnter)
/// - Parameter uid: userid
-(void)onReject:(NSString *)uid{
    [self sendEventWithName:@"onReject" body:@{@"uid": uid}];
}

/// 无回应回调-仅邀请者受到通知，其他用户应使用 onUserEnter |
/// no response callback only worked for Sponsor, others should use onUserEnter)
/// - Parameter uid: userid
-(void)onNoResp:(NSString *)uid{
    [self sendEventWithName:@"onNoResp" body:@{@"uid": uid}];
}

/// 通话占线回调-仅邀请者受到通知，其他用户应使用 onUserEnter |
/// linebusy callback only worked for Sponsor, others should use onUserEnter
/// - Parameter uid: userid
-(void)onLineBusy:(NSString *)uid{
    [self sendEventWithName:@"onLineBusy" body:@{@"uid": uid}];
}

/// 当前通话被取消回调 | current call had been canceled callback
-(void)onCallingCancel:(NSString *)uid{
        [self sendEventWithName:@"onCallingCancel" body:@{@"uid": uid}];
}

-(void)onCallingTimeOut{
      [self sendEventWithName:@"onCallingTimeOut" body:nil];
}

-(void)onCallEnd{
        [self sendEventWithName:@"onCallEnd" body:nil];
}
@end
