//
//  ManualySearchView.swift
//  FAWN
//
//  Created by Алексей Петров on 13.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class ManualySearchView: UIView {

    @IBOutlet weak var newSearchButton: GradientButton!
    
    class func instanceFromNib() -> ManualySearchView {
       return UINib(nibName: "ManualySearchView", bundle: .main).instantiate(withOwner: nil, options: nil)[0] as! ManualySearchView
   }

}
