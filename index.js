
import { NativeModules } from 'react-native';

const { RNSocialManagerModules } = NativeModules;

export default class RNSocialManager {

    static share(params, succeed, failed) {
        RNSocialManagerModules.shareToWeixin(params, succeed, failed)
    }

};
