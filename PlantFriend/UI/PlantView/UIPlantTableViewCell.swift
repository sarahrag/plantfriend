//
//  UIPlantTableViewCell.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 03.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//


import UIKit

/**
    UIPlantTableViewCell:
    Class for custom Cells for a Table with Plantdata in it.
    Each cells contains the Name of the plant, the picture, the days till the next waterdate and a button to check off and set the plant watered.
 */
class UIPlantTableViewCell: UITableViewCell {

    
    var model: Plant? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var PlantNameLabel: UIUpperCase!
    @IBOutlet weak var WaterLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var watered: UIButton!
    
    /**
        Action for the wateredButton: the plant get watered, the Cell refreshs and the button disabled
     */
    @IBAction func wateredButton(_ sender: Any) {
        model!.setWatered()
        updateUI()
        watered.isEnabled = false
    }
    
    /**
        Function to Update the UI. This contains to set the labels, the image of the plant and enable or diable the waterd button
     */
    private func updateUI() {
        PlantNameLabel.text = model?.name
        
        var days = " Tagen"
        
        if (model?.getDaysTillWater() == 1 || model?.getDaysTillWater() == -1){
            days = " Tag"
        }
        
        if((model?.getDaysTillWater())! < 0){
            WaterLabel.text = "Zu gießen vor " + String(-(model?.getDaysTillWater())!) + days
        }else{
            WaterLabel.text = "Zu gießen in " + String((model?.getDaysTillWater())!) + days
        }
        
        if !(model?.image!.isEmpty)!{
            plantImageView.image = UIImage(data: (model?.image!)!)
        }
        
        if((model?.getDaysTillWater())! > 3){
            watered.isEnabled = false
        }else{
            watered.isEnabled = true
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
