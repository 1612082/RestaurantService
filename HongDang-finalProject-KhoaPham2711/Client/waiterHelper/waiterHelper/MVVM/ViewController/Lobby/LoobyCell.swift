//
//  LoobyCell.swift
//  waiterHelper
//
//  Created by HongDang on 2/21/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class LoobyCell: UITableViewCell {

    @IBOutlet weak var lbNameLobby: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindData(_ s:String){
        lbNameLobby.text = s
    }

}

