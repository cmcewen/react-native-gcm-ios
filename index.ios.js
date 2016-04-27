import {
  NativeAppEventEmitter,
  NativeModules,
  PushNotificationIOS,
} from 'react-native';

const RNGcmIOS = NativeModules.RNGcmIOS;

const RNGcmRegistered = "RNGcmRegistered";
const RNGcmRegistrationFailed = "RNGcmRegistrationFailed";

let _listeners = new Map();
let _registerListenersCount = 0;

class GcmIOS {
  static addListener(type: string, handler: Function) {
    if (!(type === 'register' || type === 'error')) throw new Error('GcmIOS listener type must either be register or error')

    let listener;
    if (type === 'register') {
      if (_registerListenersCount == 0) {
        PushNotificationIOS.addEventListener('register', GcmIOS.registerToken)
      }
      _registerListenersCount++;

      listener = NativeAppEventEmitter.addListener(
        RNGcmRegistered,
        (gcmToken) => {
          handler(gcmToken.registrationToken);
        }
      );
    } else {
      listener = NativeAppEventEmitter.addListener(
        RNGcmRegistrationFailed,
        (error) => {
          handler(error.error);
        }
      );
    }
    _listeners.set(handler, listener);
  }

  static removeListener(type: string, handler: Function) {
    if (!(type === 'register' || type === 'error')) throw new Error('GcmIOS listener type must either be register or error')

    let listener = _listeners.get(handler);
    if (!listener) {
      return;
    }
    if (type === 'register') {
      _registerListenersCount--;
      if (_registerListenersCount === 0) {
        PushNotificationIOS.removeEventListener('register', GcmIOS.registerToken)
      }
    }
    listener.remove();
    _listeners.delete(handler);
  }

  static registerToken(token) {
    RNGcmIOS.registerToken(token)
  }
}

export default GcmIOS