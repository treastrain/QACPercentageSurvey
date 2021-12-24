//
//  main.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/23.
//

import Foundation
import AppModule

print("AggregateHostPercentages")

Task {
    do {
        var result = AggregateHostPercentagesResult()
        
        let fileURLs = try FileHelper.contentsOfOutputsDirectory()
        for fileURL in fileURLs {
            let data = try Data(contentsOf: fileURL)
            let articlesData = QACalendarArticlesData(from: data)
            let articles = articlesData.articles
            for article in articles {
                guard let host = article.url?.host else {
                    continue
                }
                result.add(host: host)
            }
        }
        
        let data = result.encodedData
        try FileHelper.write(to: .result, data: data)
        
        print("Total:", result.total)
        result.details.sorted { $0.key < $1.key }.sorted { $0.value > $1.value }.forEach { host, count in
            print("\t", host)
            print("\t\t", (Double(count) / Double(result.total)).formatted(.percent), "(\(count))")
        }
    }
    
    do {
        let categories = ["プレゼント", "Qiita主催", "プログラミング言語", "ライブラリ・フレームワーク", "データベース", "Webテクノロジー", "モバイル", "DevOps・インフラ", "IoT・ハードウェア", "OS", "エディタ", "学術", "サービス・アプリケーション", "企業・学校・団体", "その他", "未設定"]
        for category in categories {
            var result = AggregateHostPercentagesResult()
            
            let fileURLs = try FileHelper.contentsOfOutputsDirectory()
            for fileURL in fileURLs {
                let data = try Data(contentsOf: fileURL)
                let articlesData = QACalendarArticlesData(from: data)
                guard articlesData.calendarMetaData.category == category else {
                    continue
                }
                
                let articles = articlesData.articles
                for article in articles {
                    guard let host = article.url?.host else {
                        continue
                    }
                    result.add(host: host)
                }
            }
            let data = result.encodedData
            try FileHelper.write(to: .result, data: data)
            
            print(category, "Total:", result.total)
            result.details.sorted { $0.key < $1.key }.sorted { $0.value > $1.value }.forEach { host, count in
                print("\(host),\(count)")
            }
        }
    }
    
    exit(0)
}

RunLoop.current.run()
