//
//  QACPercentageSurveyApp.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/17.
//

import SwiftUI

@main
struct QACPercentageSurveyApp: App {
    @State private var isPresentedToStoreCalendarsDataView = false
    @State private var isPresentedToStoreArticlesDataView = false
    @State private var isPresentedToAggregateHostPercentagesResultView = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Button {
                    isPresentedToStoreCalendarsDataView.toggle()
                } label: {
                    Label("Store calendars data", systemImage: "1.circle")
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $isPresentedToStoreCalendarsDataView) {
                    StoreCalendarsDataView()
                }
                
                Button {
                    isPresentedToStoreArticlesDataView.toggle()
                } label: {
                    Label("Store articles data", systemImage: "2.circle")
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $isPresentedToStoreArticlesDataView) {
                    StoreArticlesDataView()
                }
                
                Button {
                    isPresentedToAggregateHostPercentagesResultView.toggle()
                } label: {
                    Label("Aggregate host percentages result", systemImage: "3.circle")
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $isPresentedToAggregateHostPercentagesResultView) {
                    AggregateHostPercentagesResultView()
                }
            }
            .tint(.accentColor)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
        }
    }
}
