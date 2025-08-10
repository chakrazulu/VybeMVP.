# 🔮 VybeMVP Pull Request

## What
<!-- Brief description of changes -->
- 

## Why
<!-- Reason for this change -->
- 

## Type of Change
<!-- Check all that apply -->
- [ ] 🐛 Bug fix
- [ ] ✨ New feature  
- [ ] 🔧 Improvement/enhancement
- [ ] 📚 Documentation
- [ ] 🧪 Tests
- [ ] 🏗️ Infrastructure/CI
- [ ] 🔮 KASPER MLX dataset/AI
- [ ] 📱 iOS/Swift code
- [ ] 🧹 Refactoring

## KASPER MLX Dataset Changes (if applicable)
<!-- For dataset/AI changes, provide metrics -->
- **Dataset/Version:** <!-- e.g., kasper-lp-trinity_v2025.08.09_build1 -->
- **Files/Insights:** <!-- e.g., 130 files, 4,606 insights -->
- **Digest (12):** <!-- First 12 chars of dataset digest -->

## Quality Checklist
<!-- Verify all items before requesting review -->

### Code Quality
- [ ] Pre-commit hooks pass (`pre-commit run --all-files`)
- [ ] Tests pass (`make test`)
- [ ] No secrets/PII in dataset (`gitleaks` clean)

### KASPER MLX Specific (if applicable)
- [ ] Schema validation passes (12×12 insights, intensity 0.60-0.90)
- [ ] MANIFEST digest stable across runs (`make determinism`)
- [ ] Documentation cards generated (`make release-cards`)

### iOS/Swift (if applicable)
- [ ] Xcode builds without warnings
- [ ] No changes to signing/provisioning unless required
- [ ] Files added to Xcode targets only if needed for app runtime

### Documentation
- [ ] README updated if user-facing changes
- [ ] CLAUDE.md updated if workflow changes
- [ ] Comments added for complex logic

## Testing
<!-- How was this tested? -->
- [ ] Unit tests
- [ ] Integration tests  
- [ ] Manual testing on iPhone 16 Pro Max simulator
- [ ] Real device testing (if UI changes)

## Screenshots/Evidence
<!-- For UI changes, include before/after screenshots -->
<!-- For dataset changes, include validation output -->

## Breaking Changes
<!-- List any breaking changes and migration steps -->
- None / N/A

## Deployment Notes
<!-- Any special deployment considerations -->
- None / N/A

---

### For Reviewers
<!-- Auto-populated sections for context -->

**Build Status:** <!-- CI will update this -->
- Schema: ✅/❌ 
- Tests: ✅/❌  
- Determinism: ✅/❌ 
- Secrets: ✅/❌
- Pre-commit: ✅/❌

**Release Impact:** <!-- Will this trigger a new release? -->
- [ ] No release impact
- [ ] Dataset release required
- [ ] App Store release required

---

*🌟 Generated for VybeMVP - Bridging Ancient Wisdom with Revolutionary AI*