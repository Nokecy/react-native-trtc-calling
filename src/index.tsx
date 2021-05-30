import { NativeModules, NativeEventEmitter } from 'react-native';
const { TrtcCallingManager } = NativeModules;
const TRTCCallingEventEmitter = new NativeEventEmitter(TrtcCallingManager);

export { TrtcCallingManager, TRTCCallingEventEmitter };

export default class TRTCCallingNative {
  static genTestUserSig(userId: string): Promise<any> {
    return TrtcCallingManager.genTestUserSig(userId);
  }

  static init(imBusinessID: string, deviceToken: string) {
    TrtcCallingManager.init(imBusinessID, deviceToken);
  }

  static login(options: { sdkAppId: number; userId: string; userSig: string }) {
    return TrtcCallingManager.login(options);
  }

  static logout() {
    TrtcCallingManager.logout();
  }

  static call(options: { userId: string; callType: number }) {
    TrtcCallingManager.call(options);
  }

  static startLocalAudio() {
    TrtcCallingManager.startLocalAudio();
  }

  static accept() {
    TrtcCallingManager.accept();
  }

  static hangup() {
    TrtcCallingManager.hangup();
  }

  static reject() {
    TrtcCallingManager.reject();
  }

  static setMicMute(isMicMute: boolean) {
    TrtcCallingManager.setMicMute(isMicMute);
  }

  static setHandsFree(isHandsFree: boolean) {
    TrtcCallingManager.setHandsFree(isHandsFree);
  }
}
