//
//  RemoteContent.swift
//
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import Combine
import Foundation


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class RemoteContent<T> : ObservableObject {

    unowned let urlSession: URLSession

    let url: URL

    let decode: (_ data: Data) throws -> T

    init(urlSession: URLSession = .shared, url: URL, decode: @escaping (_ data: Data) throws -> T) {
        self.urlSession = urlSession
        self.url = url
        self.decode = decode
    }

    /// The state of the loading process.
    ///
    /// The `LoadingState` serves dual purpose:
    /// - represents the state of the loading process: none, in progress, success or failure;
    /// - keeps associated value relevant to the state of the loading process.
    ///
    /// This dual purpose allows `View` to switch over the state in its `body` and return different view in each case.
    ///
    enum LoadingState<T> {

        case none

        case inProgress

        case success(_ value: T)

        case failure(_ message: String)
    }

    @Published private(set) var loadingState: LoadingState<T> = .none

    func load() {
        guard cancellable == nil else {
            return
        }

        // Set state to in progress
        loadingState = .inProgress

        // Start loading
        cancellable = urlSession
            .dataTaskPublisher(for: url)
            .map { result in
                // Decode
                do {
                    let value = try self.decode(result.data)
                    return .success(value)
                }
                catch {
                    return .failure("\(error)")
                }
            }
            .catch { error in
                // Process error
                Just(.failure("\(error)"))
            }
            .receive(on: RunLoop.main)
            .assign(to: \.loadingState, on: self)
    }

    func cancel() {
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
