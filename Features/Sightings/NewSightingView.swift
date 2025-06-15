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
    @State private var numberText: String = ""
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
        _numberText = State(initialValue: focusNumber > 0 ? String(focusNumber) : "")
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
            Text("What number did you spot?")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Enter any number sequence you saw")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            TextField("e.g., 11:11, 222, 1139, 7", text: $numberText)
                .textFieldStyle(CosmicTextFieldStyle())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
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
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
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
            } else if locationManager.currentLocation != nil {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                    Text("Current location will be saved")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                }
            } else {
                HStack {
                    Image(systemName: "location.slash")
                        .foregroundColor(.red)
                    Text("Location not available")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            locationManager.requestLocationPermission()
        }
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
        
        // Process number: store raw text but derive a numeric value for analysis
        let processedNumber = extractSingleDigit(from: numberText)
        
        // Create sighting
        sightingsManager.createSighting(
            number: processedNumber,
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
    
    /// Extracts a single digit from a complex number string using numerological reduction
    private func extractSingleDigit(from text: String) -> Int {
        // Remove all non-numeric characters
        let digits = text.compactMap { $0.wholeNumberValue }
        
        if digits.isEmpty {
            return 0
        }
        
        // Sum all digits
        var sum = digits.reduce(0, +)
        
        // Reduce to single digit (except master numbers 11, 22, 33)
        while sum > 9 && sum != 11 && sum != 22 && sum != 33 {
            sum = String(sum).compactMap { $0.wholeNumberValue }.reduce(0, +)
        }
        
        return sum
    }
}

// MARK: - Supporting Views

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