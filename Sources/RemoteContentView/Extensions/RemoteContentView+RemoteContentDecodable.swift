//
//  RemoteContentView+RemoteContentDecodable.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import Foundation
import SwiftUI


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: RemoteContentDecodable {

    init(urlSession: URLSession = .shared,
         url: URL,
         type: T.Type,
         empty: @escaping () -> Empty,
         progress: @escaping () -> Progress,
         failure: @escaping (_ message: String) -> Failure,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  decode: {
                    if let value = type.init(data: $0) {
                        return value
                    }
                    else {
                        throw URLError(.unknown)
                    }
                  },
                  empty: empty,
                  progress: progress,
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: RemoteContentDecodable, Empty == EmptyView {

    init(urlSession: URLSession = .shared,
         url: URL,
         type: T.Type,
         progress: @escaping () -> Progress,
         failure: @escaping (_ message: String) -> Failure,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  type: type,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: RemoteContentDecodable, Empty == EmptyView, Progress == ActivityIndicator {

    init(urlSession: URLSession = .shared,
         url: URL,
         type: T.Type,
         failure: @escaping (_ message: String) -> Failure,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  type: type,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: RemoteContentDecodable, Empty == EmptyView, Failure == Text {

    init(urlSession: URLSession = .shared,
         url: URL,
         type: T.Type,
         progress: @escaping () -> Progress,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  type: type,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: { Text($0) },
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: RemoteContentDecodable, Empty == EmptyView, Progress == ActivityIndicator, Failure == Text {

    init(urlSession: URLSession = .shared,
         url: URL,
         type: T.Type,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  type: type,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: { Text($0) },
                  content: content)
    }
}
