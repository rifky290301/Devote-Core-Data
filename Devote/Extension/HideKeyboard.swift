//
//  HideKeyboard.swift
//  Devote
//
//  Created by MarthaBakManis on 20/01/25.
//

import SwiftUI

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif
