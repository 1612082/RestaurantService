//
//  CategoryItem.swift
//  waiterHelper
//
//  Created by HongDang on 3/3/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class CategoryItem: UICollectionViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var line: UIImageView!
    
    func bindData(_ s:String, _ color:UIColor){
        lbName.text = s.uppercased()
        line.backgroundColor = color
    }
}
