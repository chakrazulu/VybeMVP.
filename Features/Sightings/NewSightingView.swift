//
//  NewSightingView.swift
//  VybeMVP
//
//  View for creating new number sightings with photo capture
//

import SwiftUI
import PhotosUI
import CoreLocation

struct NewSightingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var sightingsManager = SightingsManager.shared
    @StateObject private var locationManager = LocationManager.shared
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    // Form state
    @State private var selectedNumber: Int = 1
    @State private var title = ""
    @State private var note = ""
    @State private var significance = ""
    @State private var capturedImage: UIImage?
    @State private var useCurrentLocation = true
    @State private var locationName = ""
    
    // UI state
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isSaving = false
    @State private var keyboardHeight: CGFloat = 0
    
    // Initialize with focus number if available
    init() {
        let focusNumber = FocusNumberManager.shared.selectedFocusNumber
        _selectedNumber = State(initialValue: focusNumber > 0 ? focusNumber : 1)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Number selector
                        numberSelectorSection
                        
                        // Photo section
                        photoSection
                        
                        // Details form
                        detailsSection
                        
                        // Location section
                        locationSection
                        
                        // Save button
                        saveButton
                    }
                    .padding()
                    .padding(.bottom, keyboardHeight)
                }
            }
            .navigationTitle("New Sighting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $capturedImage, sourceType: imageSourceType)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                keyboardHeight = 0
            }
        }
    }
    
    // MARK: - View Sections
    
    private var numberSelectorSection: some View {
        VStack(spacing: 15) {
            Text("Which number did you spot?")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                ForEach(1...9, id: \.self) { number in
                    NumberButton(
                        number: number,
                        isSelected: selectedNumber == number,
                        action: {
                            selectedNumber = number
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var photoSection: some View {
        VStack(spacing: 15) {
            Text("Capture the moment")
                .font(.headline)
                .foregroundColor(.white)
            
            if let image = capturedImage {
                // Show captured image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(15)
                    .overlay(
                        // Delete button
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    capturedImage = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.black.opacity(0.5)))
                                }
                                .padding(10)
                            }
                            Spacer()
                        }
                    )
            } else {
                // Photo capture buttons
                HStack(spacing: 20) {
                    PhotoCaptureButton(
                        title: "Camera",
                        icon: "camera.fill",
                        action: {
                            imageSourceType = .camera
                            showingImagePicker = true
                        }
                    )
                    
                    PhotoCaptureButton(
                        title: "Library",
                        icon: "photo.fill",
                        action: {
                            imageSourceType = .photoLibrary
                            showingImagePicker = true
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var detailsSection: some View {
        VStack(spacing: 20) {
            // Title field
            VStack(alignment: .leading, spacing: 8) {
                Text("Title (optional)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("e.g., License plate magic", text: $title)
                    .textFieldStyle(CosmicTextFieldStyle())
            }
            
            // Note field
            VStack(alignment: .leading, spacing: 8) {
                Text("Note (optional)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                TextEditor(text: $note)
                    .frame(height: 80)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
            
            // Significance field
            VStack(alignment: .leading, spacing: 8) {
                Text("What made this special? (optional)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("e.g., Saw it right after thinking about...", text: $significance)
                    .textFieldStyle(CosmicTextFieldStyle())
            }
        }
    }
    
    private var locationSection: some View {
        VStack(spacing: 15) {
            Toggle(isOn: $useCurrentLocation) {
                Label("Use current location", systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .purple))
            
            if !useCurrentLocation {
                TextField("Location name", text: $locationName)
                    .textFieldStyle(CosmicTextFieldStyle())
            } else if let location = locationManager.currentLocation {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                    Text("Location captured")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var saveButton: some View {
        Button(action: saveSighting) {
            HStack {
                if isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                    Text("Save Sighting")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(28)
            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isSaving)
        .padding(.top, 10)
    }
    
    // MARK: - Actions
    
    private func saveSighting() {
        isSaving = true
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Get location if enabled
        let location = useCurrentLocation ? locationManager.currentLocation : nil
        let finalLocationName = useCurrentLocation ? nil : (locationName.isEmpty ? nil : locationName)
        
        // Create sighting
        sightingsManager.createSighting(
            number: selectedNumber,
            title: title.isEmpty ? nil : title,
            note: note.isEmpty ? nil : note,
            significance: significance.isEmpty ? nil : significance,
            image: capturedImage,
            location: location,
            locationName: finalLocationName
        )
        
        // Success feedback and dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
            dismiss()
        }
    }
}

// MARK: - Supporting Views

struct NumberButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    private var sacredColor: Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0)
        case 9: return .white
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                isSelected ? sacredColor.opacity(0.8) : Color.white.opacity(0.2),
                                isSelected ? sacredColor.opacity(0.4) : Color.white.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 35
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(isSelected ? sacredColor : Color.white.opacity(0.3), lineWidth: 2)
                    )
                
                Text("\(number)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

struct PhotoCaptureButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct CosmicTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    NewSightingView()
        .environmentObject(FocusNumberManager.shared)
} 