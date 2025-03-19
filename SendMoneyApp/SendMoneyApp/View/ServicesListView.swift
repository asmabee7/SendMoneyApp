//
//  ServicesListView.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import SwiftUI

struct ServicesListView: View {
    @EnvironmentObject var store: StoreManager

    var body: some View {
        List(store.state.services) { service in
            VStack {
                Text("RequestId")
                Text("ServiceName")
                Text("ProviderName")
                Text("Amount")
            }
        }
    }
}

#Preview {
    ServicesListView()
}
