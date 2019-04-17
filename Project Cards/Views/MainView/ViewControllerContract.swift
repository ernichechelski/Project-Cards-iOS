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
   
    func viewControllerPresenter(presenter:ViewControllerPresenter,
                                 userWonWithMessage:String,
                                 withCards:[CardRepresentable])
    func viewControllerPresenter(presenter:ViewControllerPresenter,
                                 warningOccuredWithMessage:String)
    var rxResetButton:Reactive<UIButton> { get }
    var rxDrawCardButton:Reactive<UIButton> { get }
}

protocol ViewControllerPresenter {
    func startGame()
    var cards:BehaviorRelay<[CardRepresentable]> { get }
    var winningCards:Observable<[CardRepresentable]> { get }
}
