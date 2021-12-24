//
//  JSONDecoder+Extensions.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

import Foundation

public extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
