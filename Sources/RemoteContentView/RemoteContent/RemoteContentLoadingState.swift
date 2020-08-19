//
//  RemoteContentLoadingState.swift
//  
//
//  Created by Dmytro Anokhin on 19/08/2020.
//


/// The state of the loading process.
///
/// The `RemoteContentLoadingState` serves dual purpose:
/// - represents the state of the loading process: none, in progress, success or failure;
/// - keeps associated value relevant to the state of the loading process.
///
/// This dual purpose allows the view to use switch statement in its `body` and return different view in each case.
///
public enum RemoteContentLoadingState<T> {

    case none

    case inProgress

    case success(_ value: T)

    case failure(_ message: String)
}
