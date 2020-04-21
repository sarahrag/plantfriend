//
//  UIPlantsCollectionViewCell.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 19.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit

/**
    UIPlantCollectionViewCell:
    Class for custom cells of a collectionView to show a overview of all plants of the user.
 */
class UIPlantsCollectionViewCell: UICollectionViewCell {
    
    var model: Plant? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    
    /**
        Function to update the UI: It resets the nameLabel and the Image
     */
    private func updateUI() {
        nameLabel.text = model?.name
        
        if !(model?.image!.isEmpty)!{
            plantImageView.image = UIImage(data: (model?.image!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
}
