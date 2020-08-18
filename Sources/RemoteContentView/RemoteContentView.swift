//
//  RemoteContentView.swift
//  
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import SwiftUI
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct RemoteContentView<Item, Decoder, Empty, Progress, Failure, Content> : View where Empty : View,
                                                                                               Progress : View,
                                                                                               Failure : View,
                                                                                               Content : View,
                                                                                               Item : Decodable,
                                                                                               Decoder : TopLevelDecoder,
                                                                                               Decoder.Input == Data {

    let empty: () -> Empty

    let progress: () -> Progress

    let failure: (_ message: String) -> Failure

    let content: (_ value: Item) -> Content

    public init(urlSession: URLSession = .shared,
                url: URL,
                type: Item.Type,
                decoder: Decoder,
                empty: @escaping () -> Empty,
                progress: @escaping () -> Progress,
                failure: @escaping (_ message: String) -> Failure,
                content: @escaping (_ value: Item) -> Content)
    {
        remoteContent = RemoteContent(urlSession: urlSession, url: url, type: type, decoder: decoder)

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

    @ObservedObject private var remoteContent: RemoteContent<Item, Decoder>
}
