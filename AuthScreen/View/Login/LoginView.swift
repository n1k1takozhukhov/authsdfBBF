import SwiftUI

enum Field: Hashable {
    case phone
    case code(Int)
}

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    @State private var loginViewHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Background()
            
            VStack(spacing: 0) {
                GeometryReader { geo in
                    
                    VStack(spacing: 0) {
                        Spacer()

                        starImage
                            .padding(.bottom, -40)
                        
                        if viewModel.state.phase == .phoneInput {
                            phoneInputView
                        } else {
                            codeInputView
                        }
                    }
                    .background(Color.clear)
                    
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Phone Input
    private var phoneInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Вход")
                .titleStyle()
            
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
                    viewModel.registerButton()
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
        .onAppear { focusedField = .phone }
        .cardStyle()
    }
    
    // MARK: - Code Input
    private var codeInputView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Вход")
                .titleStyle()
            
            Text("Мы выслали вам код подтверждения на \nномер ")
            + Text("\(viewModel.state.phoneNumber)")
                .foregroundColor(Color.primaryBold)
                .font(.system(size: 16))
            
            InputLabel(title: "Введите код", required: true)
            
            HStack(spacing: 20) {
                ForEach(0..<5, id: \ .self) { i in
                    TextField("", text: Binding(
                        get: { viewModel.state.code[i] },
                        set: { viewModel.updateCode(at: i, value: $0) }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 56, height: 48)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            PrimaryButton(title: "Далее", enabled: viewModel.state.isCodeValid) {
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
                        
                        Text("Тут какаято ошибка")
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
                Button("Отправить код повторно") {
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
                    
                    Text(String(format: "%d:%02d", minutes, seconds))
                    + Text(" Отправить код повторно")
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
    }
    
    
    // MARK: - Star Image (Анимация/смена)
    private var starImage: some View {
        let imageName: String = {
            if viewModel.state.phase == .codeInput {
                return "starWinks" //starWinks
            } else if viewModel.state.isPhoneNumberValid {
                return "starSleep" //starCenter
            } else if focusedField == .phone {
                return "starRight" //starRight
            } else {
                return "starCenter" //starSleep
            }
        }()
        return Image(imageName)
            .resizable()
            .frame(width: 236, height: 236)
            .animation(.easeInOut, value: imageName)
            .offset(y: -142)
        
    }
}

#Preview {
    ContentView()
}

