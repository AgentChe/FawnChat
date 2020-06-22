//
//  RightView.swift
//  FAWN
//
//  Created by Алексей Петров on 04/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class RightView: UIView {

    @IBOutlet weak var priceLongLabel: UILabel?
    @IBOutlet weak var priceNameLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    
    var productID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if UIDevice.modelName.contains("SE")  {
//            priceNameLabel?.font = priceNameLabel!.font.withSize(14)
//            priceLabel?.font = priceLabel!.font.withSize(10)
//        }
//        
//        if UIDevice.modelName.contains("6") ||
//            UIDevice.modelName.contains("7") ||
//            UIDevice.modelName.contains("8")
//        {
//            priceNameLabel?.font = priceNameLabel!.font.withSize(16)
//            priceLabel?.font = priceLabel!.font.withSize(12)
//        }
//        priceLongLabel?.font = priceLongLabel!.font.withSize(bounds.height / 10)
//        priceNameLabel?.font = priceNameLabel!.font.withSize(bounds.height / 10)
//        priceLabel?.font = priceLabel!.font.withSize(bounds.height / 10)
    }
    
    func config(with priceTag: SubPriceTag) {
        priceLongLabel?.text = priceTag.nameNum
        priceNameLabel?.text = priceTag.name
        priceLabel?.text = priceTag.priceString
        productID = priceTag.id
    }
    
    func select(_ state: Bool) {
        self.backgroundColor = state ? #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1) : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        priceLongLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        priceNameLabel?.textColor = state ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
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
