import SwiftUI

struct NumberCell: View {
    let number: Int
    let isSelected: Bool
    var description: String?
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                VStack(spacing: 4) {
                    Text("\(number)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(isSelected ? .white : .primary)
                        .fixedSize(horizontal: true, vertical: true)
                    
                    if let description = description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(isSelected ? .white : .secondary)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
            }
            .frame(width: 60, height: 60)
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    HStack {
        NumberCell(number: 0, isSelected: true, description: "Void")
        NumberCell(number: 1, isSelected: false)
        NumberCell(number: 2, isSelected: true)
    }
    .padding()
} 
