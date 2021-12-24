//
//  QACHelper.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

import Foundation
import Kanna

public enum QACHelper {
    public enum Error: Swift.Error, LocalizedError {
        case failedToParse
        
        var errorDescription: String {
            switch self {
            case .failedToParse:
                return "パースに失敗"
            }
        }
    }
}
