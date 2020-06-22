//
//  NotifyEnablingViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 06/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

enum NotifyCellTypes {
    case match
    case users
    case message
    case knocks
}

struct SwitchCellModel {
    var title: String
    var subtitle: String
    var enabled: Bool
    var type: NotifyCellTypes
}

class NotifyEnablingViewController: UIViewController {
    
    
    var cells: [SwitchCellModel] = [SwitchCellModel(title: NSLocalizedString("messages_push", comment: ""),
                                subtitle: NSLocalizedString("messages_push_sub", comment: ""),
                                enabled: false,
                                type: .message),
                SwitchCellModel(title: NSLocalizedString("match_push", comment: ""),
                                subtitle: NSLocalizedString("match_push_sub", comment: ""),
                                enabled: false,
                                type: .match),
                SwitchCellModel(title: NSLocalizedString("users_push", comment: ""),
                                subtitle: NSLocalizedString("users_push_sub", comment: ""),
                                enabled: false,
                                type: .users),
                SwitchCellModel(title: NSLocalizedString("knock_push", comment: ""),
                                subtitle: NSLocalizedString("knock_push_sub", comment: ""),
                                enabled: false,
                                type: .knocks)]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.delegate = self
        tableView.register(UINib(nibName: "NotifySetingUiTableViewCell", bundle: .main), forCellReuseIdentifier: "NotifySetingUiTableViewCell")
        
        NotificationManager.shared.getSwither { [weak self] (result) in
            if result != nil {
                self?.cells = [SwitchCellModel(title: NSLocalizedString("messages_push", comment: ""),
                                               subtitle: NSLocalizedString("messages_push_sub", comment: ""),
                                               enabled: result!.onMessage,
                                               type: .message),
                               SwitchCellModel(title: NSLocalizedString("match_push", comment: ""),
                                               subtitle: NSLocalizedString("match_push_sub", comment: ""),
                                               enabled: result!.onMatch,
                                               type: .match),
                               SwitchCellModel(title: NSLocalizedString("users_push", comment: ""),
                                               subtitle: NSLocalizedString("users_push_sub", comment: ""),
                                               enabled: result!.onUsers,
                                               type: .users),
                               SwitchCellModel(title: NSLocalizedString("knock_push", comment: ""),
                                               subtitle: NSLocalizedString("knock_push_sub", comment: ""),
                                               enabled: result!.onKnocks,
                                               type: .knocks)]
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            NotificationManager.shared.requestAccess()
        }

    }
}

extension NotifyEnablingViewController: NotificationDelegate {
    func notificationRequestWasEnd(success: Bool) {
        
    }
}

extension NotifyEnablingViewController: UITableViewDelegate {
    
}

extension NotifyEnablingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotifySetingUiTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotifySetingUiTableViewCell", for: indexPath) as! NotifySetingUiTableViewCell
        cell.config(model: cells[indexPath.row])
        return cell
    }
    
    
}
