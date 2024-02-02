//
//  ContentViewModel.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/02.
//

import SwiftUI
import Factory

class ContentViewModel: ObservableObject {
    @Injected(\.authState)
    var authState
}
