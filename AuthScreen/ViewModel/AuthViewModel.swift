import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var state = AuthState()
    private var timerCancellable: AnyCancellable?
    private let service = AuthService.shared
    
    // MARK: - Phone
    func updatePhone(_ value: String) {
        state.phoneNumber = formatPhone(value)
        state.isPhoneNumberValid = isValidPhone(state.phoneNumber)
    }
    
    func nextFromPhone() {
        guard state.isPhoneNumberValid else { return }
        state.phase = .codeInput
        state.error = nil
        sendCode()
    }
    
    private func sendCode() {
        print("[Auth] Отправка кода на номер: \(state.phoneNumber)")
        service.sendCode(to: state.phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("[Auth] Код успешно отправлен")
                    self?.startTimer()
                case .failure(let error):
                    print("[Auth] Ошибка отправки кода: \(error.localizedDescription)")
                    self?.state.error = error.localizedDescription
                }
            }
        }
    }
    
    //MARK: - Register
    func registerButton() {
        print("Зарегистрироваться")
    }
    
    
    // MARK: - Code
    func updateCode(at index: Int, value: String) {
        guard index < 5 else { return }
        let filtered = String(value.prefix(1).filter { $0.isNumber })
        state.code[index] = filtered
        state.isCodeValid = state.code.joined().count == 5
        state.error = nil
    }
    
    func verifyCode() {
        let code = state.code.joined()
        print("[Auth] Проверка кода: \(code)")
        if code == "12345" {
            print("[Auth] Код верный — успех!")
            state.error = nil
        } else {
            print("[Auth] Код неверный — ошибка!")
            state.error = "Код неверный. Попробуйте ещё раз."
        }
    }
    
    func resendCode() {
        print("[Auth] Повторная отправка кода на номер: \(state.phoneNumber)")
        state.code = Array(repeating: "", count: 5)
        state.error = nil
        sendCode()
    }
    
    // MARK: - Timer
    private func startTimer() {
        state.timer = 30
        state.canResendCode = false
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.state.timer > 0 {
                    self.state.timer -= 1
                } else {
                    self.state.canResendCode = true
                    self.timerCancellable?.cancel()
                }
            }
    }
    
    // MARK: - Utils
    // ... existing code ...
        private func formatPhone(_ value: String) -> String {
            // Маска +7 XXX XXX-XX-XX
            let digits = value.filter { $0.isNumber }
            let limitedDigits: String
            if digits.hasPrefix("7") {
                limitedDigits = String(digits.prefix(11))
            } else if digits.hasPrefix("8") {
                limitedDigits = "7" + String(digits.dropFirst().prefix(10))
            } else {
                limitedDigits = "7" + String(digits.prefix(10))
            }
            var result = "+7"
            let chars = Array(limitedDigits)
            if chars.count > 1 {
                result += " "
                for i in 1..<min(chars.count, 4) {
                    result.append(chars[i])
                }
            }
            if chars.count > 4 {
                result += " "
                for i in 4..<min(chars.count, 7) {
                    result.append(chars[i])
                }
            }
            if chars.count > 7 {
                result += "-"
                for i in 7..<min(chars.count, 9) {
                    result.append(chars[i])
                }
            }
            if chars.count > 9 {
                result += "-"
                for i in 9..<min(chars.count, 11) {
                    result.append(chars[i])
                }
            }
            return result
        }
    
    private func isValidPhone(_ value: String) -> Bool {
        let digits = value.filter { $0.isNumber }
        return digits.count == 11 && digits.first == "7"
    }
}
