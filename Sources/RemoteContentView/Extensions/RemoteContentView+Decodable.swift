//
//  RemoteContentView+Decodable.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import Foundation
import SwiftUI


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable {

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
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: $0)
                  },
                  empty: empty,
                  progress: progress,
                  failure: failure,
                  content: content)
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView, Progress == ActivityIndicator, Failure == Text {

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
