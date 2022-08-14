//
//  ViewController.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 02.08.2022.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        view.backgroundColor = #colorLiteral(red: 0.9296012169, green: 0.9544633575, blue: 1, alpha: 1)
    }
    
    
    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
    

}

