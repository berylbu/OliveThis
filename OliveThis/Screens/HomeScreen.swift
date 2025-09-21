//
//  HomeScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import SwiftUI

struct HomeScreen: View {
        
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    CategoryListScreen()
                }
            } label: {
                Label("Categories", systemImage: "square.grid.2x2")
            }
            
            Tab {
                NavigationStack {
                    LocationsScreen()
                }
            } label: {
                Label("Friends", systemImage: "person.3")
            }
            
            Tab {
                NavigationStack {
                    LocationsScreen()
                }
            } label: {
                Label("Recs to Follow", systemImage: "staroflife")
            }
            
            Tab {
                NavigationStack {
                    LocationsScreen()
                }
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Tab {
                NavigationStack {
                    AccountScreen()
                }
            } label: {
                Label("Account", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    HomeScreen()
        .environment(OliveThisStore(httpClient: HTTPClient()))
}
