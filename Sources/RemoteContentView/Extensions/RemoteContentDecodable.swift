//
//  RemoteContentDecodable.swift
//  
//
//  Created by Dmytro Anokhin on 10/08/2020.
//

import Foundation


public protocol RemoteContentDecodable {

    init?(data: Data)
}


#if canImport(UIKit)

import UIKit


extension UIImage : RemoteContentDecodable {}

#endif
