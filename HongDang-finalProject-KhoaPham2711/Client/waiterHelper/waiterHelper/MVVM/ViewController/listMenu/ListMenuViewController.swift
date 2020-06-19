//
//  ListMenuViewController.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
protocol DisplayViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(data: [ORDER])
}
var MenuVM = MenuViewModel()
class ListMenuViewController: UIViewController {
    //MARK: IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    //MARK: OTHER VARIABLES
    weak var delegate : DisplayViewControllerDelegate?
    var idTable:String?
    
    
    var khaivi:[ORDER] = []
    var monchinh:[ORDER] = []
    var trangmieng:[ORDER] = []
    var thucuong:[ORDER] = []
    var display:[ORDER] = []
    //MARK: VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeleft.direction = .left
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swiperight.direction = .right
        view.addGestureRecognizer(swipeleft)
        view.addGestureRecognizer(swiperight)
        setupUI()
        setupVar()
        callAPI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idToScroll = 1
    }
    
    
    //MARK: - SETUP VAR
    func setupVar() {
        for i in menu {
            let temp = ORDER(idTable: self.idTable!, idFood: i.ID, name: i.NAME, quantity: 0)
            switch i.IDCATE {
            case "1":
                self.khaivi.append(temp)
            case "2":
                self.monchinh.append(temp)
            case "3":
                self.trangmieng.append(temp)
            default:
                self.thucuong.append(temp)
            }
        }
        self.display = self.khaivi
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItems = [done]
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
        
    }
    
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        
    }
    
    
    
    
    //MARK: - BUTTON ACTIONS
    @objc func doneTapped(sender: AnyObject){
        var listChosen:[ORDER] = []
        let listfilter = khaivi + monchinh + trangmieng + thucuong
        for i in listfilter {
            if i.quantity > 0 {
                listChosen.append(i)
            }
        }
        self.delegate?.doSomethingWith(data: listChosen)
        navigationController?.popViewController(animated: true)
    }
    @objc func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if idToScroll < 4 {
            idToScroll += 1

            switch idToScroll {
            case 1:
                self.display = self.khaivi
            case 2:
                self.display = self.monchinh
            case 3:
                self.display = self.trangmieng
            default:
                self.display = self.thucuong
            }
            tableView.reloadData()
            
        }
        
    }
    @objc func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if idToScroll > 1 {
            idToScroll -= 1

            switch idToScroll {
            case 1:
                self.display = self.khaivi
            case 2:
                self.display = self.monchinh
            case 3:
                self.display = self.trangmieng
            default:
                self.display = self.thucuong
            }
            tableView.reloadData()
            
        }
        
    }
    
}
extension ListMenuViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.didChangeCategory = { (id) in
            idToScroll = Int(id)!
            print(idToScroll)
            switch id {
            case "1":
                self.display = self.khaivi
            case "2":
                self.display = self.monchinh
            case "3":
                self.display = self.trangmieng
            default:
                self.display = self.thucuong
            }
            tableView.reloadData()
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.bindData(display[indexPath.row].idFood, display[indexPath.row].name, display[indexPath.row].quantity)
//        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
//        swipeleft.direction = .left
//        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
//        swiperight.direction = .right
//        cell.addGestureRecognizer(swipeleft)
//        cell.addGestureRecognizer(swiperight)
        cell.didChangeQuantity = { (sl,id) in
            
            if let row = self.khaivi.firstIndex(where: {$0.idFood == id}) {
                self.khaivi[row].quantity = sl
                self.display = self.khaivi
            }
            if let row = self.monchinh.firstIndex(where: {$0.idFood == id}) {
                self.monchinh[row].quantity = sl
                self.display = self.monchinh
                
            }
            if let row = self.trangmieng.firstIndex(where: {$0.idFood == id}) {
                self.trangmieng[row].quantity = sl
                self.display = self.trangmieng
            }
            if let row = self.thucuong.firstIndex(where: {$0.idFood == id}) {
                self.thucuong[row].quantity = sl
                self.display = self.thucuong
            }
            tableView.reloadData()
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
}
