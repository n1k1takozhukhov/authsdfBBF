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


struct InputLabel: View {
    let title: String
    let required: Bool

    var body: some View {
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
    }
}

//struct InputField: View {
//    let title: String
//    let required: Bool
//    @Binding var text: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            InputLabel(title: title, required: required)
//            
//            TextField("+7", text: $text)
//                .keyboardType(.phonePad)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.4))
//                )
//        }
//    }
//}
//
struct InputField: View {
    let title: String
    let required: Bool
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title + (required ? " *" : ""))
                .foregroundColor(.gray)
                .font(.subheadline)

            TextField("", text: $text)
                .keyboardType(.numberPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
        }
    }
}


//MARK: - TextStyles modifiers
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 8)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold, design: .default))
            .foregroundColor(.primaryBold)
    }
}


extension View {
    func titleStyle() -> some View {
        self.modifier(TitleModifier())
    }
}

struct PrimaryModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.primaryBold)
            .font(.system(size: 16))

    }
}

extension View {
    func primaryModifier() -> some View {
        self.modifier(PrimaryModifier())
    }
}
