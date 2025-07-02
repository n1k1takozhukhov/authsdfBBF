//
//  AuthService.swift
//  AuthScreen
//
//  Created by Никита Кожухов on 03.07.2025.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func sendCode(to phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    func verifyCode(_ code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if code == "1234" {
                completion(.success(()))
            } else {
                completion(.failure(AuthError.invalidCode))
            }
        }
    }
}

enum AuthError: Error, LocalizedError {
    case invalidCode
    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "Тут какая-то ошибка"
        }
    }
}
