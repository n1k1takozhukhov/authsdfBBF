import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case phone
        case code(Int)
    }
    
    var body: some View {
        ZStack {
            Background()
            VStack(spacing: 0) {
                Spacer()
                if viewModel.state.phase == .phoneInput {
                    phoneInputView
                } else {
                    codeInputView
                }
            }
            .padding(.bottom, 32)
            starImage
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Phone Input
    private var phoneInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ввод")
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundColor(.primaryBold)
            InputField(title: "Телефон", required: true, text: Binding(
                get: { viewModel.state.phoneNumber },
                set: { viewModel.updatePhone($0) })
            )
            .focused($focusedField, equals: .phone)
            PrimaryButton(title: "Далее", enabled: viewModel.state.isPhoneNumberValid) {
                viewModel.nextFromPhone()
                focusedField = nil
            }
            HStack(alignment: .center, spacing: 8) {
                Text("Впервые тут?")
                    .foregroundColor(.gray)
                Button("Зарегистрироваться") {
                    // TODO: Навигация на регистрацию
                }
                .foregroundColor(.orange)
            }
            .font(.system(size: 16))
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 8)
        .onAppear { focusedField = .phone }
    }
    
    // MARK: - Code Input
    private var codeInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Код подтверждения")
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundColor(.primaryBold)
            Text("На номер отправлен код: \(viewModel.state.phoneNumber)")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            HStack(spacing: 12) {
                ForEach(0..<4, id: \ .self) { i in
                    TextField("", text: Binding(
                        get: { viewModel.state.code[i] },
                        set: { viewModel.updateCode(at: i, value: $0) }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 48, height: 48)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
                }
            }
            PrimaryButton(title: "Далее", enabled: viewModel.state.isCodeValid) {
                viewModel.verifyCode()
            }
            if let error = viewModel.state.error {
                HStack {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.top, 2)
                    Spacer()
                }
            }
            if viewModel.state.canResendCode {
                Button("Отправить код повторно") {
                    viewModel.resendCode()
                }
                .foregroundColor(.orange)
            } else {
                Text("Отправить код повторно через \(viewModel.state.timer) сек.")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 8)
    }
    
    // MARK: - Star Image (Анимация/смена)
    private var starImage: some View {
        let imageName: String = {
            if viewModel.state.phase == .codeInput {
                return "starWinks"
            } else if viewModel.state.isPhoneNumberValid {
                return "starCenter"
            } else if focusedField == .phone {
                return "starRight"
            } else {
                return "starSleep"
            }
        }()
        return Image(imageName)
            .resizable()
            .frame(width: 236, height: 236)
            .animation(.easeInOut, value: imageName)
            .offset(y: -180)
    }
}

#Preview {
    ContentView()
}

