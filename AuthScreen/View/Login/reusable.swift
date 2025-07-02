import SwiftUI

struct PrimaryButton: View {
    let title: String
    let enabled: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(enabled ? Color.orange : Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(enabled ? .white : .secondaryInput)
        }
        .disabled(!enabled)
    }
}

struct CodeTextField: View {
    @Binding var text: String
    var focused: FocusState<Bool>.Binding
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 48, height: 48)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
            .focused(focused)
    }
}

struct ErrorText: View {
    let error: String?
    var body: some View {
        if let error = error {
            Text(error)
                .foregroundColor(.red)
                .font(.system(size: 14))
        }
    }
}

struct InputField: View {
    let title: String
    let required: Bool
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, design: .default))
                    .foregroundColor(.secondaryInput)
                if required {
                    Text("*")
                        .font(.system(size: 12 , design: .default))
                        .foregroundColor(.secondary)
                }
            }
            TextField("+7", text: $text)
                .keyboardType(.phonePad)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )
        }
    }
}
