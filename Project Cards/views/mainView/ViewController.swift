//
//  ViewController.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 15/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage
class ViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    private let disposeBag = DisposeBag.init()
    private var presenter:ViewControllerPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ViewControllerPresenterImpl(view:self)
        presenter?.cards.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: CollectionViewCell.self)) { (row, element, cell) in cell.imageView.af_setImage(withURL: URL.init(string: element.imageUrl)!)}.disposed(by: disposeBag)
    }
}


extension ViewController:ViewControllerPresenterDelegate {
    var rxResetButton: Reactive<UIButton> {
        return resetButton.rx
    }
    
    var rxDrawCardButton: Reactive<UIButton> {
        return drawButton.rx
    }
    
    func viewControllerPresenter(presenter: ViewControllerPresenter,showWinMessageWithText text: String) {
        let alert = UIAlertController(title: "You won!", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func viewControllerPresenter(presenter: ViewControllerPresenter,showWarningMessageWithText text: String) {
        let alert = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok :(", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
