//
//  RemoteContentView+Extensions.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import SwiftUI
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where Empty == EmptyView {

    init<R: RemoteContent>(remoteContent: R,
                           progress: @escaping () -> Progress,
                           failure: @escaping (_ error: Error, _ retry: @escaping () -> Void) -> Failure,
                           content: @escaping (_ value: Value) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                 R.Value == Value
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where Empty == EmptyView, Progress == ActivityIndicator {

    init<R: RemoteContent>(remoteContent: R,
                           failure: @escaping (_ error: Error, _ retry: @escaping () -> Void) -> Failure,
                           content: @escaping (_ value: Value) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                 R.Value == Value
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where Empty == EmptyView, Failure == Text {

    init<R: RemoteContent>(remoteContent: R,
                           progress: @escaping () -> Progress,
                           content: @escaping (_ value: Value) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                 R.Value == Value
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: { error, _ in Text(error.localizedDescription) },
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where Empty == EmptyView, Progress == ActivityIndicator, Failure == Text {

    init<R: RemoteContent>(remoteContent: R,
                           content: @escaping (_ value: Value) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                 R.Value == Value
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: { error, _ in Text(error.localizedDescription) },
                  content: content)
    }
}
