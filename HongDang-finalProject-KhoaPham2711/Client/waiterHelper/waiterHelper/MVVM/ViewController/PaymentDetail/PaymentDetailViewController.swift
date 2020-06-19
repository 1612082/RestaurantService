//
//  PaymentDetailViewController.swift
//  waiterHelper
//
//  Created by HongDang on 3/18/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class PaymentDetailViewController: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var lbIDBill: UILabel!
    @IBOutlet weak var lbIDTable: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: OTHER VARIABLES
    var idBill:String?
    var detail = [BILLDETAIL]()
    var calendar = Calendar.current
    let date = Date()
    var PaymentVM = PaymentViewModel()
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar = Calendar.current
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        setupVar()
        setupUI()
        callAPI()
    }
    
    //MARK: - SETUP VAR
    func setupVar() {
        PaymentVM.idBill = idBill!
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        lbDate.text = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        lbTime.text = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        self.PaymentVM.idBill = idBill!
        PaymentVM.GetBillDetail(completion: { (model) in
            guard let model = model else {
                return
            }
            if model.result == true {
                self.detail = model.data
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.lbIDBill.text = self.detail.first?.ID
                    self.lbIDTable.text = self.detail.first?.IDTABLE
                    self.lbTotalPrice.text = "$ \(self.PaymentVM.CountTotalPrice(self.detail))"
                }
            }
        })
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func payBill(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle:   .alert)
        for i in ["Done", "Not yet"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: sendPayment))
        }
         self.present(alert, animated: true, completion: nil)
    }
    func sendPayment(action: UIAlertAction) {
        if action.title! == "Done" {
            SocketHandler.shared.socket.emit("pay", ["BillID":self.lbIDBill.text,"TableID":self.lbIDTable.text])
            navigationController?.popViewController(animated: false)
        }
        else {
            
        }
    }
}
extension PaymentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath) as! BillCell
        cell.bindData(detail[indexPath.row].NAME, detail[indexPath.row].QUANTITY, detail[indexPath.row].PRICE)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
