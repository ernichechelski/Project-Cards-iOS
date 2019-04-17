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
    
    private var _currentCards = [CardRepresentable]()
    private let currentCards = BehaviorRelay<[CardRepresentable]>(value: [CardRepresentable]())
    private let _winningCards = PublishSubject<[CardRepresentable]>()
    private let disposeBag = DisposeBag.init()
    private let view:ViewControllerPresenterDelegate
    
    var currentDeck:DeckRepresentable?
    
    private var errorHandler:((Swift.Error) -> Void)?
    
    init(view:ViewControllerPresenterDelegate) {
        self.view = view
        
        self.errorHandler = { (error) in
           self
            .view
            .viewControllerPresenter(presenter: self,
                                    warningOccuredWithMessage: error.localizedDescription)
        }
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
        currentCards.asObservable()
            .subscribe(
                onNext: { (cards) in self.checkCards(cards: cards)},
                onError:errorHandler)
            .disposed(by: disposeBag)
        startGame()
    }
    
    fileprivate func postCards() {
        self.currentCards.accept(self._currentCards)
    }
    
    func drawCards() {
        currentDeck?
            .drawCardsObservable(cards: ViewControllerPresenterImpl.CARDS_TO_DRAW)
            .subscribe(
            onNext: { (cards) in
                self._currentCards.append(contentsOf: cards)
                self.postCards()
            },
            onError:errorHandler)
            .disposed(by: disposeBag)
    }
    
    func resetGame() {
        self._currentCards.removeAll()
        self.postCards()
        startGame()
    }
    
    func getNewDeckAndDrawCard() {
        repo.newDeckObservable()
            .subscribe(
                onNext: { (deck) in
                    self.currentDeck = deck
                    self.drawCards()},
                onError:errorHandler)
            .disposed(by: disposeBag)
    }
   
    // TODO: implement checking cards
    func checkCards(cards:[CardRepresentable]) {
        _winningCards.onNext(cards)
         view.viewControllerPresenter(presenter: self, userWonWithMessage: "You won!", withCards: cards)
    }
    
   
}

extension ViewControllerPresenterImpl: ViewControllerPresenter {
    var cards: BehaviorRelay<[CardRepresentable]> {
        return currentCards
    }
    
    var winningCards: Observable<[CardRepresentable]> {
        return _winningCards.asObservable()
    }
    
    func startGame() {
       self.getNewDeckAndDrawCard()
    }
}

