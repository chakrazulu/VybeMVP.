### **Development Workflow & Milestone Process**

**🚨 GOLDEN RULE: TEST FIRST, COMMIT NEVER UNTIL VALIDATED 🚨**
Never perform git operations (add, commit, push) until the user has personally tested changes on device and confirmed success. Always provide specific testing instructions and wait for user validation.

At each milestone or major checkpoint in development, follow this structured process to ensure quality and completeness:

1. **MANDATORY TESTING BEFORE ANY COMMIT/PUSH:** Before considering any code change complete, you MUST test the implementation thoroughly. This is non-negotiable and applies to every change, no matter how small.

   **CRITICAL RULE: NO GIT OPERATIONS UNTIL PERSONAL DEVICE TESTING COMPLETE**
   - Never run `git add`, `git commit`, or `git push` until user confirms successful testing
   - Always provide clear, specific testing instructions for each change
   - Wait for user validation before any repository operations
   - If user requests git operations before testing, remind them of this rule

   **Testing Protocol:**
   - **Build Test:** Ensure the project builds without errors (Cmd+R in Xcode)
   - **Device/Simulator Test:** Run on actual device or simulator to verify functionality
   - **Performance Test:** For UI changes, test scroll performance, animation smoothness, and responsiveness
   - **Regression Test:** Verify existing functionality still works after changes
   - **Console Log Review:** Check for error messages, warnings, or unexpected behavior
   - **User Flow Test:** Test the complete user journey through modified features

   **AI Assistant Responsibilities:**
   - Always provide specific testing instructions immediately after making code changes
   - Clearly explain what to look for, what should happen, and what success looks like
   - Never suggest git operations until user confirms testing success
   - Update task logs and documentation only after successful testing

   **Never commit or push code that:**
   - Doesn't build successfully
   - Hasn't been tested on device/simulator
   - Shows performance degradation
   - Breaks existing functionality
   - Produces console errors or warnings

2. **Verify Comments & Documentation:** Before considering a task "done," confirm that all affected code comments and any related documentation files have been updated to reflect your changes. This is a required confirmation at each checkpoint – do not mark a feature complete until you've done a pass through comments (and commit messages, if needed) to sync them with the code. If working with Cursor, explicitly instruct it to review comment consistency at milestone completion.

3. **Pause for User Testing:** Once the code changes (and comments) are in place for a milestone, pause development and allow the user (or tester) to run the updated app on a personal device. This means building to an actual iPhone/iPad if possible and using the feature in a real-world scenario. The purpose is to catch any issues that aren't obvious in the simulator and to ensure the "feel" aligns with expectations. For example, if the milestone was a new animation or insight display, check that it looks and performs as intended on a device (e.g., no jank, correct colors on device screen, etc.). Do not proceed to further development or commit the changes until this hands-on testing is done and the user confirms everything is satisfactory.

4. **Commit and Push after Verification:** Once the user testing at that milestone is successful (i.e., the user confirms the feature works and feels right), commit your changes to the repository and push to the remote Git server. Follow any project conventions for commit messages (e.g. include the issue/ticket number, or use verbs in present tense). The commit should be done only after you're confident in the code's stability and completeness up to that point. Pushing frequently (when stable) is encouraged to avoid large divergent changes, but never push code that hasn't been locally tested and reviewed for comment updates. 