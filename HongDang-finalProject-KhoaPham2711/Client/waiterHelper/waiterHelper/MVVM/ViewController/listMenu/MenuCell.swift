//
//  MenuCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var idFood: UILabel!
    @IBOutlet weak var nameFood: UILabel!
    @IBOutlet weak var quantity: UILabel!

    
    var didChangeQuantity:((_ sl:Int, _ id:String) -> Void)! = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantity.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindData(_ id:String, _ name:String, _ sl:Int){
        idFood.text = id
        nameFood.text = name
        quantity.text = "\(sl)"
    }
    
    @IBAction func Subtraction(_ sender: UIButton) {
        var sl = Int(quantity.text!)!
        let id = String(idFood.text!)
        sl -= 1
        if (didChangeQuantity != nil && sl > -1) {
            self.didChangeQuantity(sl, id)
        }
        
    }
    
    @IBAction func Addition(_ sender: UIButton) {
        var sl = Int(quantity.text!)!
        let id = String(idFood.text!)

        sl += 1
        if (didChangeQuantity != nil) {
            self.didChangeQuantity(sl, id)
        }
    }
    
}
