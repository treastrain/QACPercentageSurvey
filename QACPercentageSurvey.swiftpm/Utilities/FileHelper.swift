//
//  FileHelper.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/06.
//

import Foundation

public enum FileHelper {
    public enum FileName: CaseIterable {
        case calendarsDataJSON
        case failedCalendarsDataJSON
        case result
        case custom(String)
        
        public var rawValue: String {
            switch self {
            case .calendarsDataJSON:
                return "_calendarsData.json"
            case .failedCalendarsDataJSON:
                return "_failedCalendarsData.json"
            case .result:
                return "_result.json"
            case .custom(let string):
                return string
            }
        }
        
        public static var allCases: [Self] = [
            .calendarsDataJSON,
            .failedCalendarsDataJSON,
            .result
        ]
    }
    
    public static var outputsURL: URL {
        #if os(iOS) || os(tvOS) || os(watchOS)
        try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Outputs", isDirectory: true)
        #else
        URL(fileURLWithPath: #filePath) // FileHelper.swift
            .deletingLastPathComponent() // Utilities
            .deletingLastPathComponent() // AppModule
            .deletingLastPathComponent() // Sources
            .deletingLastPathComponent() // (repo root)
            .appendingPathComponent("Outputs", isDirectory: true)
        #endif
    }
    
    public static func read(from fileName: FileName) throws -> Data {
        try FileManager.default.createDirectory(at: outputsURL, withIntermediateDirectories: true)
        guard FileManager.default.changeCurrentDirectoryPath(outputsURL.path) else {
            throw Error.failedChangeCurrenctDirectory(path: outputsURL.path)
        }
        let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(fileName.rawValue)
        return try read(from: url)
    }
    
    public static func read(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
    
    @discardableResult
    public static func write(to fileName: FileName, data: Data) throws -> URL {
        try FileManager.default.createDirectory(at: outputsURL, withIntermediateDirectories: true)
        guard FileManager.default.changeCurrentDirectoryPath(outputsURL.path) else {
            throw Error.failedChangeCurrenctDirectory(path: outputsURL.path)
        }
        let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(fileName.rawValue)
        try data.write(to: url)
        return url
    }
    
    public static func contentsOfOutputsDirectory() throws -> [URL] {
        return try FileManager.default.contentsOfDirectory(at: FileHelper.outputsURL, includingPropertiesForKeys: nil).filter { url in
            url.pathExtension == "json"
            && !FileName.allCases.contains { $0.rawValue == url.lastPathComponent }
        }
    }
}

extension FileHelper {
    enum Error: Swift.Error, LocalizedError {
        case failedChangeCurrenctDirectory(path: String)
        
        var errorDescription: String? {
            switch self {
            case .failedChangeCurrenctDirectory(let path):
                return "パスの移動に失敗: \(path)"
            }
        }
    }
}
