////
////  OnboardingViewController.swift
////  FAWN
////
////  Created by Алексей Петров on 17/03/2019.
////  Copyright © 2019 Алексей Петров. All rights reserved.
////
//
//import UIKit
//import Foundation
//import Amplitude_iOS
//import DatingKit
//
//
struct OnboardingCellModel {
    var mainTitle: String
    var subtitle: String
    var videoName: String
    var buttonName:String

    init(mainTitle: String, subtitle: String, videoName: String, buttonName: String) {
        self.mainTitle = mainTitle
        self.subtitle = subtitle
        self.videoName = videoName
        self.buttonName = buttonName
    }
}
//
//class _OnboardingViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    let models: [OnboardingCellModel] = [OnboardingCellModel(mainTitle: NSLocalizedString("first_reason", comment: ""),
//                                                             subtitle: NSLocalizedString("first_reason_sub", comment: ""),
//                                                             videoName: "tenor-7",
//                                                             buttonName: NSLocalizedString("first_btn", comment: "")),
//                                         OnboardingCellModel(mainTitle: NSLocalizedString("second_reason", comment: ""),
//                                                             subtitle: NSLocalizedString("second_reason_sub", comment: ""),
//                                                             videoName: "tenor-5",
//                                                             buttonName: NSLocalizedString("second_btn", comment: "")),
//                                         OnboardingCellModel(mainTitle: NSLocalizedString("tried_reason", comment: ""),
//                                                             subtitle: NSLocalizedString("tried_reason_sub", comment: ""),
//                                                             videoName: "tenor-8",
//                                                             buttonName: NSLocalizedString("tried_btn", comment: ""))]
//
////    let videos:[String] = ["tenor-7", "tenor-5", "tenor-8"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.register(UINib.init(nibName: "FirsGayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirsGayCollectionViewCell")
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//
//
//    }
//
//    @IBAction func tapOnCool(_ sender: UIButton) {
//        Amplitude.instance()?.log(event: .firstOnboardingTap)
//        performSegue(withIdentifier: "hello", sender: nil)
//    }
//
//    @IBAction func tapOnSure(_ sender: UIButton) {
//        Amplitude.instance()?.log(event: .secondOnboardingTap)
//        collectionView.scrollToNextItem()
//        sender.isHidden = true
//    }
//
//    @IBAction func tapONGotIt(_ sender: UIButton) {
//        Amplitude.instance()?.log(event: .triedOnboardingTap)
//        collectionView.scrollToNextItem()
//        sender.isHidden = true
//    }
//
//}
//
//extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return models.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: FirsGayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirsGayCollectionViewCell", for: indexPath) as! FirsGayCollectionViewCell
//        cell.configScreen(with: models[indexPath.row])
//        switch indexPath.row {
//        case 0:
//            Amplitude.instance()?.log(event: .firstOnboardingScr)
//            cell.continueButton.addTarget(self, action: #selector(tapONGotIt(_:)), for: .touchUpInside)
//            break
//        case 1:
//            Amplitude.instance()?.log(event: .secondOnboardingScr)
//            cell.continueButton.addTarget(self, action: #selector(tapOnSure(_:)), for: .touchUpInside)
//            break
//        case 2:
//            Amplitude.instance()?.log(event: .thriedOnboardingScr)
//            cell.continueButton.addTarget(self, action: #selector(tapOnCool(_:)), for: .touchUpInside)
//            break
//        default:
//            break
//        }
//        return  cell
//    }
//}
//
//
//
//extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.frame.size
//
//    }
//}
