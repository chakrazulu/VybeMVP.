import SwiftUI

/// Quick test view to verify Sacred Geometry Assets work
struct TestSacredGeometry: View {
    let focusNumber = 247    // Example focus number
    let realmNumber = 139    // Example realm number
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🔮 Sacred Geometry Test")
                .font(.title)
                .fontWeight(.bold)
            
            // Test automatic asset selection
            let selectedAsset = SacredGeometryAsset.asset(
                focusNumber: focusNumber,
                realmNumber: realmNumber
            )
            
            // Display the selected sacred geometry
            selectedAsset.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .background(Color.black.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 8) {
                Text(selectedAsset.displayName)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Number: \(selectedAsset.numerologicalValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Chakra: \(selectedAsset.chakra)")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text(selectedAsset.mysticalSignificance)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
            }
            
            // Show calculation
            Text("Focus: \(focusNumber) + Realm: \(realmNumber)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    TestSacredGeometry()
} 