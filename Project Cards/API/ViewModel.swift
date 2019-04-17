//
//  ViewModel.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryRepresentable {
    func newDeckObservable()->Observable<DeckRepresentable>
}

protocol DeckRepresentable {
    func drawCardsObservable(cards:Int)->Observable<[CardRepresentable]>
}

enum CardColor:String {
    case HEARTS
    case DIAMONDS
    case CLUBS
    case SPADES
}

enum CardRank:String {
    case TWO = "2"
    case THREE = "3"
    case FOUR = "4"
    case FIVE = "5"
    case SIX = "6"
    case SEVEN = "7"
    case EIGHT = "8"
    case NINE = "9"
    case TEN = "10"
    case JACK = "JACK"
    case QUEEN = "QUEEN"
    case KING = "KING"
    case ACE = "ACE"
    case JOKER = "JOKER"
}

protocol CardRepresentable {
    var rank:CardRank { get }
    var color:CardColor { get }
    var code:String { get }
    var imageUrl:String { get }
}

