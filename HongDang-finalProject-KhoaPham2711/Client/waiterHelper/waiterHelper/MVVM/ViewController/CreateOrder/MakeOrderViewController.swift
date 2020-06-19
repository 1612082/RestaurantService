//
//  MakeOrderViewController.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
import SocketIO

class MakeOrderViewController: UIViewController, DisplayViewControllerDelegate {
    //MARK: IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    //MARK: OTHER VARIABLES
    var listOrder = [ORDER]()
    var idTable:String?
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupUI()
        setupVar()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "makeOrderVCtoMenuVC"){
            let menuVC = segue.destination as! ListMenuViewController
            menuVC.idTable = idTable
            menuVC.delegate = self
        }
    }
    //MARK: - SETUP VAR
    func setupVar() {
        
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.title = "Table \(idTable!)"
    }
    //MARK: - BUTTON ACTIONS
    @objc func addTapped(sender: AnyObject){
//        let menuVC = Main_Storyboard.instantiateViewController(withIdentifier: "ListMenuViewController") as! ListMenuViewController
//        menuVC.idTable = idTable
//        self.navigationController?.pushViewController(menuVC, animated: true)
        self.performSegue(withIdentifier: "makeOrderVCtoMenuVC", sender: self)
    }
    @IBAction func Done(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle:   .alert)
        for i in ["Done", "Not yet"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: sendOrder))
        }
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - FUNCTIONS
    func doSomethingWith(data: [ORDER]) {
        for i in data{
            let index = listOrder.firstIndex(where: { $0.idFood == i.idFood })
            
            if index == nil {
                listOrder.append(i)
            } else {
                listOrder[index!].quantity += i.quantity
            }
        }
        tableView.reloadData()
    }
    func sendOrder(action: UIAlertAction) {
        if action.title! == "Done" {
            let data = convertToDictionary(listOrder)
            SocketHandler.shared.socket.emit("sendOrder",  data)
            SocketHandler.shared.socket.emit("changeStateTable",  idTable!)
            listOrder = []
            navigationController?.popViewController(animated: false)
        }
        else {
            
        }
    }
    func convertToDictionary(_ input:[ORDER]) -> [[String:Any]]{
        var dict:[String:Any] = [:]
        var arrDict = [dict]
        for i in input{
            dict = ["idTable":i.idTable, "idFood":i.idFood, "name":i.name, "quantity":i.quantity]
            arrDict.append(dict)
        }
        arrDict.remove(at: 0)
        return arrDict
    }
    


}
extension MakeOrderViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.bindData(listOrder[indexPath.row].idFood, listOrder[indexPath.row].name, "\(listOrder[indexPath.row].quantity)")
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "DELETE") { (action, indexPath) in
            self.listOrder.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        return [delete]
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

