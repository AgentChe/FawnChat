//
//  DeleteAccountViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 09/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit


class DeleteAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnNo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapOnDelete(_ sender: Any) {
        DatingKit.user.logout { (status) in
            ScreenManager.shared.showRegistration()
            self.dismiss(animated: true, completion: nil)
        }

    }

}

extension DeleteAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        case 1:
             return tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        case 2:
             return tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    
    
    
}
