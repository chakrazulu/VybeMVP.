# Cursor rules md6/29/25)

## Vybe  (Project) cursor rules (6/29/25)


## **Vybe Development Assistant Guidelines**

_This document outlines the comprehensive rules, standards, workflows, and protocols for the Vybe app project. It merges the legacy guidelines with new additions to guide **Cursor** (the AI development assistant) and human developers. By adhering to these rules, we ensure that Vybe's codebase remains polished, scalable, **spiritually aligned**, and secure throughout its evolution._

### **Code Documentation & Comment Standards**

- **Update Comments with Every Change:** After **every** UI or logic change, review and update code comments immediately. This ensures comments always reflect the current behavior or design. For example, if you change a view's dimensions or a function's logic, adjust any comment describing it so that it remains accurate and up-to-date.

- **Maintain Existing Comment Structure:** Follow the same documentation/comment format found in well-documented parts of the codebase. If files use a particular style (such as /// for Swift documentation comments or // MARK: - Section delimiters), use that style consistently. Preserve any specific patterns, wording, or units of measure. **Baseline values in comments (like dimensions or design specs)** must be kept correct – e.g. if a comment says "**Base width: 375pt**" and you modify layout, update that number if needed. Do not remove or rewrite comments in a radically different style; instead, extend them in the established format.

- **Example – Proper Commenting Style:**

```
/// Calculates the user's daily Realm Number based on time, location, and biometrics.
/// - Note: Uses classic digit-sum numerology; preserves master numbers (11, 22, 33, etc.).
func computeRealmNumber() -> Int { ... }
```

- In the above example, a documentation comment (///) clearly explains the method and notes the numerological rule. Always aim for this clarity in function and class headers. In implementation code, use inline // comments to clarify non-obvious logic, especially if it relates to spiritual or numerological computations.

- **Consistent Formatting:** Write comments in complete, concise sentences. Capitalize the first word and use proper punctuation. When referencing UI elements or file names in comments, use the same naming and casing as in code. This consistency makes it easier for others (and AI assistants) to follow the intent. If other files include section headers, TODO/FIXME tags, or specific indentation in comments, mirror those practices in new or edited code.

- **No Stale or Misleading Comments:** Outdated comments can be worse than no comments. Part of updating comments means removing or correcting any information that no longer applies after a change. For instance, if a comment mentions "// TODO: optimize in SwiftUI 4" and the optimization was done, either update or remove that line. Treat the comment update as an integral step of coding, not an afterthought – **code isn't "done" until its comments are adjusted** and verified for accuracy.

### **UI & Layout Integrity Guidelines**

- **Do Not Break Existing UI Layout:** When modifying or extending the UI, ensure that you don't inadvertently break existing components or screen layouts. Maintain the app's current design language and structural integrity. **Never "hardcode" changes** that assume a different screen size or orientation unless intentional – all screens and components should remain responsive and behave as before (unless the task is specifically to refactor the layout). Before finalizing a UI change, test the relevant screen in multiple simulators or devices to confirm nothing essential is disrupted.

- **Preserve Baseline Dimensions:** Vybe's UI elements often have baseline dimensions or aspect ratios defined (and sometimes documented in comments). When you adjust UI elements, keep the original design proportions in mind. For example, if a button was designed to be 44pt high to meet Apple's tap target guidelines, avoid shrinking it below that. If you enlarge a view for new content, check siblings or containers to ensure they still align properly. Update any comment that recorded the old size to now reflect the new size, as mentioned above.

- **Maintain Visual Consistency:** Use the existing style definitions (colors, fonts, spacing) provided in the codebase or asset catalogs. **Do not introduce arbitrary new styles** without confirming they match the design ethos of Vybe. For instance, if all screens use a 16pt padding and a specific font for headers, stick to those unless directed to change. This also means following any theme or dark-mode conventions already established. Small UI tweaks can have cascading effects, so be vigilant that changing one component's layout or class doesn't misalign others.

- **Test Before Commit:** As part of UI integrity, always run the app on the simulator (and ideally a real device) after UI changes. Verify that dynamic content (like changing numbers, animations, or multi-line text) still renders correctly. Pay attention to edge cases: e.g., if a text field can expand, does it break the layout? If a view was scrollable, is it still reachable? Ensuring these details protects the high polish of Vybe's interface.

### **Development Workflow & Milestone Process**

At each milestone or major checkpoint in development, follow this structured process to ensure quality and completeness:

1. **Verify Comments & Documentation:** Before considering a task "done," confirm that all affected code comments and any related documentation files have been updated to reflect your changes. This is a **required confirmation** at each checkpoint – do not mark a feature complete until you've done a pass through comments (and commit messages, if needed) to sync them with the code. If working with Cursor, explicitly instruct it to review comment consistency at milestone completion.

2. **Pause for User Testing:** Once the code changes (and comments) are in place for a milestone, pause development and allow the user (or tester) to run the updated app on a personal device. This means building to an actual iPhone/iPad if possible and using the feature in a real-world scenario. The purpose is to catch any issues that aren't obvious in the simulator and to ensure the _"feel"_ aligns with expectations. For example, if the milestone was a new animation or insight display, check that it looks and performs as intended on a device (e.g., no jank, correct colors on device screen, etc.). **Do not proceed** to further development or commit the changes until this hands-on testing is done and the user confirms everything is satisfactory.

3. **Commit and Push after Verification:** Once the user testing at that milestone is successful (i.e., the user confirms the feature works and feels right), commit your changes to the repository and push to the remote Git server. Follow any project conventions for commit messages (e.g. include the issue/ticket number, or use verbs in present tense). The commit should be done only **after** you're confident in the code's stability and completeness up to that point. Pushing frequently (when stable) is encouraged to avoid large divergent changes, but never push code that hasn't been locally tested and reviewed for comment updates.

4. **Post-Push Summary & Technical Report:** After pushing the code, generate a summary of the session's work along with a brief technical report. This can be done by Cursor or manually. The summary should concisely state **what** was accomplished in that milestone, and **why** (the purpose or problem it solves). The technical report should outline **how** it was implemented – focusing on any important technical decisions, architectural changes, or noteworthy challenges/solutions encountered. For example, if the milestone implemented a new "Realm Number" calculation algorithm, the technical report might note the use of a new Combine publisher for real-time updates, and how the algorithm maintains performance. These documents serve both as internal documentation and as a progress log for the project. Save them in the repository (or an appropriate location) for future reference.

- _Tip:_ It may be useful to maintain a running **Changelog** or session journal within the project, where each push's summary is appended. This ensures that any team member or AI assistant coming into the project can quickly catch up on recent changes.

### **Reporting & Knowledge Transfer**

- **"Love Hertz" Summary Command:** The phrase **"love hertz"** is a special trigger in our workflow. When the user types or says _"love hertz"_ to Cursor, it signals the assistant to produce a comprehensive **Markdown summary file** (intended for sharing context in a _new_ Composer Chat or similar environment). This summary is more extensive than the regular session summary, and it should include:

    - **What the task was:** A clear description of the feature or problem tackled in the just-completed session or milestone.

    - **Why it was done:** The rationale or motivation behind the task. For example, "Users needed a way to visualize daily numerology trends, so we added a charting feature." Explain the user story or issue that led to this work.

    - **How it's built for scale, security, and efficiency:** An explanation of how the implementation is robust and future-proof. Note any design choices that improve scalability (e.g. using a modular architecture or background processing), security (e.g. using Keychain for sensitive data, input validation), and performance/efficiency (e.g. caching results, avoiding unnecessary recomputation). Essentially, reassure that the solution will hold up as the user base grows and does not compromise data safety or speed.

    - **Synopsis of Vybe app's purpose, niche, and current status:** A brief re-introduction of what the Vybe app is (its core concept and niche in the market) and where the codebase/project stands at this point in time. For instance, mention that "Vybe is a spiritual wellness and social app blending numerology and AI. The codebase is in SwiftUI using MVVM, with modules for AI insights, real-time data, etc., and as of this update we have implemented X, Y, Z features..." This provides context to any new reader or AI model about the broader project.

    The **"love hertz" report** is essentially a high-level briefing document. Cursor should output it in well-formatted Markdown, ready to be copied into a new chat or shared with team members. Remember to **not include sensitive info** like API keys or user data in this summary. It's meant to focus on design and architecture. Once generated, the user can use this to kickstart a discussion in a new context (like briefing another AI assistant or developer).

- **Session Summaries vs. Love Hertz:** Note the difference between the routine session summary/tech report (after each push) and the _"love hertz"_ comprehensive summary. The session summary is primarily for internal tracking and might be more granular or technical. The _love hertz_ summary is more narrative and holistic, useful for onboarding or high-level overviews. Both are important; ensure that Cursor or the developer produces each at the appropriate time. If the user doesn't explicitly invoke "love hertz" but a major phase of the project has been completed, it's good practice to suggest creating one of these comprehensive summaries for the record.

### **Spiritual & Numerological Integrity**

- **Preserve Esoteric Meanings:** Vybe is not just another app – it's built around sacred numerology and spiritual concepts. All development must respect and preserve the **numerological and spiritual integrity** of the app's content and features. In practice, this means that any code handling "insights", numbers, or spiritual symbolism should not be altered in a way that changes their intended meaning. For example, if the app calculates a user's **Focus Number** and **Realm Number** using established numerological formulas, do not modify those formulas arbitrarily. The system currently keeps special numbers (like master numbers 11, 22, 33, 44) without reducing them, per numerology practice . This rule must remain unless explicitly directed to change. Similarly, ensure that correspondences (e.g. linking numbers to chakras, planets, elements, etc.) stay correct . If a requirement arises to change such logic, double-check with the source material or product owner to confirm it still aligns with authentic traditions.

- **Accuracy in Insights:** The app provides **AI-driven insights** and interpretations based on user data and numerology. When working on features related to these insights (for instance, improving the "Explain-This-Insight" feature or tweaking how insights are displayed), maintain the _tone_ and _authenticity_ of the content. The insights should feel "mystical yet genuine," reflecting authentic spiritual wisdom. Avoid making changes that could cause the AI to produce trivial or insensitive outputs. If updating prompt templates or fine-tuning models, ensure you incorporate the same depth of spiritual knowledge present originally. It can help to refer back to the content library (e.g. JSON templates of insights or PDFs of source material) to ensure the AI's responses remain grounded in the intended voice.

- **No Unintended Symbol Changes:** Be cautious when altering visuals or icons that carry spiritual meaning. For instance, if there are images for chakras, tarot symbols, mandalas, etc., do not swap or modify them without considering the meaning. A color change might seem minor, but in a spiritual context it could alter the symbolism (e.g., changing the color associated with the heart chakra from green to a different color would be incorrect). Always check that any new asset or color scheme aligns with accepted spiritual correspondences.

- **Testing Spiritual Features:** Just as we test functionality, test any feature with a spiritual or numerological aspect for correctness. For example, if a new algorithm generates a daily number, verify with known numerology methods that it's correct. If we introduce a new "angel number" detection, ensure it catches the right patterns (e.g., 111, 222) and presents them in a meaningful way. In summary, **preserve the magic of Vybe** – the numbers and insights are the core value, and our changes should reinforce, not dilute, their significance.

### **Alignment with Latest Technology (Xcode, Swift & SwiftUI)**

- **Stay Up-to-Date:** Always align the project with the **latest stable versions** of Xcode, Swift, and SwiftUI (as well as iOS, if applicable). Vybe should leverage modern language features and best practices. For example, if SwiftUI gains a new API that simplifies a custom component we wrote, we should plan to adopt it. Regularly update project settings and Swift language versions when new Xcode releases come out, testing for any deprecation warnings. This ensures longevity and that we can take advantage of improvements in performance and security.

- **Consult Official Documentation:** When uncertain about a framework usage or encountering a bug that might be due to an API change, refer to Apple's **official documentation and guides** for the latest version, rather than relying on memory or outdated StackOverflow answers. Apple's docs will have the most accurate and up-to-date info. For instance, if a layout behavior changes in SwiftUI, check the Developer Documentation for that view in the current SDK. By doing so, we avoid hard-coding things based on older versions. **Avoid using static version numbers** in code or comments unless necessary; instead of saying "this uses iOS 16 behavior," prefer "uses latest SwiftUI behavior (see Apple Developer XYZ)" or simply ensure the code adapts dynamically (e.g., uses #available checks if needed).

- **Modern Swift & SwiftUI Practices:** Ensure code follows the modern conventions for Swift and SwiftUI. This includes using @State, @StateObject, @EnvironmentObject appropriately, leveraging Swift concurrency (async/await) instead of older callback patterns, and using SwiftUI's declarative patterns (avoiding imperative UIKit hacks whenever possible). If you find any legacy code that is now suboptimal due to language evolution, note it down for future refactor (or refactor it as part of your task if feasible). The idea is to keep the codebase "fresh" so that new contributors (or AI assistants) familiar with current best practices can easily understand and extend it.

- **Maintain Compatibility:** While staying cutting-edge, also ensure that we don't accidentally drop support for relevant environments. For example, if the app is targeting iOS 17 and above, that's fine, but if we still support iOS 16, avoid using an API that's only in 17 without a fallback. Adhere to the deployment target set in the Xcode project. If we bump the deployment target (say, to require a newer iOS for some feature), document that in the summary and possibly notify users if needed.

- **Tooling and CI:** Use the latest version of build tools (SwiftLint, etc., if used). If a new version of SwiftLint or a new rule comes out that would help maintain code quality, consider adopting it. The project might have a CI pipeline or at least a practice of running tests; ensure that any updates remain green on the latest Xcode. If the CI config uses a specific Xcode version image, update it in sync with our local updates.

### **AI Tools & Automation (Transpire and Future Modules)**

- **Leverage AI Assistance (Cursor & Beyond):** The Vybe project embraces AI assistants in development. **Cursor** is our on-going AI pair-programmer integrated into the workflow, but we also plan for more specialized AI tools. A notable one is **Transpire** – envisioned as a ReactBits-to-Swift translator and general automation layer for our app's development. This means in the future, portions of a web app or React code might be translated into SwiftUI components automatically, and repetitive tasks might be handled by AI. Our development guidelines anticipate this: **write modular, clean code that an AI can easily understand and manipulate.** Favor clear structure over clever hacks, as those will translate more reliably.

- **Transpire Integration:** Transpire (an AI-powered Xcode assistant) is expected to become part of Vybe's development ecosystem. It aims to **automate code generation and project integration** tasks. For example, Transpire might take a design or React component and output a SwiftUI view, or handle adding that new view to the Xcode project seamlessly. We should keep the codebase prepared for such automation by:

    - Defining clear interfaces and protocols (so AI-generated code can hook in with minimal coupling issues).

    - Keeping similar logic grouped (so that if an AI replaces a module, it's less likely to break unrelated parts).

    - Using consistent naming conventions, which will help AI tools accurately place or modify code.

- **Future-Proof Architecture:** The **modular AI automation layer** of Vybe implies that in the long run we might have various AI agents handling different domains (UI generation, testing, documentation, etc.). Our architecture should be **extensible** to accommodate this. In practice, this means continuing to follow MVVM and other patterns that separate concerns. For instance, if Transpire generates SwiftUI views from React bits, those views should conform to our architecture (e.g., use existing ViewModels or services rather than introducing duplicate logic). By documenting code and maintaining consistency, we make it feasible for AI tools to plug in without human rework.

- **Acknowledging AI Limits:** While we integrate tools like Cursor and plan for Transpire, always review AI-generated code thoroughly. The rules above about not breaking the UI, maintaining spiritual integrity, etc., apply equally to AI-suggested changes. Cursor's suggestions or Transpire's outputs must be checked against these guidelines. If an AI suggests something that violates a rule (like a change that could alter a numerology formula), _do not blindly accept it_. Instead, adjust the prompt or fix the code manually. The AI is here to assist, but **human (or careful AI) oversight is required to uphold Vybe's quality and ethos**.

- **Mention of Other Tools:** Transpire is one example of our forward-looking approach. We might also consider future **Xcode Source Editor Extensions**, CI bots, or other plugins to streamline development. The key is that any such tool should align with these rules. For instance, if a script auto-generates boilerplate, it should also generate the associated comments and adhere to our style. Plan and design with the mindset that parts of the development might be automated – which typically means making things deterministic and well-specified.

### **Integrating New Files into Xcode (Manual Workflow)**

When using Cursor or other AI tools to create new files (Swift files, asset catalogs, etc.), Xcode will not automatically know about these files. **You must manually integrate them into the Xcode project** to avoid build issues or duplication. Follow this step-by-step workflow whenever a new file is generated outside of Xcode's GUI:

1. **Locate the File in Finder:** After Cursor creates a file (for example, "NewComponent.swift"), reveal it in Finder (the file system). It might be in your project directory but not yet added to the Xcode project structure.

2. **Copy the File:** In Finder, select the new file and copy it (Cmd + C or via context menu "Copy"). This places the file on your clipboard.

3. **Paste into Xcode's Project Navigator:** In Xcode, determine the correct group/folder where this file belongs (e.g., a new view might go in the _Views_ group, a utility file in _Utilities_, etc.). Click on that destination in Xcode's Project Navigator. Now paste the file into Xcode: either right-click and choose "Paste" (if available) or simply press Cmd + V while that group is selected. Xcode will create a new entry for the file within the project.

    - **Important:** Ensure the "**Copy items if needed**" option is checked if Xcode prompts (this will copy the file into the project's folder if it isn't already there). In most cases, since the file was generated in the project folder, Xcode will just reference it, but it's good to confirm.

    - This _Paste from Clipboard_ method is crucial to avoid duplication. Drag-and-drop can also work, but copying/pasting has proven reliable in preventing Xcode from creating another duplicate file reference. The goal is one reference in Xcode to one physical file.

4. **Remove the Original (if needed):** If the file was created by Cursor in a temporary or outside location (for instance, some AIs create it on Desktop or a temp folder), delete that original so you don't have stray copies. If the file was created in the correct project folder already, you might skip deletion – just ensure you haven't accidentally left a file out of the project that won't be tracked.

5. **Rename to Remove Suffix:** Often when adding a file that already exists on disk, Xcode might detect a name collision or simply append a number to the filename (e.g., you paste NewComponent.swift and end up with NewComponent 2.swift in the project). If this happens, **rename the file in Xcode** to remove the " 2" (or " copy") suffix and restore the intended name. You can do this by selecting the file in Xcode and pressing Enter to edit the name. Make sure the final filename matches any references in code.

    - If Xcode added a suffix, it means there might have been another file with the same name already in the project or in the group's folder. Double-check if that's the case – we want to avoid duplicates. It may be that the Cursor-generated file was actually a modified version of an existing file. **Never allow two different files with the same class name** to exist; resolve any conflicts by merging changes or choosing a different name.

6. **Verify Build and References:** After adding the file, build the project to ensure Xcode sees it and there are no missing reference errors. Also open the file to confirm the content is as expected (sometimes copying from Finder ensures content, but just sanity-check). If the file is meant to be used somewhere (e.g., a new View), you might also add it to the appropriate place in code now (if the AI hasn't already) and test that everything links up.

This manual process is admittedly a bit tedious, but it's necessary due to how Xcode manages project files. We have scripts and future plans to automate this (**one core feature plan is an ".xcodeproj injector" script to add files seamlessly** ), but until that is in place, please follow the above steps diligently for each new file. Skipping these steps can result in missing files in the build or ghost files that cause confusion.

_(Reference: Currently, any new file created by AI must be manually added, or Xcode will not recognize it. The above workflow encapsulates those required Finder steps.)_

### **Checklist & Sprint Management System**

To keep development organized and transparent, we use a Markdown-based **checklist and task-tracking system** for each sprint/milestone. All tasks, their status, and metadata are recorded in a central file (e.g. Vybe_Sprint_Checklist.md). This system ensures both Cursor and the human team members stay on the same page regarding progress and pending work.

**Checklist Format:**

- Tasks are listed as Markdown checkboxes. Each task entry begins with a checkbox: \[ \] for incomplete tasks or \[x\] for completed tasks.

- Alongside each task, we include key metadata: **Task Name/Description**, **Owner**, **Date Assigned**, **Related Component or File**, **Sprint #**, and a **Verification Log**. The verification log is a place to note when and how the task was verified (e.g., date of testing, who verified, any commit ID or note).

**File Structure:**

We organize the checklist file by sprint or milestone. Each sprint can be a section (with a heading), under which tasks are listed. For example:

```
## Sprint 5 – New Insight Feature and UI Polish

- [ ] **Task:** Implement Chakra Alignment Animation  
  **Owner:** Jane Doe  
  **Date Assigned:** 2025-07-01  
  **Related:** `ChakraView.swift` (UI)  
  **Sprint:** 5  
  **Verification Log:** _(pending testing)_

- [x] **Task:** Refactor Numerology Engine for Master Numbers  
  **Owner:** John Smith  
  **Date Assigned:** 2025-06-25  
  **Related:** `NumerologyEngine.swift`  
  **Sprint:** 5  
  **Verification Log:** Tested on iPhone 12 (2025-06-28), all master numbers preserved. ✅
```

In the above example, tasks are grouped under "Sprint 5". Each task entry provides a description and all relevant info. We use **bold** labels for the metadata to make it scannable. The second task is marked \[x\] (completed) and even includes a brief note in Verification Log that it was tested on a device and what the outcome was.

**Using the Checklist:**

- At the **start of a sprint**, define all planned tasks in the checklist file, with \[ \] (incomplete). Assign owners (who is responsible; could be a person or "Cursor" if the AI is handling it) and date. Include which part of the app it touches (so testers know where to look) and the sprint number for clarity. If tasks are added mid-sprint (due to scope change or new bug findings), add them similarly.

- Throughout the sprint, update the status. When a task is done (code completed and merged), mark it \[x\] and fill in the verification log: when it was tested and by whom. If a task spans multiple sessions or needs partial verification, you can add sub-bullets or additional notes in the log.

- Both **Cursor and the user/developers should update this file**. For instance, if Cursor completes a coding task, it can mark the task done in the checklist (and maybe note "automated test passed" in the log). If the user tests a feature on device, they should write in the log that it was verified on a certain date. This collaborative editing ensures the checklist is the single source of truth.

**Metadata Guidelines:**

- _Task Name:_ Keep it short but descriptive ("Refactor Numerology Engine for Master Numbers" rather than just "Refactor engine").

- _Owner:_ The person or role responsible. Use real names or initials for humans, or "Cursor"/"AI" if the AI is doing it under supervision.

- _Date Assigned:_ When the task entered the pipeline – this helps track how long tasks take and provides accountability.

- _Related Component/File:_ Mention the primary file, feature, or UI screen involved. This helps quickly identify where changes occur. If multiple files, mention the most central or list a couple if needed.

- _Sprint:_ The sprint or milestone number/name. This is somewhat redundant if tasks are under a sprint heading, but including it in each task line is useful if we filter or move tasks around.

- _Verification Log:_ Start empty or with a placeholder. Once the task is done and tested, fill in notes. Include date of verification and any pertinent outcome (e.g., "All unit tests passed" or "User confirmed UX is smooth"). If a task fails verification and needs rework, note that too (e.g., "Found bug on 2025-07-02, reopened task").

**Regular Updates:** Treat the checklist as a living document:

- Check it at the daily stand-up (or start of a coding session). Cursor can be prompted to show open tasks at any time.

- When a task is completed in code, immediately mark it and write the verification note once tested.

- At the end of a sprint, review all tasks. Any incomplete tasks should be carried over to the next sprint's section (or explicitly moved). Completed tasks remain as historical record.

- Clean up any tasks that were added ad-hoc (sometimes AI or users might add a quick fix task; ensure it gets tracked here if not originally planned).

**Centralized Location:** Keep Vybe_Sprint_Checklist.md at the root of the project or a clearly labeled docs folder, so it's easily accessible. This file becomes the go-to overview for project progress. New contributors or assistants can read it to see what's done and what's upcoming. It also doubles as a progress log for retrospectives.

By following this checklist system, we improve transparency and ensure nothing falls through the cracks. It also enforces the earlier rules: e.g., a task isn't truly "done" until its verification is logged (which by nature means code, comments, tests, and user acceptance are all done). Cursor should respect this by not considering a job finished (even if code is merged) until the checklist reflects completion.

### **Comprehensive Documentation Protocol (NEW - CRITICAL FOR AI CONTINUITY)**

**🎯 Purpose:** Prevent AI session continuity issues by documenting every development decision, bug encounter, fix implementation, and deviation from planned tasks. This ensures any AI assistant can pick up exactly where we left off, preventing the backtracking issues experienced when switching between AI sessions.

**📝 Documentation Requirements:**

#### **For Every Task:**
- **What was planned:** Original task description and objectives
- **What was actually done:** Detailed implementation steps and code changes
- **Why it changed:** Reasons for deviations, modifications, or scope adjustments
- **How it was implemented:** Technical approach, architectural decisions, and code patterns used
- **What broke:** Any issues encountered during implementation (compilation errors, runtime crashes, performance problems)
- **How it was fixed:** Detailed solution, reasoning, and code changes made
- **Testing results:** Device validation, performance metrics, user feedback
- **Next steps:** What needs to be done next, any remaining issues

#### **For Every Bug/Issue:**
- **Issue description:** What went wrong, error messages, unexpected behavior
- **Root cause analysis:** Why it happened, underlying technical problems
- **Impact assessment:** What was affected, which components were involved
- **Solution implemented:** How it was fixed, code changes made, reasoning
- **Prevention measures:** How to avoid it in future, best practices established
- **Related files:** Which components were involved, dependencies affected
- **Testing verification:** How the fix was validated

#### **For Every AI Session:**
- **Session summary:** What was accomplished, major milestones reached
- **Key decisions made:** Important technical choices, architectural changes
- **Current state:** Exact status of all components, what's working/not working
- **Known issues:** Any remaining problems, limitations, or technical debt
- **Next priorities:** What should be tackled next, immediate action items
- **Context for next session:** What the next AI assistant needs to know

#### **For Every Deviation from Planned Tasks:**
- **Original plan:** What was supposed to happen
- **What actually happened:** How reality differed from the plan
- **Why the deviation occurred:** Technical challenges, user feedback, new requirements
- **Impact of deviation:** How it affected the overall project timeline and scope
- **Lessons learned:** What we learned from the deviation
- **Updated plan:** How the plan was adjusted based on the deviation

**📋 Implementation Guidelines:**

#### **Documentation Location:**
- **Primary:** `docs/VYBE_MASTER_TASKFLOW_LOG.md` - Living grimoire of all development decisions
- **Secondary:** Individual component documentation in code comments
- **Tertiary:** Git commit messages with detailed explanations

#### **Documentation Format:**
- Use clear, structured markdown with consistent formatting
- Include timestamps for all entries
- Use emojis and visual indicators for quick scanning
- Maintain chronological order within sections
- Cross-reference related issues and solutions

#### **Documentation Timing:**
- **Real-time updates:** Document decisions as they're made
- **End-of-session summary:** Comprehensive update after each development session
- **Before AI handoff:** Ensure all context is captured before switching AI assistants
- **After bug fixes:** Immediate documentation of what was fixed and how

#### **Quality Standards:**
- **Completeness:** Every decision, bug, and fix must be documented
- **Accuracy:** Information must be precise and up-to-date
- **Clarity:** Documentation must be understandable to any AI assistant
- **Context:** Include enough background for future understanding
- **Actionability:** Next steps must be clear and specific

**🚨 Critical Success Factors:**

#### **AI Continuity:**
- Any AI assistant should be able to read the documentation and understand exactly where the project stands
- No context should be lost when switching between AI sessions
- All technical decisions and their reasoning should be preserved
- Bug fixes and their solutions should be fully documented

#### **Prevention of Backtracking:**
- Document why certain approaches were chosen over others
- Record failed attempts and why they didn't work
- Maintain history of all changes and their impact
- Preserve knowledge of what breaks what

#### **Knowledge Transfer:**
- New team members or AI assistants can quickly understand the project
- Historical context is preserved for future reference
- Technical debt and known issues are clearly documented
- Best practices and lessons learned are captured

**💡 Example Documentation Entry:**

```
### **December 29, 2024 - Twinkling Numbers Visibility Issues**
- **Issue:** Numbers appearing randomly and sporadically, poor visibility on iPhone 14 Pro Max
- **Root Cause:** Inconsistent number generation logic, insufficient size/opacity
- **Impact:** Poor user experience, numbers hard to see
- **Solution:** Implemented consistent generation every 1.5 seconds, increased size to 28-40pt, opacity to 0.7-0.95
- **Files:** ScrollSafeCosmicView.swift
- **Status:** ✅ RESOLVED
- **Next:** Fine-tune spacing and density for optimal visual effect
```

This comprehensive documentation protocol ensures that Vybe's development maintains complete continuity across AI sessions, preventing the backtracking issues that can occur when switching between different AI assistants or development contexts.

## Cursor (USER)  Rules (6/29/25)


## **cursor_user_rules.md**

### **Introduction & Project Overview**

This document defines the unified **Cursor user rules** for two intertwined projects: **Vybe** and **Transpire**. It merges general coding standards with project-specific guidelines to ensure future-proof, scalable development. Vybe is a spiritual wellness iOS app blending numerology and immersive visuals, while Transpire is an AI-powered Xcode assistant (macOS) aiding development. Despite different focuses, both projects share a commitment to clean architecture, performance, and a unique fusion of **spiritual and technical clarity**. All team members and AI assistants should adhere to these rules to maintain consistency and quality across the codebase.

### **General Coding Standards**

1. **Use Latest Swift & Xcode:** Develop using the latest stable Swift version and Xcode toolchain. Embrace SwiftUI (for iOS/macOS UI) and Swift Concurrency (async/await) to leverage modern language features. Regularly update project settings to new SDKs, **while ensuring nothing breaks on current target OS versions**.

2. **MVVM Architecture & Modular Design:** Follow a strict MVVM pattern for all UI components. Keep **Views** (SwiftUI Views) purely declarative and free of business logic. Encapsulate state and logic in **ViewModel** classes (ObservableObject with @Published properties) , and use **Models** for data structures. This separation of concerns improves testability and scalability. Design modules to be loosely coupled – for example, use protocols and dependency injection for services (e.g. an AIService protocol with concrete implementations) . This makes components swappable (for testing or future upgrades) and keeps the codebase flexible.

3. **Code Quality & Comments:** Always maintain clear, up-to-date comments in tandem with the code. **If you change or add functionality, update any relevant comments immediately.** Inline comments (// ...) should explain non-obvious decisions, especially around complex logic or SwiftUI workarounds. Public functions or intricate methods should have descriptive documentation comments. Before any milestone or pull request, **pause and perform a "comment checkpoint"** – review the code and ensure all comments accurately reflect the current logic. Remove or correct outdated comments to avoid confusion. In short, code and comments must evolve together.

4. **Error Handling & Logging:** Handle errors proactively and never ignore failures silently. Use Swift's do/try/catch to catch errors and either recover or surface them to the UI (for instance, show an alert if a network call fails) . Maintain UI state for errors (e.g. an @Published showError bound to an alert) as seen in Transpire's ViewModel . Log important events and errors using unified logging (os.log) with appropriate categories (especially for networking or AI calls) to facilitate debugging. All user-facing error messages should be clear and friendly – e.g. "Please check your internet connection and try again" rather than low-level error dumps.

5. **Performance Optimization:** Write code with performance and **responsiveness** in mind. Never block the main thread during long operations – use background tasks (Task {} or async functions) for API calls or heavy computations . In SwiftUI, prefer efficient updates (leverage @StateObject for ViewModels to avoid unnecessary re-renders). Use Combine or async streams for real-time data updates (e.g. live sensors or animations) to smoothly handle data flow. Avoid creating retain cycles or large memory leaks (use \[weak self\] in closures when needed). When adding new features, consider their impact on performance – for example, large animations or data processing should be tested on real devices for frame rate and memory usage. If performance issues arise, optimize using profiling tools (Instruments) and, if necessary, adjust algorithms (e.g. use lazy grids, caching, or batch processing).

6. **Security & Secrets:** Never expose sensitive data in code. **API keys, secrets, or private data must not be hard-coded or committed to the repo.** Use secure storage (Keychain) or configuration files (.env or Config.plist) for secrets, and always add those files to .gitignore . For example, store OpenAI API keys in Keychain (via a helper) or in an ignored .env file, and load at runtime . Review third-party frameworks or APIs for compliance with privacy and security (especially important in Vybe's context with personal data). When using network calls, enable App Transport Security (ATS) or provide justified exceptions, and prefer HTTPS for all communications.

### **UI/UX Integrity Guidelines**

1. **Respect Design Dimensions & Layout:** Follow design specifications for all UI components to preserve Vybe's unique aesthetic and ensure consistency. Do not arbitrarily change sizes, spacing, or alignment provided by the designers. For instance, if a button is meant to be 44pts high with specific padding, maintain those values unless there's a good reason to adjust. Use SwiftUI layout modifiers (like padding(), frame(minHeight:..., maxHeight:...), etc.) to create responsive designs that work across different screen sizes . **Never "hard-code" UI elements in a way that breaks in different orientations or Dynamic Type sizes.** All changes should be tested in light/dark mode and on multiple device simulators (or devices) to ensure the UI remains intact (no clipped or overlapping elements).

2. **Dynamic Type & Accessibility:** All text elements **must support Dynamic Type** so that users who adjust font size in iOS settings see corresponding changes . Use .dynamicTypeSize(...) modifiers or relative Font styles (Title, Body, etc.) to allow scaling . Likewise, **provide accessibilityLabel** for interactive elements like buttons, toggles, and any non-text UI so that VoiceOver can describe them . Aim for AA/AAA contrast standards for text and important visuals (check colors against accessibility contrast guides). Test key flows with VoiceOver to ensure the app is navigable. By maintaining accessibility, we not only widen our user base but also adhere to Apple's quality standards.

3. **Consistent Theming & Localization:** Use a centralized approach for colors, fonts, and other theming to ensure a consistent look. Leverage Asset catalogs for colors and images, and avoid scattering magic values. **All user-facing strings must be in Localizable.strings** files – never hard-code UI text, so that future localization is easy. Maintain support for Right-to-Left layout mirroring (where applicable) simply by using SwiftUI's natural layout system and not inserting directional assumptions. Consistency also means adhering to the app's visual style: in Vybe this includes sacred geometry graphics, neon glows, etc., and in Transpire a clean macOS interface. Any UI change should be reviewed for whether it fits the existing style or if design approval is needed.

4. **No UI Regression:** When modifying or adding features, ensure you do not break existing UI components. This includes preserving state persistence, transitions, and animations. For example, if you're updating the chart on Vybe's home screen, make sure the daily histogram and animations still function smoothly. If adjusting a view, verify that popovers, alerts, or modal sheets (if any) still appear correctly. **Never remove or modify a UI element that other parts of the app or other features depend on without coordinating** – e.g., don't repurpose a button for a new function if it's still needed for its original purpose on another screen. A good practice is to run through a quick regression test of key screens after any UI-related commit.

### **Project-Specific Rules: Vybe (Spiritual Wellness App)**

1. **Sacred Numerology Logic:** **Preserve the integrity of Vybe's numerology system at all costs.** The core algorithms that calculate the "Focus" and "Realm" numbers (and any derivatives like combined mandalas) are built on established spiritual formulas and must remain consistent. Do not alter the reduction logic or master number handling without approval – e.g. always keep 11, 22, 33, 44 as master numbers (they should not be reduced in digit-sum calculations) . If you introduce new data sources for the Realm Number (such as additional biometric inputs), integrate them in a way that aligns with the existing spiritual framework (maintaining the range 1–9 and preserving special cases). The data structures (e.g. mappings of numbers to chakras, elements, planets, etc.) are considered "sacred data" – extend them only with credible, intended additions. Always double-check that any changes to numerology logic produce meaningful, expected results (e.g., run test calculations to ensure an added data point doesn't skew the Realm number unfavorably).

2. **Spiritual Content & Correspondences:** Many parts of Vybe's codebase encode spiritual or mystical correspondences (e.g. which chakra or tarot card maps to a given number). **These mappings and content should remain authentic to the source philosophy.** If updating or adding content (like introducing a new guided meditation for a number, or adjusting a chakra color), ensure it's consistent with the overall metaphysical system used by the app. Consult the project's documentation on spiritual logic or the content specialist if in doubt. Technically, this means keeping JSON or plist files that store these correspondences in sync with any code that uses them. For instance, if Number 7 is associated with a certain planet and color, an update to that association should reflect across UI (color themes) and logic (planet names) uniformly. Avoid any changes that could be seen as **diminishing the spiritual authenticity** of Vybe – our users value accuracy in these esoteric details.

3. **Animated Visuals & UI Fidelity:** Vybe's UI is rich with **sacred geometry animations and cosmic visuals** (e.g. rotating mandalas, "number rain" backgrounds, etc. ). When working on the UI or animation code, ensure that these elements remain smooth and visually aligned with design specs. Use high-level SwiftUI animation APIs or Canvas drawing for custom graphics, and prefer **60fps fluidity** for animations (falling back to 30fps only if performance on older devices requires it). If you need to refactor or optimize animation code, do so carefully: test the "feel" of the animation after changes to confirm it hasn't lost its intended effect (e.g. the pulsing should still feel organic, timing of effects should remain in sync with triggers like number alignment events). Additionally, maintain the modularity of these visual components – e.g., a MandalaView or CosmicBackgroundView should remain self-contained so it can be reused or turned off for performance testing. **Never compromise on the unique visual identity** of Vybe during development tweaks; any necessary downgrades (for performance) should be discussed and approved by design leads.

4. **Data & State Management:** Vybe uses real-time data (like health or location inputs for Realm Number) and possibly cloud sync for user profiles. All new features should integrate with the existing data management strategy. Use **Combine** publishers or async updates to feed new data into ViewModels so that UI updates reactively (e.g. if adding a new HealthKit metric, wire it to update the Realm calculation stream) . Ensure **Core Data** or any local storage continues to function (migrate models if needed when adding new fields) without breaking existing user data. Also, protect user privacy: if handling new sensitive data (like heart rate or friends' locations for social features), follow the security guidelines (don't log sensitive info, use secure storage, and request only necessary permissions). Essentially, any expansion to Vybe's feature set must respect the spiritual context _and_ the user's trust in how their data and spiritual journey are managed.

### **Project-Specific Rules: Transpire (Xcode Assistant)**

1. **Role of Transpire – AI Code Assistant:** **Transpire's primary role is to assist developers** (particularly on Vybe or similar projects) in writing and modifying code through AI. It is a standalone macOS app built with SwiftUI, but its planned trajectory is to become an integrated automation tool in our workflow (and possibly integrated into Xcode or other IDEs) . All development on Transpire should keep it **modular and non-intrusive**: it should improve productivity (e.g. generating code suggestions, refactoring) without ever compromising the main project's code quality. In practice, this means we design Transpire features as optional tools that can be invoked by the developer; for example, a future Xcode Source Editor Extension ("Refactor with Transpire") might send code to Transpire's engine and insert the result . The integration should be seamless – if Transpire is not running or not authorized, the developer's workflow should remain unchanged.

2. **Modularity & Integration Points:** Treat Transpire as a **modular automation component** that can be plugged into Vybe's development process (or any project) without tight coupling. Its codebase should remain separate from Vybe's codebase (no intermixing of frameworks unnecessarily), communicating only through well-defined interfaces (e.g. an API or script). Any code generation or file creation by Transpire must adhere to the same coding standards defined in this document. As we plan future integration:

    - **Xcode Integration:** We aim to implement an Xcode extension or CLI tool to automate file injection into the Xcode project . This will require working with Xcode's project structure (possibly via AppleScript or xcodeproj scripts). Keep Transpire's output format and project awareness flexible to support this.

    - **Cross-IDE Support:** Transpire may extend to other editors (Cursor, VSCode) via plugins . Design it in a way that the core logic (AI prompt/response handling, file generation) can be reused in these contexts. For instance, abstract any editor-specific code into adapters.

    - **Don't Reinvent Features:** If Xcode or other tools provide a safe way to do something (like code formatting, linting), consider invoking those rather than duplicating functionality. Transpire should complement, not conflict with, existing developer tools.

3. **AI Service & Configurations:** Transpire's AI interactions must be reliable and secure. Use the AIService protocol and default OpenAIService implementation as the model for any new AI provider integration . Always fetch API keys from secure storage (Keychain) – never store them in plain text or commit them. Support configuration for model parameters (model name, temperature, etc.) via a config file or user settings, rather than hard-coding values . This ensures we can fine-tune the AI's behavior without code changes. Additionally, implement sensible **rate limiting and error handling** around AI calls: for example, if the API fails (network down or key invalid), catch the error and inform the user through the UI (as Transpire does with an alert on error) . The goal is to make Transpire's AI features robust – they should fail gracefully and never crash the app or leave the user confused (e.g., show an "Error: " in the response field when something goes wrong).

4. **User Interface & Experience (Transpire):** Transpire's UI should remain minimalistic and developer-friendly. It consists of input fields for context code and question, and an output area for AI response . When enhancing the UI, ensure it stays **non-intrusive and efficient** – developers want quick results and clear text. Keep buttons and text fields responsive; for instance, disable the "Ask AI" button while a query is running and show a spinner (as implemented with isLoading state) . Use .dynamicTypeSize in Transpire as well (developers may use accessibility too) , and provide accessibility labels for any icons or custom UI. If adding features like a history list or code preview, make sure they don't clutter the window unnecessarily – perhaps hide them behind toggles or a secondary panel. **Test Transpire on the latest macOS version** and a variety of window sizes to ensure the layout adapts (e.g., use SwiftUI's flexible frames and allow the window to be resizable without breaking the layout).

5. **Future-Proofing & Tiered Features:** We anticipate multiple tiers for Transpire (Free, Pro, Team, Enterprise) with varying features . Design the code in a way that enabling/disabling features per tier is straightforward (for example, use flags or runtime checks for "Pro-only" features like live preview or team collaboration). Ensure that any feature that isn't available in a given tier is either hidden or clearly disabled with an explanation, rather than throwing an error. Also, keep an eye on developments in local ML: if integrating on-device models (for offline mode or user privacy), structure the AI service so it can switch between cloud and local seamlessly (perhaps automatically falling back to local if internet is off, as a future feature) . The architecture should allow adding these enhancements without a complete rewrite. In summary, build Transpire to last – flexible configuration, clear separation of concerns, and readiness for growth will ensure it remains a powerful companion tool for Vybe and beyond.

### **Development Workflow & Process Protocols**

1. **Milestone Checkpoints & Comment Review:** Development should be organized into milestones or sprints. At the end of each milestone (or before merging a significant feature branch), perform a **checkpoint review**. This includes verifying that all code comments are updated (per the earlier rule) and that function/variable names still make sense after changes. Use this pause to also run linters (e.g. SwiftLint) and formatters so the codebase stays clean and consistent. No code goes to main (or a release branch) without this sanity check. This process ensures that technical debt doesn't accumulate and the code remains self-documenting and maintainable at each step.

2. **Testing on Real Devices:** Before pushing any feature or fix, **test the app on a real device** (or at minimum, a simulator closely matching a real device). For Vybe, this means running on an iPhone (and iPad if supported) to verify that gestures, performance, and rendering match expectations – especially for graphic-intensive features like animations. For Transpire (a macOS app), run it on a Mac (or different Mac models if possible) to ensure it behaves well (permissions, network calls, UI scaling, etc.). Device testing is mandatory for catching issues that don't appear in the simulator (e.g. authentication that relies on a device credential, performance hiccups on older hardware, or layout issues that only show up on certain screen sizes). **Only when you've personally tested and are satisfied that the feature works end-to-end should you consider committing your code.** This hands-on validation is crucial to maintain app quality.

3. **Git Commit & Push Discipline:** Our workflow requires that all changes be committed to version control with clear, descriptive messages. When a feature/fix is complete _and_ tested (per the above), squash your interim commits if needed and write a meaningful commit message (or pull request description) that outlines what was done. For example, "Add realm number 14-day history chart and ensure scroll is performance-optimized" is far better than "fixed stuff". After pushing to the remote repository, verify the CI (if any) passes all checks. It's good practice to also pull the latest main and run the app again quickly to ensure your changes integrate nicely with others' recent commits. **Never push broken or untested code** to main – if something is a work in progress, use a feature branch and mark it as draft in the PR until it's ready.

4. **"Love Hertz" Session Summaries:** After verifying and pushing your code, trigger a **"Love Hertz" command** in the Cursor AI environment. "Love Hertz" is our special command to generate a comprehensive markdown summary of the development session (changes made, key decisions, and remaining to-dos). The purpose of this summary is multi-fold:

    - _Knowledge Transfer:_ It creates a document that can **brief new AI assistants or team members** on the current project context and recent changes, without them having to read every code diff or commit message.

    - _Continuity:_ By saving these summaries, we maintain continuity across AI-assisted sessions. Before a new coding session, the developer or AI can review the last "Love Hertz" summary to quickly get up to speed, ensuring that no context is lost between sessions.

    - _Documentation:_ It serves as internal documentation, capturing not just _what_ changes were made but _why_ (including any rationale discussed with the AI). Over time, these can be compiled into a project journal or changelog, aiding in retrospectives and onboarding.

        When you invoke "Love Hertz", make sure to do it **after** finalizing the code changes for the session. Save the generated markdown (e.g., commit it to a docs/ folder or another knowledge base). This practice will greatly enhance our AI-assisted development process, as subsequent AI queries can be given this summary for context, leading to more informed and efficient responses.

5. **Manual File Integration:** When using AI tools (like Cursor or Transpire) that generate new files or code snippets, always integrate them into the Xcode project manually to ensure nothing is missed. **Never rely on an external file appearing in Xcode automatically.** Follow these steps for any AI-generated file or asset:

    - **Create via Xcode:** In Xcode, **create a new file** of the appropriate type (e.g. Swift file, Asset catalog item) in the correct group/folder (Right-click on the group > New File). Name it according to our naming conventions (e.g. FeatureNameView.swift, ModelName.swift, etc.). This avoids duplicate import issues and ensures Xcode is aware of the file .

    - **Copy-Paste Content:** Copy the code or content from the AI output (Clipboard) and paste it into the new file within Xcode. If the AI provided a filename or class name, verify it matches our project structure and does not collide with existing names. Adjust the class/struct name if necessary to match the file name and project naming style.

    - **Asset Integration:** For any new image or asset files suggested by AI (or added via scripts), drag them into Xcode's Assets catalog (or appropriate resource folder). For example, if a script generates new chakra images, use Finder to locate them, then drag-drop into **Assets.xcassets** in Xcode, checking "Copy items if needed" . Remove any old references if the assets were renamed. Update code references to assets by their new names as needed (e.g. if the image name changed, update Image("...") calls).

    - **Remove External Artifacts:** If the AI or tool created a file on disk outside of Xcode (for instance, in a workspace folder), delete or ignore that external file to prevent confusion. The source of truth should be the file that's added inside Xcode. We want to avoid situations where a file is present in the filesystem but not linked in the project – such files can cause build issues or be forgotten.

    - **Build & Run:** After adding the new file, always build the project to ensure it compiles and is linked properly. Run the app to verify that the integration did not break anything (especially if multiple files or assets were added at once).

        Following these steps guarantees that our Xcode project remains organized and that nothing is left out. In the future, we plan to automate some of this (for example, an "auto-sync" script or Transpire feature to add files to the project) , but until that is implemented and reliable, manual integration is the rule. It might take a minute or two, but it saves hours of debugging missing files or resources.

### **Unit Testing & Continuous Improvement**

No feature or fix is truly **"done"** until it's covered by tests. After completing major milestones or implementing critical pieces of logic, developers **must write or update unit tests** to validate the new code. Aim for a robust test suite that covers core functionality, edge cases, and any reported bugs (to prevent regressions). For Vybe, this means testing the numerology calculations (e.g. ensure master numbers remain unaltered, check Realm number algorithm with sample data), testing ViewModels (business logic in isolation), and any utility methods (date calculations, etc.). For Transpire, write tests for things like the prompt-building logic (does it correctly format code context and questions?), the AIService implementations (perhaps using a mock URLSession or a dummy AIService to simulate API responses), and ViewModel behaviors (e.g. isLoading flag toggles correctly during an AI call). Leverage dependency injection to swap in mocks for testing – for example, provide a fake AIService that returns a known value so the ViewModel test can assert that aiResponse updates accordingly.

Integrating tests at each milestone ensures that as the codebase grows, we can refactor with confidence. All new code should ideally have accompanying tests when feasible, or at least a plan to add tests in the near term. Run the test suite regularly (and certainly before any release) to catch regressions early. If a bug is found in production or during QA, write a test that reproduces it, then fix the bug – this prevents the same issue from sneaking back later.

Finally, encourage a culture of continuous improvement: these rules and tests are living parts of the project. Team members should feel free to propose enhancements to the development process, add clarifying comments, and improve test coverage. By adhering to the above guidelines, we ensure that **scale, modularity, and spiritual-technical clarity** remain at the heart of Vybe and Transpire. The result will be software that not only works and scales well, but also stays true to its vision and is a joy to maintain. Happy coding! 🚀🔮