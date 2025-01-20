//
//  BackgroundImage.swift
//  Devote
//
//  Created by MarthaBakManis on 20/01/25.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
      Image("rocket")
        .antialiased(true)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    BackgroundImageView()
}
