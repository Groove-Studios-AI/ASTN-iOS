import SwiftUI
import PhotosUI
import UIKit

struct ProfilePictureView: View {
    // Callback when the user completes the profile picture step
    var onComplete: (UIImage?) -> Void
    
    // State variables
    @State private var selectedImage: UIImage?
    @State private var isShowingLibraryPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showCameraAlert = false
    
    // Colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressIndicator(currentStep: 3, totalSteps: 3)
                .padding(.bottom, 20)
                .padding(.horizontal, 24)
            
            // App Personalization header
            HStack {
                Text("App Personalization")
                    .font(.custom("Magistral", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Skip button
                Button(action: {
                    onComplete(nil)
                }) {
                    Text("Skip >")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            // Description text
            Text("Add a profile picture to show the world your good side!")
                .font(.custom("Magistral", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            
            Spacer()
            
            // Profile picture circle
            ZStack {
                if let selectedImage = selectedImage {
                    // Show selected image
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    // Show placeholder
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                    
                    // Camera icon
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .offset(x: 20, y: -20)
                        )
                }
            }
            .padding(.bottom, 60)
            
            Spacer()
            
            // Action buttons
            if selectedImage == nil {
                // Upload from library button
                Button(action: {
                    isShowingLibraryPicker = true
                }) {
                    HStack {
                        Text("Upload from Library")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(brandBlue)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Take a picture button
                Button(action: {
                    // Check if camera is available first
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        isShowingCameraPicker = true
                    } else {
                        // Show alert if camera is not available
                        showCameraAlert = true
                    }
                }) {
                    Text("Take a Picture")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .alert("Camera Not Available", isPresented: $showCameraAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Your device does not have a camera available or camera access is restricted.")
                }
            } else {
                // Looks good! button
                Button(action: {
                    onComplete(selectedImage)
                }) {
                    HStack {
                        Text("Looks Good!")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(brandBlue)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Retake button
                Button(action: {
                    selectedImage = nil
                }) {
                    Text("Retake")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(brandBlack)
        // Photo library picker
        .sheet(isPresented: $isShowingLibraryPicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        // Camera picker
        .sheet(isPresented: $isShowingCameraPicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
    }
}

// Image Picker component to handle camera and photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType
    
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
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
