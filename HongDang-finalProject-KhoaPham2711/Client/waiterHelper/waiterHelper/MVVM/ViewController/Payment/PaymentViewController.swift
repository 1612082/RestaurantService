//
//  PaymentViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
var bills = [BILL]()
class PaymentViewController: UIViewController {

    //MARK: IBOUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: OTHER VARIABLES
    var PaymentVM = PaymentViewModel()
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
        SocketHandler.shared.socket.on("refreshPayment") { (data, ack) in
            self.callAPI()
        }
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        navigationController?.title = "INVOICE"
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        PaymentVM.GetBill { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                bills = model.data
                self.tableView.reloadData()
            }
        
        }
    }
    
    //MARK: - BUTTON ACTIONS


}
extension PaymentViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "INVOICE of Table"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        cell.bindData(bills[indexPath.row].IDTABLE)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = Payment_Storyboard.instantiateViewController(identifier: "PaymentDetailViewController" ) as PaymentDetailViewController
        detailVC.idBill = bills[indexPath.row].ID
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
