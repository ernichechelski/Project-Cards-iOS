//
//  DeckOfCardsRepositor.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import RxSwift
public class DefaultRepository:RepositoryRepresentable {
    private let service = DeckOfCardsService()
    func newDeckObservable() -> Observable<DeckRepresentable> {
        return service.newDeckObservable()
            .map({ (response) -> DeckRepresentable in
                return response
            })
    }
}
