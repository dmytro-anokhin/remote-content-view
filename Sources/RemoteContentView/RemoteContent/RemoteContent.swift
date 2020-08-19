//
//  RemoteContent.swift
//
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import Combine
import Foundation


public protocol RemoteContent : ObservableObject {

    associatedtype Item

    var loadingState: RemoteContentLoadingState<Item> { get }

    func load()

    func cancel()
}


final class AnyRemoteContent<Item> : RemoteContent {

    init<R: RemoteContent>(_ remoteContent: R) where R.ObjectWillChangePublisher == ObjectWillChangePublisher, R.Item == Item {
        objectWillChangeClosure = {
            remoteContent.objectWillChange
        }

        loadingStateClosure = {
            remoteContent.loadingState
        }

        loadClosure = {
            remoteContent.load()
        }

        cancelClosure = {
            remoteContent.cancel()
        }
    }

    private let objectWillChangeClosure: () -> ObjectWillChangePublisher

    var objectWillChange: ObservableObjectPublisher {
        objectWillChangeClosure()
    }

    private let loadingStateClosure: () -> RemoteContentLoadingState<Item>

    var loadingState: RemoteContentLoadingState<Item> {
        loadingStateClosure()
    }

    private let loadClosure: () -> Void

    func load() {
        loadClosure()
    }

    private let cancelClosure: () -> Void

    func cancel() {
        cancelClosure()
    }
}
