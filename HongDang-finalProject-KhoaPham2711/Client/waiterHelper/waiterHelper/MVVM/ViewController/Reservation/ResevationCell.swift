//
//  ResevationCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class ResevationCell: UITableViewCell {

    @IBOutlet weak var lbNAme: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTable: UILabel!
    @IBOutlet weak var imgState: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindData(_ s:RESERVATION){
        lbNAme.text = s.NAME
        lbDate.text = "\(s.DAY)/\(s.MONTH)/\(s.YEAR)"
        lbTime.text = "\(s.HOUR):\(s.MINUTE)"
        if s.IDTABLE == "-1" {
            lbTable.text = "null"
        } else {
            lbTable.text = s.IDTABLE
        }
        if s.INTIME{
            imgState.backgroundColor = .red
        } else {
            imgState.backgroundColor = .white
        }
    }

}
