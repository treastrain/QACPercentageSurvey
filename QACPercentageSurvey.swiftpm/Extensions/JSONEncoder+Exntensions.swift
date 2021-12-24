//
//  JSONEncoder+Exntensions.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

import Foundation

public extension JSONEncoder {
    static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        return encoder
    }
}
