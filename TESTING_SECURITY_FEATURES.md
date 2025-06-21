# VybeMVP Security & Compliance Testing Plan

## 🛡️ **Authentication Testing**

### Firebase Auth Integration
- [ ] Launch app - should show loading screen then Sign In with Apple
- [ ] Tap "Sign In with Apple" - should open Apple ID authentication
- [ ] Complete Apple ID sign-in - should redirect to onboarding or main app
- [ ] Force quit and relaunch - should remember authentication state
- [ ] Sign out from profile - should return to sign-in screen

### Nonce Security
- [ ] Check console logs during sign-in for nonce generation
- [ ] Verify Firebase credential creation with proper nonce

## 🔒 **Firestore Security Rules Testing**

### Authenticated Access
- [ ] Try accessing posts without authentication (should fail)
- [ ] Sign in and access posts (should succeed)
- [ ] Create a post (should succeed with your Firebase UID as authorId)
- [ ] Try to create post with different authorId (should fail)

### Post Operations
- [ ] Create a post - check Firestore console for proper authorId
- [ ] Try to delete someone else's post (should fail)
- [ ] Delete your own post (should succeed)
- [ ] Add reaction to any post (should succeed)
- [ ] Try to delete someone else's reaction (should fail)

### User Data Privacy
- [ ] Try to access another user's journal data (should fail)
- [ ] Access your own journal data (should succeed)
- [ ] Try to access another user's profile (should fail)

## 📱 **User Reporting System Testing**

### Report Content View
- [ ] Navigate to a post and look for report option
- [ ] Open report form - should show all reason options
- [ ] Select different reasons - descriptions should update
- [ ] Select "Other" - custom reason field should appear
- [ ] Submit report without custom reason for "Other" (should fail validation)
- [ ] Submit valid report (should succeed with confirmation)

### Report Manager
- [ ] Submit multiple reports
- [ ] Check Firestore console for reports collection
- [ ] Verify reports have correct reporterId (your Firebase UID)
- [ ] Check that reports are read-only after creation

## 🔍 **Firebase Console Verification**

### Authentication
1. Go to Firebase Console → Authentication
2. Verify your Apple ID user appears after sign-in
3. Note the UID matches what's used in Firestore

### Firestore Data
1. Go to Firebase Console → Firestore Database
2. Check collections structure:
   - `posts/` - should have your posts with your Firebase UID as authorId
   - `reactions/` - should have your reactions with your Firebase UID as userId
   - `reports/` - should have your reports with your Firebase UID as reporterId
   - `users/` - should only show your user document

### Security Rules Testing
1. Go to Firebase Console → Firestore Database → Rules
2. Use the Rules Playground to test:
   - Unauthenticated read of posts (should fail)
   - Authenticated read of posts (should succeed)
   - Create post with wrong authorId (should fail)

## 🚨 **Error Handling Testing**

### Network Issues
- [ ] Turn off internet, try to create post (should show error)
- [ ] Turn internet back on, try again (should succeed)

### Authentication Errors
- [ ] Cancel Apple ID sign-in (should handle gracefully)
- [ ] Sign out and try to create post (should require re-authentication)

### Validation Errors
- [ ] Try to create empty post (should be disabled)
- [ ] Try to submit report without reason (should fail)

## 📊 **Performance Testing**

### Real-time Updates
- [ ] Open app on two devices/simulators
- [ ] Create post on one device
- [ ] Verify it appears on other device in real-time
- [ ] Add reaction on one device
- [ ] Verify reaction count updates on other device

### Loading States
- [ ] Check loading indicators during:
  - Authentication check
  - Posts loading
  - Post creation
  - Report submission

## 🎯 **User Experience Testing**

### Onboarding Flow
- [ ] New user sign-in should go to onboarding
- [ ] Returning user should go directly to main app
- [ ] Onboarding completion should be persistent

### Social Features
- [ ] Create different types of posts (text, sighting, chakra)
- [ ] Add reactions to posts
- [ ] Use different filters in timeline
- [ ] Test post composer with tags

## 🔧 **Development Testing Commands**

```bash
# Build and test
xcodebuild -project VybeMVP.xcodeproj -scheme VybeMVP -destination 'platform=iOS Simulator,name=iPhone 16' build test

# Check for security issues
grep -r "allow read, write: if true" firestore.rules
# Should return nothing (no open rules)

# Verify Firebase Auth integration
grep -r "Auth.auth().currentUser" Features/
# Should show proper usage in PostManager and ReportManager
```

## ✅ **Success Criteria**

- [ ] App builds and runs without crashes
- [ ] Authentication flow works end-to-end
- [ ] Posts can only be created by authenticated users
- [ ] Users can only access their own private data
- [ ] Reporting system works and stores reports securely
- [ ] Real-time updates work properly
- [ ] All security rules are enforced
- [ ] No console errors related to authentication or authorization

## 🚀 **Next Steps After Testing**

1. **If tests pass**: Ready for App Store submission
2. **If issues found**: Document and fix before proceeding
3. **Performance optimization**: Monitor Firebase usage and optimize queries
4. **Admin features**: Implement admin interface for report management

---

**Note**: Test on both simulator and physical device for complete validation. Physical device testing is especially important for Sign In with Apple functionality. 