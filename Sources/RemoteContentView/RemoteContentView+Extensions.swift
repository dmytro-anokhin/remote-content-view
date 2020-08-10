//
//  RemoteContentView+Extensions.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import Foundation
import SwiftUI


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteContentView where T: Decodable, Empty == EmptyView, Progress == Text, Failure == Text {

    init(url: URL,
         decode: @escaping (_ data: Data) throws -> T,
         content: @escaping (_ value: T) -> Content)
    {
        self.init(url: url, decode: decode, empty: { EmptyView() }, progress: { Text("Loading...") }, failure: { Text($0) }, content: content)
    }
}
