//
//  NSErrorExtension.swift
//  RSS-Parser
//
//  Created by Сергей on 14/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
