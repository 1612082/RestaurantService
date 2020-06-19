//
//  PaymentCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/18/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(_ s:String){
        lbName.text = "Table "+s
    }
}
