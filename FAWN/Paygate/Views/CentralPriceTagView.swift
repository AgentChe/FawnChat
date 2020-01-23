//
//  CentralPriceTagView.swift
//  FAWN
//
//  Created by Алексей Петров on 03/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class CentralPriceTagView: UIView {

    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var subnameLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    
    var productID: String?
    
    override func awakeFromNib() {
        
//        if UIDevice.modelName.contains("SE")  {
//            headerLabel?.font = headerLabel!.font.withSize(11)
//            nameLabel?.font = nameLabel!.font.withSize(12)
//            subnameLabel?.font = subnameLabel!.font.withSize(22)
//            priceLabel?.font = priceLabel!.font.withSize(10)
//        }
//        
//        if UIDevice.modelName.contains("6") ||
//            UIDevice.modelName.contains("7") ||
//            UIDevice.modelName.contains("8")
//        {
//            headerLabel?.font = headerLabel!.font.withSize(13)
//            nameLabel?.font = nameLabel!.font.withSize(14)
//            subnameLabel?.font = subnameLabel!.font.withSize(24)
//            priceLabel?.font = priceLabel!.font.withSize(12)
//        }
//        headerLabel?.font = headerLabel!.font.withSize(bounds.height / 15)
//        nameLabel?.font = nameLabel!.font.withSize(bounds.height / 15)
//        subnameLabel?.font = subnameLabel!.font.withSize(bounds.height / 6)
//        priceLabel?.font = priceLabel!.font.withSize(bounds.height / 12)
    }
    
    func config(with priceTag: CentralPriceTag) {
        headerLabel?.text = priceTag.headerString
        nameLabel?.text = priceTag.name
        subnameLabel?.text = priceTag.subname
        priceLabel?.text = priceTag.priseString
        productID = priceTag.id
    }
    
    func select(_ state: Bool) {
        self.backgroundColor = state ? #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1) : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        headerLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        subnameLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        nameLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        priceLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.6251067519, green: 0.6256913543, blue: 0.6430284977, alpha: 1)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
