//
//  LobbyViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
var menu = [FOOD]()
class ListTableViewController: UIViewController {
    //MARK: IBOUTLETS
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnReserve: UIButton!
    @IBOutlet weak var btnServing: UIButton!
    //MARK: OTHER VARIABLES
    var idLobby = ""
    var LobbyVM = LobbyViewModel()
    var listTb = [Table]()
    var listTableFree:[Table] = []
    var listTableReserve:[Table] = []
    var listTableServing:[Table] = []
    var listTableDisplay:[Table] = []
    
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupVar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        setupVar()
        callAPI()
        SocketHandler.shared.socket.on("refreshTable") { (data, ack) in
            self.setupVar()
        }
        
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        self.LobbyVM.idLobby = idLobby
        FreeBtns()
        self.LobbyVM.GetTableInLobby { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                self.listTableFree = []
                self.listTableReserve = []
                self.listTableServing = []
                self.listTb = model.data
                for i in self.listTb {
                    switch i.STATE {
                    case "1":
                        self.listTableFree.append(i)
                    case "2":
                        self.listTableReserve.append(i)
                    case "3":
                        self.listTableServing.append(i)
                    default:
                        do {
                            
                        }
                    }
                }
                self.listTableDisplay = self.listTableFree
                self.btnFree.isSelected = true
                self.tblView.reloadData()
            }
        }
        
        
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        
    }
    // func
    
    func FreeBtns(){
        btnFree.isSelected = false
        btnReserve.isSelected = false
        btnServing.isSelected = false
    }
    func ShowTbl(_ arr:[Table], btn:UIButton){
        FreeBtns()
        btn.isSelected = true
        listTableDisplay = arr
        tblView.reloadData()
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func ShowFreeTbl(_ sender: UIButton) {
        ShowTbl(listTableFree, btn: sender)
        
    }
    @IBAction func showReserveTbl(_ sender: UIButton) {
        ShowTbl(listTableReserve, btn: sender)
    }
    @IBAction func showServingTbl(_ sender: UIButton) {
        ShowTbl(listTableServing, btn: sender)
    }

}
extension ListTableViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTableDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        cell.bindData(listTableDisplay[indexPath.row].NAME)
         return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteReserved =  UIContextualAction(style: .normal, title: nil, handler: { (action,view,completionHandler ) in
            //do stuff
            completionHandler(true)
            SocketHandler.shared.socket.emit("deleteReserved", self.listTableDisplay[indexPath.row].ID)
        })
        let deleteServing =  UIContextualAction(style: .normal, title: nil, handler: { (action,view,completionHandler ) in
            //do stuff
            completionHandler(true)
            SocketHandler.shared.socket.emit("deleteServing", self.listTableDisplay[indexPath.row].ID)
        })
        let order =  UIContextualAction(style: .normal, title: nil, handler: { (action,view,completionHandler ) in
            //do stuff
            completionHandler(true)
            let MakeOrderVC = Main_Storyboard.instantiateViewController(withIdentifier: "MakeOrderViewController") as! MakeOrderViewController
            MakeOrderVC.idTable = self.listTableDisplay[indexPath.row].ID
            self.navigationController?.pushViewController(MakeOrderVC, animated: true)
        })
        deleteReserved.image = UIImage(named: "bin")
        deleteReserved.backgroundColor = .red
        deleteServing.image = UIImage(named: "bin")
        deleteServing.backgroundColor = .red
        order.image = #imageLiteral(resourceName: "order")
        order.backgroundColor = .green
        let reserved = UISwipeActionsConfiguration(actions: [order ,deleteReserved])
        let empty = UISwipeActionsConfiguration(actions: [order ])
        let serving = UISwipeActionsConfiguration(actions: [deleteServing ])
        if btnFree.isSelected == true {
            return empty
        } else if btnReserve.isSelected == true {
            return reserved
        } else {
            return serving
        }
   
    }
}
