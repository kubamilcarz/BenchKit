//
//  WorkoutGalleryView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct WorkoutGalleryView: View {
    var body: some View {
        VStack(spacing: 30) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 12).fill(.red.gradient)
                        .aspectRatio(3/2, contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(maxHeight: .infinity)
                        .scrollTransition(.interactive, axis: .horizontal) { effect, phase in
                            effect
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                        }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 15, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("By muscles")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoundedRectangle(cornerRadius: 12).fill(.background).frame(height: 200)
                }
                
                VStack(spacing: 10) {
                    Text("By pattern")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoundedRectangle(cornerRadius: 12).fill(.background).frame(height: 200)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

#Preview {
    WorkoutGalleryView()
}
