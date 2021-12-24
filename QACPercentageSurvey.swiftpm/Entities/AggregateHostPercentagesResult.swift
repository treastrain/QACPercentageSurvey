//
//  AggregateHostPercentagesResult.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/12.
//

import Foundation

public struct AggregateHostPercentagesResult: Codable {
    public var total: Int
    public var details: [String : Int]
    
    public init() {
        self.total = 0
        self.details = [:]
    }
    
    public mutating func add(host: String) {
        total += 1
        details[host, default: 0] += 1
    }
    
    public var encodedData: Data {
        return try! JSONEncoder.default.encode(self)
    }
}
