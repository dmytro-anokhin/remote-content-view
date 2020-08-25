//
//  RemoteImage.swift
//  
//
//  Created by Dmytro Anokhin on 19/08/2020.
//

import UIKit
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class RemoteImage : RemoteContent {

    public enum Error : Swift.Error {

        case decode
    }

    public unowned let urlSession: URLSession

    public let url: URL

    public init(urlSession: URLSession = .shared, url: URL) {
        self.urlSession = urlSession
        self.url = url
    }

    @Published private(set) public var loadingState: RemoteContentLoadingState<UIImage, Float?> = .initial

    public func load() {
        guard !loadingState.isInProgress else {
            return
        }

        // Set state to in progress
        loadingState = .inProgress(nil)

        // Start loading
        cancellable = urlSession
            .dataTaskPublisher(for: url)
            .map {
                guard let value = UIImage(data: $0.data) else {
                    return .failure(Error.decode)
                }

                return .success(value)
            }
            .catch {
                Just(.failure($0))
            }
            .receive(on: RunLoop.main)
            .assign(to: \.loadingState, on: self)
    }

    public func cancel() {
        guard loadingState.isInProgress else {
            return
        }

        // Reset loading state
        loadingState = .initial

        // Stop loading
        cancellable?.cancel()
        cancellable = nil
    }

    private var cancellable: AnyCancellable?
}
