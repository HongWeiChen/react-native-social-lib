
import { NativeModules } from 'react-native';

const SocialModules = NativeModules.RNSocialManager;

export default class SocialManager {

    static shareToWeixin(params, succeed, failed) {
        SocialModules.shareToWeixin(params, succeed, failed)
    }

};
