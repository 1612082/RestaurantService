//
//  LobbyViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/21/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
import SocketIO

class LobbyViewController: UIViewController {
    //MARK: IBOUTLETS
    @IBOutlet weak var tblView: UITableView!

    let userimage = UIImageView(image: UIImage(named: "logout"))
   //MARK: OTHER VARIABLES
    var listLobby:[Lobbys] = []
    let LobbyVM = LobbyViewModel()
    
    
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
        SocketHandler.shared.socket.connect()
        
    }
    
    
    //MARK: - SETUP VAR
    func setupVar() {
//        listLobby = [
//            Lobby(idLobby: "Normal", listTableReserve: [], listTableServing: [], listTableDisplay: [])
//        ]
        LobbyVM.GetLobby { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                self.listLobby = model.data
                self.tblView.reloadData()
                
            }
        }
    }
    
    //MARK: - SETUP UI
    func setupUI() {

        let accountButton   = UIBarButtonItem(image: userimage.image, style: .plain, target: self, action: #selector(didTapLogoutBtn))
        
        navigationItem.rightBarButtonItem = accountButton
        navigationItem.title = "LOBBY"
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        getMenu()
    }
    func getMenu(){
            MenuVM.GetMenu { (model) in
                guard let model = model else {
                    return
                }
                if model.result == true {
                    menu = model.data
                    
                }
            }
        }
    //MARK: - BUTTON ACTIONS
    
    @objc func didTapLogoutBtn(sender: AnyObject){
        UserDefaults.standard.set("", forKey: "token")
        DispatchQueue.main.async {
            // chuyen vao man hinh home
            let scene = self.view.window?.windowScene?.delegate as! SceneDelegate
            scene.GoToLogin()
        }
    }
    
    
}

extension LobbyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLobby.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "LoobyCell", for: indexPath) as! LoobyCell
        cell.bindData(listLobby[indexPath.row].NAME)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List Lobby"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listTblVC = Main_Storyboard.instantiateViewController(withIdentifier: "ListTableViewController") as! ListTableViewController
       listTblVC.idLobby = listLobby[indexPath.row].ID
        
        navigationController?.pushViewController(listTblVC, animated: true)
    }
}

