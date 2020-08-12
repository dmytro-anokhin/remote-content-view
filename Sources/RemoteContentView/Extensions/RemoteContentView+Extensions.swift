//
//  RemoteContentView+Extensions.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import Foundation
import SwiftUI


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView {

    init(urlSession: URLSession = .shared,
         url: URL,
         decode: @escaping (_ data: Data) throws -> T,
         progress: @escaping () -> Progress,
         failure: @escaping (_ message: String) -> Failure,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  decode: decode,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView, Progress == ActivityIndicator {

    init(urlSession: URLSession = .shared,
         url: URL,
         decode: @escaping (_ data: Data) throws -> T,
         failure: @escaping (_ message: String) -> Failure,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  decode: decode,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView, Failure == Text {

    init(urlSession: URLSession = .shared,
         url: URL,
         decode: @escaping (_ data: Data) throws -> T,
         progress: @escaping () -> Progress,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  decode: decode,
                  empty: { EmptyView() },
                  progress: progress,
                  failure: { Text($0) },
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView, Progress == ActivityIndicator, Failure == Text {

    init(urlSession: URLSession = .shared,
         url: URL,
         decode: @escaping (_ data: Data) throws -> T,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(urlSession: urlSession,
                  url: url,
                  decode: decode,
                  empty: { EmptyView() },
                  progress: { ActivityIndicator() },
                  failure: { Text($0) },
                  content: content)
    }
}
