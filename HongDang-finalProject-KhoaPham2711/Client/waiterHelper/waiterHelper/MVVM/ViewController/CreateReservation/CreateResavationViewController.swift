//
//  CreateResavationViewController.swift
//  waiterHelper
//
//  Created by HongDang on 3/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit
import DownPicker

class CreateResavationViewController: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tfTable: UITextField!
    
    //MARK: OTHER VARIABLES
    var temp:RESERVATION?
    var showDetail = true
    var tableDownPicker: DownPicker!
    var LobbyVM = LobbyViewModel()
    var dataDropTable = [String]()
    var listTb = [Table]()
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if temp!.IDTABLE == "-1"{
//            fillData()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        setupVar()
        if showDetail{
            if temp!.IDTABLE == "-1"{
                callAPI()
            }
        }
        
        
        
    }

    //MARK: - SETUP VAR
    func setupVar() {
        
    }
    
    //MARK: - SETUP UI
    func setupUI() {
        
        if showDetail {
            doneBtn.setTitle("PREPARE", for: .normal)
            tfName.text = temp?.NAME
            let strdate = "\(temp!.DAY)/\(temp!.MONTH)/\(temp!.YEAR) \(temp!.HOUR):\(temp!.MINUTE)"
            print(strdate)
            datePicker.setDate(from: strdate, format: "dd/MM/yyyy HH:mm")
            datePicker.isEnabled = false
            if temp!.IDTABLE > "-1" && showDetail == true{
                doneBtn.isHidden = true
                tableDownPicker = DownPicker(textField: tfTable)
                tableDownPicker.setPlaceholder( temp!.NAME)
                tableDownPicker.isEnabled = false
                datePicker.isEnabled = false
                tfName.isEnabled = false
            }
        } else {
            tfTable.isHidden = true
        }
    }
    
    //MARK: - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL AND BIND DATA
    func fillData() {
        if showDetail {
            self.LobbyVM.GetFreeTable { (model) in
                guard let model = model else {
                    return
                }
                if model.result == true {
                    self.listTb = model.data
                    self.dataDropTable = []
                    for i in self.listTb {
                        let temp = i.NAME
                        self.dataDropTable.append(temp)
                    }
                    DispatchQueue.main.async {
                        self.tableDownPicker = DownPicker(textField: self.tfTable, withData:self.dataDropTable)
                        let view1 = UIView()
                        let imageview = UIImageView(image: UIImage(named: "downarrow"))
//                        let rightPadding: CGFloat = 50 //--- change right padding
//                        imageview.frame = CGRect(x: 0, y: 0, width: imageview.frame.size.width + rightPadding , height:imageview.frame.size.height)
//                        imageview.backgroundColor = .red
                        view1.addSubview(imageview)
                        view1.widthAnchor.constraint(equalToConstant: 30).isActive = true
                        view1.heightAnchor.constraint(equalToConstant: 18).isActive = true

                        self.tfTable.rightViewMode = .always
                        self.tfTable.rightView = view1

//                        self.tfTable.rightViewRect(forBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 22)))
                        

                        self.tableDownPicker.setPlaceholder("Tap to choose table to prepare")
                        
                    }
                }
            }
        }
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func done(_ sender: Any) {
        if showDetail {
            showAlert(tfTable!.text!)
        } else {
            showAlert(tfName!.text!)
        }
    }
    func showAlert (_ s:String){
        if (s == ""){
            let warning = UIAlertController(title: "Warning", message: "You have not filled out the information!", preferredStyle:   .alert)
            warning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(warning, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle:   .alert)
            for i in ["Done", "Not yet"] {
                alert.addAction(UIAlertAction(title: i, style: .default, handler: sendReservation))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    func sendReservation(action: UIAlertAction) {
        if showDetail {
           if action.title! == "Done" {
//            let input = tfTable!.text!
            let input = listTb.filter { $0.NAME == tfTable!.text! }.first?.ID
            var s:[String] = []
            s.append(input!)
            s.append(temp!.ID)
            let data1 = [
                "id": s[1],
                "idtable": s[0]
                ]
            print(data1)
            SocketHandler.shared.socket.emit("setStateReserved",  data1)
            navigationController?.popViewController(animated: false)
           }
           else {
               
           }
        } else {
            if action.title! == "Done" {
                let input = getdate(datePicker)
                let data = [
                    "name": input.NAME,
                    "day": input.DAY,
                    "month": input.MONTH,
                    "year": input.YEAR,
                    "hour": input.HOUR,
                    "minute": input.MINUTE
                ]
                SocketHandler.shared.socket.emit("sendReservation",  data)
                navigationController?.popViewController(animated: false)
            }
            else {
                
            }
        }
        
    }
    func getdate(_ dataPicker: UIDatePicker) -> RESERVATION{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "HH"
        let hour: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "mm"
        let minute: String = dateFormatter.string(from: self.datePicker.date)
        let result = RESERVATION(DAY: day, HOUR: hour, ID: "0", IDTABLE: "-1", INTIME: false,MINUTE: minute, MONTH: month, NAME: tfName!.text!, STATE: true, YEAR: year)

        return result
    }
    
}

extension UIDatePicker {

   func setDate(from string: String, format: String, animated: Bool = true) {

      let formater = DateFormatter()

      formater.dateFormat = format

      let date = formater.date(from: string) ?? Date()

      setDate(date, animated: animated)
   }
}
