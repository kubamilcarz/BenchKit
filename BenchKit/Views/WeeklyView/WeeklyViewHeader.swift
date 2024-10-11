//
//  WeeklyViewHeader.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

struct WeeklyViewHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button { } label: {
                        Image(systemName: "chevron.backward")
                    }
                    Spacer()
                    Button { } label: {
                        Image(systemName: "chevron.forward")
                    }
                }
                
                DatePicker("Week", selection: .constant(.now), displayedComponents: .date)
                    .labelsHidden()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            
            Divider()
        }
    }
}

#Preview {
    WeeklyViewHeader()
}
