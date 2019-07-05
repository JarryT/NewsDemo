//
//  String+Extension.swift
//  Fun
//
//  Created by william on 2018/12/11.
//  Copyright © 2018 FF. All rights reserved.
//

import CommonCrypto
import Foundation
import UIKit

extension String {
    public func substring(from index: Int) -> String {
        if count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex ..< self.endIndex]

            return String(subString)
        } else {
            return self
        }
    }
}

extension String {
    func dateString(using format: String) -> String {
        let timeInterval = TimeInterval(self)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
}

public extension String {

    /// Hashing algorithm for hashing a string instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of output desired, defaults to .hex.
    /// - Returns: The requested hash output or nil if failure.
    func hashed(_ type: HashType, output: HashOutputType = .hex) -> String? {

        // convert string to utf8 encoded data
        guard let message = data(using: .utf8) else { return nil }
        return message.hashed(type, output: output)
    }
}

extension String {
    func substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > count {
            return nil
        }
        let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex ..< endIndex])
    }

    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

extension String {
    func isEmailAddress() -> Bool {
        let predicateStr = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,18}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with: self)
    }
}

public extension Int {
    static func randomIntNumber(lower: Int = 0, upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }

    static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}

public extension Float {
    static func randomFloatNumber(lower: Float = 0, upper: Float = 100) -> Float {
        return (Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
    }
}

public extension CGFloat {
    static func randomCGFloatNumber(lower: CGFloat = 0, upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
    }
}
