//
//  ViewControllerContract.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 16/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewControllerPresenterDelegate {
    func viewControllerPresenter(presenter:ViewControllerPresenter,showWinMessageWithText:String)
    func viewControllerPresenter(presenter:ViewControllerPresenter,showWarningMessageWithText:String)
    var rxResetButton:Reactive<UIButton> { get }
    var rxDrawCardButton:Reactive<UIButton> { get }
}

protocol ViewControllerPresenter {
    func startGame()
    var cards:Observable<[Card]> { get }
}
