//
//  FirstPageViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import Foundation

class FirstPageViewModel: ObservableObject {
    @Published var goToSecondPage = false

    func startQuizTapped() {
        goToSecondPage = true
    }
}
