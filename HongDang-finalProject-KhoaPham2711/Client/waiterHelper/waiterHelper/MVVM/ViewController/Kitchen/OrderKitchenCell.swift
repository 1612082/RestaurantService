//
//  OrderCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/8/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class OrderKitchenCell: UITableViewCell {

    @IBOutlet weak var idTable: UILabel!
    @IBOutlet weak var Quantity: UILabel!
    @IBOutlet weak var idFood: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var time: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        time.image = time.image?.withRenderingMode(.alwaysTemplate)
        time.tintColor = UIColor.red
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindData(_ table:String,_ food:String,_ name:String, _ quantity:String , _ timeWait:Int, _ colorBg:UIColor){
        idTable.text = table
        idFood.text = food
        lbName.text = name
        Quantity.text  = quantity
        lbTime.text = "\(timeWait) m"
        background.backgroundColor = colorBg
    }

}
