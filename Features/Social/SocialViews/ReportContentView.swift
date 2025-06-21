//
//  ReportContentView.swift
//  VybeMVP
//
//  User interface for reporting inappropriate content
//

import SwiftUI

/**
 * View for reporting inappropriate content
 * Required for App Store compliance with user-generated content
 */
struct ReportContentView: View {
    let contentId: String
    let contentType: ReportContentType
    let reportedUserId: String
    let reportedUserName: String
    let reporterName: String
    
    @StateObject private var reportManager = ReportManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedReason: ReportReason = .spam
    @State private var customReason: String = ""
    @State private var description: String = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                // Header Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.shield.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                            
                            Text("Report \(contentType.displayName)")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("Help us keep VybeMVP safe by reporting content that violates our community guidelines.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // Reported Content Info
                Section("Reporting") {
                    HStack {
                        Text("Content Type:")
                        Spacer()
                        Text(contentType.displayName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("User:")
                        Spacer()
                        Text(reportedUserName)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Reason Selection
                Section("Why are you reporting this \(contentType.displayName.lowercased())?") {
                    ForEach(ReportReason.allCases, id: \.self) { reason in
                        ReasonSelectionRow(
                            reason: reason,
                            isSelected: selectedReason == reason,
                            onSelect: { selectedReason = reason }
                        )
                    }
                }
                
                // Custom Reason (if "Other" is selected)
                if selectedReason == .other {
                    Section("Please specify") {
                        TextField("Describe the issue...", text: $customReason, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                
                // Additional Description
                Section("Additional Details (Optional)") {
                    TextField("Provide any additional context that might help us review this report...", text: $description, axis: .vertical)
                        .lineLimit(3...8)
                }
                
                // Submit Button
                Section {
                    Button(action: submitReport) {
                        HStack {
                            if reportManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "paperplane.fill")
                            }
                            
                            Text("Submit Report")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(canSubmit ? .red : .gray)
                        )
                    }
                    .disabled(!canSubmit || reportManager.isLoading)
                }
                .listRowBackground(Color.clear)
                
                // Guidelines Section
                Section("Community Guidelines") {
                    Text("VybeMVP is a space for spiritual growth and positive energy. We don't tolerate harassment, hate speech, spam, or content that makes our community feel unsafe.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Report Content")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Report Submitted", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for helping keep our community safe. We'll review your report and take appropriate action.")
            }
            .alert("Error", isPresented: .constant(reportManager.errorMessage != nil)) {
                Button("OK") {
                    reportManager.clearMessages()
                }
            } message: {
                Text(reportManager.errorMessage ?? "")
            }
            .onChange(of: reportManager.successMessage) { _, newValue in
                if newValue != nil {
                    showingConfirmation = true
                    reportManager.clearMessages()
                }
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var canSubmit: Bool {
        if selectedReason == .other {
            return !customReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }
    
    // MARK: - Actions
    
    private func submitReport() {
        let finalCustomReason = selectedReason == .other ? customReason.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let finalDescription = description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        reportManager.submitReport(
            contentId: contentId,
            contentType: contentType,
            reportedUserId: reportedUserId,
            reportedUserName: reportedUserName,
            reason: selectedReason,
            customReason: finalCustomReason,
            description: finalDescription,
            reporterName: reporterName
        )
    }
}

/**
 * Row for selecting a report reason
 */
struct ReasonSelectionRow: View {
    let reason: ReportReason
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reason.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(reason.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}

#Preview {
    ReportContentView(
        contentId: "sample-post-id",
        contentType: .post,
        reportedUserId: "sample-user-id",
        reportedUserName: "Sample User",
        reporterName: "Current User"
    )
} 