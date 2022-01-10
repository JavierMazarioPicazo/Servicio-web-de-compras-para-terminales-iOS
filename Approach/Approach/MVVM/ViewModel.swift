//
//  ViewModel.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import Combine

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input
    
    var state: State { get }
    func trigger(_ input: Input)
}

final class AnyViewModel<State, Input>: ViewModel {
    
    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void
    
    
    var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }
    
    var state: State {
        wrappedState()
    }
    
    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
            state[keyPath: keyPath]
        }
    
    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
            self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
            self.wrappedState = { viewModel.state }
            self.wrappedTrigger = viewModel.trigger
        }
    
}
