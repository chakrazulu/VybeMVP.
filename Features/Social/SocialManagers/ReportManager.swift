//
//  ReportManager.swift
//  VybeMVP
//
//  Manager for handling user reports and content moderation
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

/**
 * ReportManager handles all Firebase operations for user reporting and content moderation
 * Required for App Store compliance with user-generated content
 */
class ReportManager: ObservableObject {
    static let shared = ReportManager()
    
    @Published var userReports: [Report] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let db = Firestore.firestore()
    private var reportsListener: ListenerRegistration?
    
    private init() {}
    
    deinit {
        reportsListener?.remove()
    }
    
    // MARK: - Authentication Helper
    
    /**
     * Gets the current Firebase UID for authenticated operations
     */
    private var currentFirebaseUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /**
     * Validates that the user is authenticated before performing operations
     */
    private func validateAuthentication() -> String? {
        guard let uid = currentFirebaseUID else {
            errorMessage = "You must be signed in to report content"
            return nil
        }
        return uid
    }
    
    // MARK: - Report Operations
    
    /**
     * Submits a report for inappropriate content
     */
    func submitReport(
        contentId: String,
        contentType: ReportContentType,
        reportedUserId: String,
        reportedUserName: String,
        reason: ReportReason,
        customReason: String? = nil,
        description: String? = nil,
        reporterName: String
    ) {
        // Validate authentication
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        // Clear previous messages
        errorMessage = nil
        successMessage = nil
        isLoading = true
        
        let report = Report(
            reporterId: firebaseUID,
            reporterName: reporterName,
            reportedContentId: contentId,
            reportedUserId: reportedUserId,
            reportedUserName: reportedUserName,
            contentType: contentType,
            reason: reason,
            customReason: customReason,
            description: description
        )
        
        do {
            _ = try db.collection("reports").addDocument(from: report) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = "Failed to submit report: \(error.localizedDescription)"
                        print("❌ Failed to submit report: \(error.localizedDescription)")
                    } else {
                        self?.successMessage = "Report submitted successfully. We'll review it shortly."
                        print("✅ Report submitted successfully")
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Failed to encode report: \(error.localizedDescription)"
            }
            print("❌ Failed to encode report: \(error.localizedDescription)")
        }
    }
    
    /**
     * Loads reports submitted by the current user
     */
    func loadUserReports() {
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        reportsListener = db.collection("reports")
            .whereField("reporterId", isEqualTo: firebaseUID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Failed to load reports: \(error.localizedDescription)"
                        print("❌ Failed to load user reports: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.userReports = []
                        return
                    }
                    
                    self.userReports = documents.compactMap { document -> Report? in
                        do {
                            var report = try document.data(as: Report.self)
                            report.id = document.documentID
                            return report
                        } catch {
                            print("❌ Error decoding report: \(error)")
                            return nil
                        }
                    }
                    
                    print("✅ Loaded \(self.userReports.count) user reports")
                }
            }
    }
    
    /**
     * Stops listening to user reports
     */
    func stopListening() {
        reportsListener?.remove()
        reportsListener = nil
    }
    
    /**
     * Clears success and error messages
     */
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    // MARK: - Admin Operations (Future Implementation)
    
    /**
     * Updates report status (admin only)
     * This would be used by admin users to manage reports
     */
    func updateReportStatus(
        reportId: String,
        newStatus: ReportStatus,
        resolution: String? = nil
    ) {
        // This would include admin authentication checks
        // For now, this is a placeholder for future admin functionality
        print("Admin function: Update report \(reportId) to \(newStatus.displayName)")
    }
    
    /**
     * Gets all pending reports (admin only)
     * This would be used by admin users to review reports
     */
    func loadPendingReports() {
        // This would include admin authentication checks
        // For now, this is a placeholder for future admin functionality
        print("Admin function: Load pending reports")
    }
} 