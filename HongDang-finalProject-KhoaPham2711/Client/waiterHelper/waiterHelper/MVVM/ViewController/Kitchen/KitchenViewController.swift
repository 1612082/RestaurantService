//
//  OrderViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
import  SocketIO

class KitchenViewController: UIViewController {
    //MARK: IBOUTLETS
    @IBOutlet weak var tableView: UITableView!

    
    
    //MARK: OTHER VARIABLES
    let OrderVM = OrderViewModel()
    var listOrder = [OrderFromServer]()
    var starter = [OrderFromServer]()
    var main = [OrderFromServer]()
    var dessert = [OrderFromServer]()
    var beverage = [OrderFromServer]()
    var hour,minute,seconds:Int?
    
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
        SocketHandler.shared.socket.on("refreshOrder") { (data, ack) in
            guard let result = data[0] as? String else {return}
            if result == "true" {
                self.getOrder()
            }
        }
        
        SocketHandler.shared.socket.on("refreshMinute") { (data, ack) in
            guard let result = data[0] as? String else {return}
            if result == "true" {
                self.getOrder()

            }
        }
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        
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
        getOrder()
    }
    // FUNCTION
    func getOrder() {
        OrderVM.GetOrder { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                self.starter = []
                self.main = []
                self.dessert = []
                self.beverage = []
                self.listOrder = model.data
                for i in self.listOrder{
                    for j in menu {
                        if i.IDFOOD == j.ID {
                            switch j.IDCATE {
                            case "1":
                                self.starter.append(i)
                            case "2":
                                self.main.append(i)
                            case "3":
                                self.dessert.append(i)
                            default:
                                self.beverage.append(i)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    //MARK: - BUTTON ACTIONS

}
extension KitchenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return starter.count
        case 2:
            return main.count
        case 3:
            return dessert.count
        default:
            return beverage.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: break
        case 1:
            return "Stater"
        case 2:
            return "Main Course"
        case 3:
            return "Dessert"
        default:
            return "Beverages"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderKitchenCell", for: indexPath) as! OrderKitchenCell
            var display = [OrderFromServer]()
            switch indexPath.section {
            case 1:
                display = starter
            case 2:
                display = main
            case 3:
                display = dessert
            default:
                display = beverage
            }
            let timeWait = KitchenViewModel.shared.getTimeWait(display[indexPath.row])
            if display[indexPath.row].SERVING {
                cell.bindData(display[indexPath.row].IDTABLE, display[indexPath.row].IDFOOD, display[indexPath.row].NAME, display[indexPath.row].QUANTITY, timeWait, .systemTeal)
            }else{
                cell.bindData(display[indexPath.row].IDTABLE, display[indexPath.row].IDFOOD, display[indexPath.row].NAME, display[indexPath.row].QUANTITY, timeWait, .white)
            }
            return cell
        }
        
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .default, title: "DONE") { (action, indexPath) in
            var display = [OrderFromServer]()
            switch indexPath.section {
            case 1:
                display = self.starter
            case 2:
                display = self.main
            case 3:
                display = self.dessert
            default:
                display = self.beverage
            }
            SocketHandler.shared.socket.emit("changeStateServing", ["ID":display[indexPath.row].ID,"IDTABLE":display[indexPath.row].IDTABLE])
            self.tableView.reloadData()
        }
        return [done]
    }
    
    
}
