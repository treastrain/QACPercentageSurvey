//
//  1-StoreCalendarsDataView.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

import SwiftUI

@MainActor
struct StoreCalendarsDataView: View {
    @ObservedObject private var session = MyURLSession.shared
    
    @State private var isLoadingNumberOfCalendars = true
    @State private var numberOfCalendars: Int? = nil
    @State private var errorDescriptionLoadingNumberOfCalendars: String? = nil
    
    @State private var isLoadingCalendarsData = true
    @State private var lastPageNumberOfCalendarsData = 0
    @State private var progressOfCalendarsData = 0
    @State private var errorDescriptionLoadingCalendarsData: String? = nil
    
    @State private var outputURL: URL? = nil
    @State private var isPresentedToActivityView = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("\(MyURLSession.shared.waitingURL?.absoluteString ?? "なし")")
                    }
                } header: {
                    Text("\(MyURLSession.shared.waitingTime) 秒後に接続します…")
                        .monospacedDigit()
                }
                
                Section {
                    HStack {
                        Text("カレンダーの総数")
                        Spacer()
                        if let numberOfCalendars = numberOfCalendars {
                            Text("\(numberOfCalendars)")
                        } else {
                            ActivityIndicatorView()
                        }
                    }
                } header: {
                    HStack {
                        Text("カレンダーの総数")
                        if isLoadingNumberOfCalendars { ActivityIndicatorView() }
                    }
                } footer: {
                    if let str = errorDescriptionLoadingNumberOfCalendars { Text(str) }
                }
                
                Section {
                    HStack {
                        Text("最後のページ")
                        Spacer()
                        if lastPageNumberOfCalendarsData == .zero {
                            ActivityIndicatorView()
                        } else {
                            Text("\(lastPageNumberOfCalendarsData)")
                        }
                    }
                    HStack {
                        Text("取得中のページ")
                        Spacer()
                        Text("\(progressOfCalendarsData)")
                    }
                } header: {
                    HStack {
                        Text("新着カレンダー一覧")
                        if isLoadingCalendarsData { ActivityIndicatorView() }
                    }
                } footer: {
                    if let str = errorDescriptionLoadingCalendarsData { Text(str) }
                }
                
                Section {
                    Button {
                        isPresentedToActivityView.toggle()
                    } label: {
                        Label("出力結果を別な場所に書き出す", systemImage: "square.and.arrow.up")
                    }
                    .disabled(outputURL == nil)
                }
            }
            .navigationTitle("Store Calendars Data")
        }
        .sheet(isPresented: $isPresentedToActivityView) {
            if let outputURL = outputURL {
                ActivityView(activityItems: [outputURL])
            }
        }
        .task(execute)
    }
    
    @Sendable
    private func execute() async {
        do {
            // 全カレンダー数を表示
            isLoadingNumberOfCalendars = true
            numberOfCalendars = nil
            
            numberOfCalendars = try await QACHelper.numberOfCalendars()
            isLoadingNumberOfCalendars = false
            print("カレンダーの総数は", numberOfCalendars ?? "nil", "です")
            errorDescriptionLoadingNumberOfCalendars = nil
        } catch {
            print(error)
            isLoadingNumberOfCalendars = false
            errorDescriptionLoadingNumberOfCalendars = error.localizedDescription
            return
        }
        
        do {
            // 新着カレンダー一覧の最後のページ番号を取得
            isLoadingCalendarsData = true
            lastPageNumberOfCalendarsData = 0
            progressOfCalendarsData = 0
            
            lastPageNumberOfCalendarsData = try await QACHelper.lastPageNumberInCalendarList()
            print("新着カレンダー一覧の最後のページ番号は", lastPageNumberOfCalendarsData, "でした")
            
            // 登録されているすべてのカレンダーの URL を取得
            var calendars: [QACalendar] = []
            for page in 1...lastPageNumberOfCalendarsData {
                progressOfCalendarsData = page
                print("全", lastPageNumberOfCalendarsData, "ページ中", page, "ページ目の情報を取得します…")
                calendars += try await QACHelper.qaCalendars(page: page)
                print("全", lastPageNumberOfCalendarsData, "ページ中", page, "ページ目の情報を取得しました")
            }
            
            // JSON ファイルとして保存する
            let calendarsData = QACalendarsData(createdAt: Date(), calendars: calendars)
            outputURL = try FileHelper.write(to: .calendarsDataJSON, data: calendarsData.encodedData)
            print(FileHelper.FileName.calendarsDataJSON.rawValue, "を書き出しました\n", outputURL!)
            
            isLoadingCalendarsData = false
            errorDescriptionLoadingCalendarsData = nil
        } catch {
            print(error)
            isLoadingCalendarsData = false
            errorDescriptionLoadingCalendarsData = "ERROR: " + error.localizedDescription
            return
        }
    }
}
