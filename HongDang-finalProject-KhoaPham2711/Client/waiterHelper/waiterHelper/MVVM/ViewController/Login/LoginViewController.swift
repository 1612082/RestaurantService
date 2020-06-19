//
//  LoginViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK: OTHER VARIABLES
    let loginViewModel = LoginViewModel()
    var currentUser:Employee? = nil
    
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        setupVar()
        callAPI()
        
        
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        self.loginViewModel.token = UserDefaults.standard.string(forKey: "token") ?? "ko co token"
//        print("token;", self.loginViewModel.token)
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        
    }
    
    //MARK: - CALL API
    func callAPI() {
        checkToken()
        fillData()
    }
    //API
    func checkToken(){
        self.loginViewModel.CheckToken { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                self.currentUser = model.data.first
                DispatchQueue.main.async {
                    // chuyen vao man hinh home
                    let scene = self.view.window?.windowScene?.delegate as! SceneDelegate
                    scene.GoToTabbar()
                }

            }
        }
    }
    func login(){
        
        self.loginViewModel.Login { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                //lay token va luu token
                UserDefaults.standard.set(model.token, forKey: "token")
                self.currentUser = model.data.first
                
                DispatchQueue.main.async {
                    // chuyen vao man hinh home
                    let scene = self.view.window?.windowScene?.delegate as! SceneDelegate
                    scene.GoToTabbar()
                    
                }

            }
        }
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        
    }
    
    //MARK: - BUTTON ACTIONS

    @IBAction func didTapLogin(_ sender: Any) {
        self.loginViewModel.email = tfEmail.text!
        self.loginViewModel.pass = tfPassword.text!
        login()
    }
    
}
