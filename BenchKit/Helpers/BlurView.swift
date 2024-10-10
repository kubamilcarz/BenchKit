//
//  BlurView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var removeAllFilters = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "guassianBlur"
                    })
                }
            }
        }
    }
}
