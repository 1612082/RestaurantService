//
//  ResevationViewController.swift
//  waiterHelper
//
//  Created by HongDang on 3/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class ResevationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
   //MARK: IBOUTLETS
    
    //MARK: OTHER VARIABLES
    var ReservationVM  = ReservationViewModel()
    var listReser = [RESERVATION]()
    var filteredData = [RESERVATION]()
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
        
        SocketHandler.shared.socket.on("refreshReservation") { (data, ack) in
            self.callAPI()
        }
        // kiem tra xem toi gio chuan bi ban dat truoc chua
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (timer) in
            for i in self.listReser {
                if ReservationViewModel.shared.checkTimeReserved(i) && i.INTIME == false{
                    SocketHandler.shared.socket.emit("setIntime", i.ID)
                }
            }
        }
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.title = "Reservation"
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        ReservationVM.GetReservation { (model) in
            guard let model = model else {return}
            if model.result {
                self.listReser = model.data
                self.filteredData = self.listReser
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - BUTTON ACTIONS
    @objc func addTapped(sender: AnyObject){
        let newVC = Resevation_Storyboard.instantiateViewController(withIdentifier: "CreateResavationViewController") as! CreateResavationViewController
        newVC.showDetail = false
        self.navigationController?.pushViewController(newVC, animated: true)
    }


}
extension ResevationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return filteredData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResevationHeaderCell", for: indexPath) as! ResevationHeaderCell
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResevationCell", for: indexPath) as! ResevationCell
            print(filteredData[indexPath.row])
            cell.bindData(filteredData[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = Resevation_Storyboard.instantiateViewController(withIdentifier: "CreateResavationViewController") as! CreateResavationViewController
        newVC.temp = filteredData[indexPath.row]
        newVC.showDetail = true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}
extension ResevationViewController: UISearchBarDelegate,UISearchDisplayDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filteredData = listReser
        let searchkey = searchText.lowercased()

        if searchText.isEmpty == false {
            filteredData = listReser.filter({ $0.NAME.contains(searchkey) })
        }

        tableView.reloadData()
    }
}
