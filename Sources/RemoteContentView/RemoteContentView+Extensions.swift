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
                           failure: @escaping (_ message: String) -> Failure,
                           content: @escaping (_ value: Item) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                R.Item == Item
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
                           failure: @escaping (_ message: String) -> Failure,
                           content: @escaping (_ value: Item) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                R.Item == Item
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
                           content: @escaping (_ value: Item) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                R.Item == Item
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: { Text($0) },
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where Empty == EmptyView, Progress == ActivityIndicator, Failure == Text {

    init<R: RemoteContent>(remoteContent: R,
                           content: @escaping (_ value: Item) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                R.Item == Item
    {
        self.init(remoteContent: remoteContent,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: { Text($0) },
                  content: content)
    }
}
