//
//  RemoteContentView.swift
//  
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import SwiftUI


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct RemoteContentView<T, Empty, Progress, Failure, Content> : View where Empty : View, Progress : View, Failure : View, Content : View {

    let empty: () -> Empty

    let progress: () -> Progress

    let failure: (_ message: String) -> Failure

    let content: (_ value: T) -> Content

    public init(urlSession: URLSession = .shared,
                url: URL,
                decode: @escaping (_ data: Data) throws -> T,
                empty: @escaping () -> Empty,
                progress: @escaping () -> Progress,
                failure: @escaping (_ message: String) -> Failure,
                content: @escaping (_ value: T) -> Content)
    {
        remoteContent = RemoteContent(urlSession: urlSession, url: url, decode: decode)

        self.empty = empty
        self.progress = progress
        self.failure = failure
        self.content = content
    }

    public var body: some View {
        ZStack {
            switch remoteContent.loadingState {
                case .none:
                    empty()

                case .inProgress:
                    progress()

                case .success(let value):
                    content(value)

                case .failure(let message):
                    failure(message)
            }
        }
        .onAppear {
            remoteContent.load()
        }
        .onDisappear {
            remoteContent.cancel()
        }
    }

    @ObservedObject private var remoteContent: RemoteContent<T>
}
