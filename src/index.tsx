import { NativeModules, NativeEventEmitter } from 'react-native';
const { TRTCCallingManager } = NativeModules;
const TRTCCallingEventEmitter = new NativeEventEmitter(TRTCCallingManager);

export { TRTCCallingManager, TRTCCallingEventEmitter };

export default class TRTCCallingNative {
  static genTestUserSig(userId: string): Promise<any> {
    return TRTCCallingManager.genTestUserSig(userId);
  }

  static init(imBusinessID: string, deviceToken: string) {
    TRTCCallingManager.init(imBusinessID, deviceToken);
  }

  static login(options: { sdkAppId: number; userId: string; userSig: string }) {
    return TRTCCallingManager.login(options);
  }

  static logout() {
    TRTCCallingManager.logout();
  }

  static call(options: { userId: string; callType: number }) {
    TRTCCallingManager.call(options);
  }

  static startLocalAudio() {
    TRTCCallingManager.startLocalAudio();
  }

  static accept() {
    TRTCCallingManager.accept();
  }

  static hangup() {
    TRTCCallingManager.hangup();
  }

  static reject() {
    TRTCCallingManager.reject();
  }

  static setMicMute(isMicMute: boolean) {
    TRTCCallingManager.setMicMute(isMicMute);
  }

  static setHandsFree(isHandsFree: boolean) {
    TRTCCallingManager.setHandsFree(isHandsFree);
  }
}
