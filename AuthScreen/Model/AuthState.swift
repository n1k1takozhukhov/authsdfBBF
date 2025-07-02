//
//  AuthState.swift
//  AuthScreen
//
//  Created by Никита Кожухов on 02.07.2025.
//

import Foundation

enum AuthPhase {
    case phoneInput
    case codeInput
}

struct AuthState {
    var phase: AuthPhase = .phoneInput
    var phoneNumber: String = ""
    var code: [String] = Array(repeating: "", count: 6)
    var isPhoneNumberValid: Bool = false
    var isCodeValid: Bool = false
    var error: String? = nil
    var timer: Int = 30
    var canResendCode: Bool = false
}
