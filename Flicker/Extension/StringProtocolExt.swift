//
//  StringProtocolExt.swift
//  Flicker
//
//  Created by Илья Востров on 01.07.2024.
//

import UIKit

extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
