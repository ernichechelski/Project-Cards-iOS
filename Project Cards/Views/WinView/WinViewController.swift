//
//  WinViewController.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import UIKit
import RxSwift




extension WinViewController {
    static func get(message:String,cards:[CardRepresentable])->WinViewController {
        var controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "winView") as! WinViewController
        controller.cards = cards
        controller.message = message
        return controller
    }
}

class WinViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var cards:[CardRepresentable]?
    var message:String?
    
    private let disposeBag = DisposeBag.init()
    
    @IBAction func okButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        Observable.from(cards).bind(to:
        collectionView.rx.items(cellIdentifier: "cell", cellType: CollectionViewCell.self)) {
            (row, element, cell) in
            cell.imageView.image = UIImage.init(named: "KH.jpg")
            cell.imageView.af_setImage(withURL: URL.init(string: element.imageUrl)!)
            }.disposed(by: disposeBag)
    }
}
