import SwiftUI

enum Field: Hashable {
    case phone
    case code(Int)
}

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Background()
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                
                starImage
                    .frame(height: 236)
                    .padding(40)
                
                Spacer()
                
                Group {
                    if viewModel.state.phase == .phoneInput {
                        phoneInputView
                    } else {
                        codeInputView
                    }
                }
                .offset(y: -keyboardHeight * 0.9)
                .animation(.easeInOut(duration: 0.3), value: keyboardHeight)
            }
            .ignoresSafeArea(edges: .bottom)
            
            .onAppear { setupKeyboardObservers() }
            .onDisappear { removeKeyboardObservers() }
        }
    }
    
    
    
    // MARK: - Phone Input
    private var phoneInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("login_title")
                .titleStyle()
            
            PhoneInputField(title: NSLocalizedString("phone_label", comment: ""), required: true, text: Binding(
                get: { viewModel.state.phoneNumber },
                set: { viewModel.updatePhone($0) })
            )
            .focused($focusedField, equals: .phone)
            
            PrimaryButton(title: NSLocalizedString("next_button", comment: ""), enabled: viewModel.state.isPhoneNumberValid) {
                viewModel.nextFromPhone()
                focusedField = nil
            }
            
            HStack(alignment: .center, spacing: 8) {
                
                Text("first_time_here")
                    .foregroundColor(.gray)
                Button("register_button") {
                    
                    // TODO: Навигация на регистрацию
//                    $viewModel.registerButton
                }
                .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 16))
            .padding(.top, 40)
            .padding(.bottom, 30)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 8)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = .phone
            }
        }
        .cardStyle()
    }
    
    // MARK: - Code Input
    private var codeInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("login_title")
                .titleStyle()
            
            Text("code_sent_message")
            + Text("\(viewModel.state.phoneNumber)")
                .foregroundColor(Color.primaryBold)
                .font(.system(size: 16))
            
            InputLabel(title: NSLocalizedString("enter_code_label", comment: ""), required: true)
            
            HStack(spacing: 20) {
                ForEach(0..<5, id: \ .self) { i in
                    TextField("", text: Binding(
                        get: { viewModel.state.code[i] },
                        set: { newValue in
                            let oldValue = viewModel.state.code[i]
                            viewModel.updateCode(at: i, value: newValue)
                            
                            if newValue.count > oldValue.count && i < 4 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = .code(i + 1)
                                }
                            }
                            else if newValue.count < oldValue.count && i > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = .code(i - 1)
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 56, height: 48)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                    .focused($focusedField, equals: .code(i))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            PrimaryButton(title: NSLocalizedString("next_button", comment: ""), enabled: viewModel.state.isCodeValid) {
                viewModel.verifyCode()
            }
            
            //MARK: - errear bar.
            if viewModel.state.error != nil {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 46)
                            .foregroundColor(Color.red)
                        
                        Text("error_message")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal, -20)
                .ignoresSafeArea()
            }
            
            if viewModel.state.canResendCode {
                Button("resend_code_button") {
                    viewModel.resendCode()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.orange)
                .padding(.top, 40)
                .padding(.bottom, 30)
            } else {
                Group {
                    let minutes = viewModel.state.timer / 60
                    let seconds = viewModel.state.timer % 60
                    
                    Text(String(format: "%d:%02d ", minutes, seconds)) + Text("resend_code_button")
                        .foregroundColor(Color.orangeDesing)
                        .font(.system(size: 16))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)
                .padding(.bottom, 30)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 8)
        .cardStyle()
        .onAppear {
            focusedField = .code(0)
        }
    }
    
    
    // MARK: - Star Image (Анимация/смена)
    private var starImage: some View {
        let imageName: String = {
            if viewModel.state.phase == .codeInput {
                return "starWinks"
            } else if viewModel.state.isPhoneNumberValid {
                return "starSleep"
            } else if focusedField == .phone {
                return "starRight"
            } else {
                return "starCenter"
            }
        }()
        
        return Image(imageName)
            .resizable()
            .frame(width: 236, height: 236)
            .animation(.easeInOut(duration: 0.3), value: imageName)
    }
    
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func hideKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
}

