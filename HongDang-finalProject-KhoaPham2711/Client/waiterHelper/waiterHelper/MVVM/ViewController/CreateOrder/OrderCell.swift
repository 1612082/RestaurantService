//
//  OrderCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var IdFood: UILabel!
    @IBOutlet weak var NameFood: UILabel!
    @IBOutlet weak var Quantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(_ id:String, _ name:String,_ quantity:String){
        IdFood.text = id
        NameFood.text = name
        Quantity.text = quantity
    }
}
