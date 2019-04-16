//
//  ViewControllerPresenter.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 16/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class ViewControllerPresenterImpl {
    
    static let CARDS_TO_DRAW = 5

    private let repo:RepositoryRepresentable = DefaultRepository()
    private let currentCards = Variable<[Card]>.init([])
    private let disposeBag = DisposeBag.init()
    private let view:ViewControllerPresenterDelegate
    
    var currentDeck:DeckRepresentable?
    
    init(view:ViewControllerPresenterDelegate) {
        self.view = view
        view.rxDrawCardButton.tap
            .asDriver()
            .throttle(1)
            .drive(onNext: { _ in
                self.drawCards()
            }).disposed(by: disposeBag)
        view.rxResetButton.tap
            .asDriver()
            .throttle(1)
            .drive(onNext: { _ in
                self.resetGame()
            }).disposed(by: disposeBag)
        cards.asObservable()
            .subscribe(onNext: { (cards) in self.checkCards(cards: cards)})
            .disposed(by: disposeBag)
        startGame()
    }
    
    func drawCards() {
        currentDeck?
            .drawCardsObservable(cards: ViewControllerPresenterImpl.CARDS_TO_DRAW)
            .subscribe(onNext: { (cards) in
                self.currentCards.value.append(contentsOf: cards)
            }).disposed(by: disposeBag)
    }
    
    func resetGame() {
        self.currentCards.value.removeAll()
        startGame()
    }
   
    
    func checkCards(cards:[Card]) {
        
    }
    
    func getNewDeckAndDrawCard() {
        repo.newDeckObservable()
            .subscribe(onNext: { (deck) in
                self.currentDeck = deck
                self.drawCards()
            }).disposed(by: disposeBag)
    }
}

extension ViewControllerPresenterImpl: ViewControllerPresenter {
    var cards: Observable<[Card]> {
        return currentCards.asObservable()
    }
    
    func startGame() {
       self.getNewDeckAndDrawCard()
    }
}

