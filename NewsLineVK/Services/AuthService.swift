//
//  AuthService.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 02.08.2022.
//

import Foundation
import VK_ios_sdk


protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appID = "8233830"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appID)
        super.init()
        //print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self //подписываем объект под выполнение протоколов Делегата
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"] //массив прав доступа
        VKSdk.wakeUpSession(scope) { [delegate] status, error in
            switch status {
                case .initialized:
                    print("initialized")
                    VKSdk.authorize(scope)
                case .authorized:
                    print("authorized")
                    delegate?.authServiceSignIn()
                default:
                    delegate?.authServiceSignInDidFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
