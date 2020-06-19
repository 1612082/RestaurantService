//
//  CategoryCell.swift
//  waiterHelper
//
//  Created by HongDang on 3/3/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var MenuVM = MenuViewModel()
    var listCate:[CATEGORY] = []
    var didChangeCategory:((_ id:String)->Void)! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.dataSource = self
        collectionView.delegate = self
        getCategory()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getCategory() {
        MenuVM.GetCate { (model) in
           guard let model = model else {
                return
            }
            if model.result == true {
                self.listCate = model.data
                self.collectionView.reloadData()
                DispatchQueue.main.async
                {
                    let index = IndexPath(item: idToScroll - 1, section: 0)
                    print(index)
                    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
            }
        }
    }

}
extension CategoryCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItem", for: indexPath) as! CategoryItem
        if idToScroll-1 == indexPath.row {
            cell.bindData(listCate[indexPath.row].Name, .blue)
        } else {
            cell.bindData(listCate[indexPath.row].Name, .white)
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didChangeCategory != nil {
            self.didChangeCategory(listCate[indexPath.row].ID)
        }
    }
    
}
