//
//  DecodableRemoteContent.swift
//  
//
//  Created by Dmytro Anokhin on 19/08/2020.
//

import Foundation
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class DecodableRemoteContent<Item, Decoder> : RemoteContent where Item : Decodable,
                                                                               Decoder : TopLevelDecoder,
                                                                               Decoder.Input == Data
{
    public unowned let urlSession: URLSession

    public let url: URL

    public let type: Item.Type

    public let decoder: Decoder

    public init(urlSession: URLSession = .shared, url: URL, type: Item.Type, decoder: Decoder) {
        self.urlSession = urlSession
        self.url = url
        self.type = type
        self.decoder = decoder
    }

    @Published private(set) public var loadingState: RemoteContentLoadingState<Item> = .none

    public func load() {
        guard cancellable == nil else {
            return
        }

        // Set state to in progress
        loadingState = .inProgress

        // Start loading
        cancellable = urlSession
            .dataTaskPublisher(for: url)
            .map {
                $0.data
            }
            .decode(type: type, decoder: decoder)
            .map {
                .success($0)
            }
            .catch {
                Just(.failure($0.localizedDescription))
            }
            .receive(on: RunLoop.main)
            .assign(to: \.loadingState, on: self)
    }

    public func cancel() {
        guard cancellable != nil else {
            return
        }

        // Reset loading state
        loadingState = .none

        // Stop loading
        cancellable?.cancel()
        cancellable = nil
    }

    private var cancellable: AnyCancellable?
}
