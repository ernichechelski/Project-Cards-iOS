//
//  DeckOfCardsService.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum DeckOfCardsError:Error {
    case apiError(message:String)
}

public class DeckOfCardsService {
    
    private let api = DeckOfCardsAPI()
    
    func newDeckObservable()->Observable<DeckResponse> {
        return BehaviorSubject<DeckResponse>.create { (observer) -> Disposable in
            self.api.newDeckRequest().responseDeckResponse { response in
                if let error = response.error {
                    observer.onError(error)
                    return
                }
                
                guard let value = response.result.value else {
                    observer.onError(DeckOfCardsError.apiError(message:response.error?.localizedDescription ?? "No message"))
                    return
                }
                
                if !value.success {
                    observer.onError(DeckOfCardsError.apiError(message:value.error ?? "No error details"))
                    return
                }
                
                observer.onNext(value)
            }
            return Disposables.create()
        }
    }
    
    func drawObservable(deckId:String,cards:Int)->Observable<DrawResponse>{
        return BehaviorSubject<DrawResponse>.create { (observer) -> Disposable in
            self.api.drawCardRequest(deckId: deckId, cards: cards)
                .responseDrawResponse { response in
                    if let error = response.error {
                        observer.onError(error)
                        return
                    }
                    guard let value = response.result.value else {
                        observer.onError(DeckOfCardsError.apiError(message:response.error?.localizedDescription ?? "No message"))
                        return
                    }
                    
                    if !value.success {
                        observer.onError(DeckOfCardsError.apiError(message:value.error ?? "No error details"))
                        return
                    }
                    
                    observer.onNext(value)
            }
            return Disposables.create()
        }
    }
}
