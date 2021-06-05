package com.nokecy.trtccalling;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.List;
import java.util.Map;

public class TRTCCallingModule extends ReactContextBaseJavaModule implements TRTCCallingDelegate {
  private static ReactApplicationContext reactContext;

  public TRTCCallingModule(ReactApplicationContext context) {
    super(context);
    reactContext = context;
  }

  private void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }

  @NonNull
  @Override
  public String getName() {
    return "TrtcCallingManager";
  }

  @ReactMethod
  public void init(int imBusinessID, ReadableArray deviceToken, Promise promise) {
    promise.resolve("");
  }

  @ReactMethod
  public void login(ReadableMap options, Promise promise) {
    int sdkAppId = options.getInt("sdkAppId");
    String userId = options.getString("userId");
    String userSig = options.getString("userSig");

    TRTCCalling.sharedInstance(reactContext).addDelegate(this);

    TRTCCalling.sharedInstance(reactContext).login(sdkAppId, userId, userSig, new TRTCCalling.ActionCallBack() {
      @Override
      public void onError(int code, String msg) {
        promise.reject(code + "", msg);
      }

      @Override
      public void onSuccess() {
        promise.resolve("");
      }
    });
  }

  @ReactMethod
  public void logout(Promise promise) {
    TRTCCalling.sharedInstance(reactContext).logout(new TRTCCalling.ActionCallBack() {
      @Override
      public void onError(int code, String msg) {
        promise.reject(code + "", msg);
      }

      @Override
      public void onSuccess() {
        promise.resolve("");
      }
    });
  }

  @ReactMethod
  public void call(ReadableMap options) {
    String userId = options.getString("userId");
    int callType = options.getInt("callType");

    TRTCCalling.sharedInstance(reactContext).call(userId, callType);
  }

  @ReactMethod
  public void startLocalAudio() {
//    TRTCCalling.sharedInstance(reactContext)();
  }

  @ReactMethod
  public void accept() {
    TRTCCalling.sharedInstance(reactContext).accept();
  }

  @ReactMethod
  public void hangup() {
    TRTCCalling.sharedInstance(reactContext).hangup();
  }

  @ReactMethod
  public void reject() {
    TRTCCalling.sharedInstance(reactContext).reject();
  }

  @ReactMethod
  public void setMicMute(boolean isMicMute) {
    TRTCCalling.sharedInstance(reactContext).setMicMute(isMicMute);
  }

  @ReactMethod
  public void setHandsFree(boolean isHandsFree) {
    TRTCCalling.sharedInstance(reactContext).setHandsFree(isHandsFree);
  }

  @Override
  public void onError(int code, String msg) {
    WritableMap map = Arguments.createMap();
    map.putInt("code", code);
    map.putString("message", msg);
    sendEvent(reactContext, "onError", map);
  }

  @Override
  public void onInvited(String sponsor, List<String> userIdList, boolean isFromGroup, int callType) {
    WritableMap map = Arguments.createMap();
    map.putString("sponsor", sponsor);
    map.putArray("userIdList", Arguments.fromArray(userIdList));
    map.putBoolean("isFromGroup", isFromGroup);
    map.putInt("callType", callType);
    sendEvent(reactContext, "onInvited", map);
  }

  @Override
  public void onGroupCallInviteeListUpdate(List<String> userIdList) {
    WritableMap map = Arguments.createMap();
    map.putArray("userIds", Arguments.fromArray(userIdList));
    sendEvent(reactContext, "onGroupCallInviteeListUpdate", map);
  }

  @Override
  public void onUserEnter(String userId) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    sendEvent(reactContext, "onUserEnter", map);
  }

  @Override
  public void onUserLeave(String userId) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    sendEvent(reactContext, "onUserLeave", map);
  }

  @Override
  public void onReject(String userId) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    sendEvent(reactContext, "onReject", map);
  }

  @Override
  public void onNoResp(String userId) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    sendEvent(reactContext, "onNoResp", map);
  }

  @Override
  public void onLineBusy(String userId) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    sendEvent(reactContext, "onLineBusy", map);
  }

  @Override
  public void onCallingCancel() {
    WritableMap map = Arguments.createMap();
    sendEvent(reactContext, "onCallingCancel", map);
  }

  @Override
  public void onCallingTimeout() {
    WritableMap map = Arguments.createMap();
    sendEvent(reactContext, "onCallingTimeout", map);
  }

  @Override
  public void onCallEnd() {
    WritableMap map = Arguments.createMap();
    sendEvent(reactContext, "onCallEnd", map);
  }

  @Override
  public void onUserVideoAvailable(String userId, boolean isVideoAvailable) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    map.putBoolean("isVideoAvailable", isVideoAvailable);
    sendEvent(reactContext, "onUserVideoAvailable", map);
  }

  @Override
  public void onUserAudioAvailable(String userId, boolean isVideoAvailable) {
    WritableMap map = Arguments.createMap();
    map.putString("uid", userId);
    map.putBoolean("isVideoAvailable", isVideoAvailable);
    sendEvent(reactContext, "onUserAudioAvailable", map);
  }

  @Override
  public void onUserVoiceVolume(Map<String, Integer> volumeMap) {
    WritableMap map = Arguments.createMap();
    sendEvent(reactContext, "onUserVoiceVolume", map);
  }
}
