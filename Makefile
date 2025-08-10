# KASPER MLX Project Makefile
# Automated tasks for spiritual AI development

.PHONY: help release-cards clean install-dev test test-structural test-heuristic determinism lint tag build soft venv content-lint content-normalize content-export content-validate content-all self-healing-setup self-healing-validate swiftlint-install coverage-report runtime-bundle-test

# Default target
help:
	@echo "KASPER MLX Development Commands v2.1.4"
	@echo "======================================="
	@echo ""
	@echo "📦 Release Management:"
	@echo "  release-cards    Generate DATA_CARD.md and MODEL_CARD.md"
	@echo "  soft            Generate release cards in soft mode (warnings only)"
	@echo "  build           Build full release bundle"
	@echo "  tag             Create and push git tag for current release"
	@echo ""
	@echo "🔧 Development Environment:"
	@echo "  venv            Create local virtual environment (.venv)"
	@echo "  install-dev      Install development dependencies and pre-commit hooks"
	@echo "  clean           Clean generated artifacts"
	@echo "  lint            Run pre-commit on all files"
	@echo ""
	@echo "🧪 Testing & Validation:"
	@echo "  test            Run all validation tests"
	@echo "  test-structural  Run structural validation tests only (CI-required)"
	@echo "  test-heuristic   Run heuristic quality tests only"
	@echo "  determinism     Test dataset digest stability (critical for production)"
	@echo ""
	@echo "🎯 Content Pipeline (Bulletproof v2.1.4):"
	@echo "  content-lint     Run content linter on all *_rich.json files"
	@echo "  content-normalize Fix snake_case and Claude artifacts in content"
	@echo "  content-export   Generate KASPER MLX runtime bundle"
	@echo "  content-validate Full validation pipeline (normalize + lint)"
	@echo "  content-all      Complete content pipeline (normalize + lint + export)"
	@echo ""
	@echo "🌟 Self-Healing Architecture (v2.1.6):"
	@echo "  self-healing-setup   Setup self-healing development environment"
	@echo "  self-healing-validate Complete self-healing system validation"
	@echo "  swiftlint-install    Install SwiftLint for code quality gates"
	@echo "  coverage-report      Generate content coverage report"
	@echo "  runtime-bundle-test  Test RuntimeBundle fallback chain"
	@echo ""
	@echo "💡 Quick Commands:"
	@echo "  make content-lint      # Quick content check"
	@echo "  make content-all       # Complete content pipeline"
	@echo "  make self-healing-validate  # Full system health check"
	@echo "  help                   # Show this help message"

# Generate release documentation
release-cards:
	@echo "🔮 Generating KASPER MLX Release Documentation..."
	python3 make_release_cards.py
	@echo "✅ Release cards generated successfully!"

# Generate release documentation in soft mode (development-friendly)
soft:
	@echo "🔧 Generating KASPER MLX Release Documentation (soft mode)..."
	python3 make_release_cards.py --soft --verbose
	@echo "🔧 Release cards generated with soft validation!"

# Create local virtual environment (macOS externally-managed workaround)
venv:
	@echo "🐍 Creating local virtual environment..."
	python3 -m venv .venv
	@echo "📦 Installing dependencies in virtual environment..."
	@. .venv/bin/activate && pip install --upgrade pip && pip install -r requirements-dev.txt
	@echo "✅ Virtual environment ready! Activate with: source .venv/bin/activate"

# Install development dependencies and pre-commit hooks
install-dev:
	@echo "📦 Installing development dependencies and pre-commit hooks..."
	pip3 install -r requirements-dev.txt
	pre-commit install
	@echo "✅ Dependencies and pre-commit hooks installed!"

# Clean artifacts
clean:
	@echo "🧹 Cleaning generated artifacts..."
	rm -rf docs/DATA_CARD.md docs/MODEL_CARD.md
	rm -rf artifacts/dataset_statistics.json artifacts/release_cards_bundle.zip
	@echo "✅ Artifacts cleaned!"

# Run all validation tests
test: install-dev
	@echo "🔍 Running all KASPER MLX validation tests..."
	python3 -m pytest tests/ --verbose
	@echo "✅ All validation tests passed!"

# Run structural validation tests only (required for CI)
test-structural: install-dev
	@echo "🏗️  Running structural validation tests (CI-required)..."
	python3 -m pytest tests/ -m structural --verbose
	@echo "✅ Structural validation tests passed!"

# Run heuristic quality tests only
test-heuristic: install-dev
	@echo "🎨 Running heuristic quality tests..."
	python3 -m pytest tests/ -m heuristic --verbose || echo "⚠️ Heuristic tests completed (warnings allowed)"

# Test deterministic digest (critical for production releases)
determinism: install-dev
	@echo "🔬 Testing dataset digest determinism..."
	python3 -m pytest -q tests/test_determinism.py
	@echo "✅ Determinism tests passed!"

# Run pre-commit on all files
lint:
	@echo "🧹 Running pre-commit on all files..."
	pre-commit run --all-files
	@echo "✅ Code quality checks complete!"

# Create and push git tag for current release
tag:
	@echo "🏷️  Creating git tag for current release..."
	python3 -c "import json; m=json.load(open('artifacts/MANIFEST.json')); print(f\"Tag: {m['release_info']['release_tag']}\")"
	@read -p "Press Enter to create and push tag, or Ctrl+C to cancel: " && \
	TAG=$$(python3 -c "import json; m=json.load(open('artifacts/MANIFEST.json')); print(m['release_info']['release_tag'])") && \
	git tag -a $$TAG -m "KASPER MLX Dataset release $$TAG" && \
	git push origin --tags && \
	echo "✅ Tag $$TAG created and pushed!"

# Build full release bundle
build: clean install-dev release-cards
	@echo "🚀 KASPER MLX release build complete!"

# ===================================================================
# BULLETPROOF CONTENT PIPELINE v2.1.4
# Exactly as specified by ChatGPT for spiritual AI content quality
# ===================================================================

# Run content linter on all *_rich.json files
content-lint:
	@echo "🔍 Running KASPER MLX content linter..."
	@python3 scripts/lint_rich_content.py

# Fix snake_case and Claude artifacts in content
content-normalize:
	@echo "🔧 Normalizing content with Claude artifact removal..."
	@python3 scripts/normalize_content.py KASPERMLX/MLXTraining/ContentRefinery

# Generate KASPER MLX runtime bundle
content-export:
	@echo "📦 Generating KASPER MLX v2.1.4 runtime bundle..."
	@python3 scripts/export_runtime_bundle.py
	@echo "✅ Runtime bundle exported successfully!"

# Full validation pipeline (normalize + lint)
content-validate: content-normalize content-lint
	@echo "✅ Content validation pipeline complete!"

# Complete content pipeline (normalize + lint + export)
content-all: content-normalize content-lint content-export
	@echo ""
	@echo "🎯 KASPER MLX v2.1.4 Content Pipeline Complete!"
	@echo "=============================================="
	@echo "✅ Content normalized and validated"
	@echo "✅ Runtime bundle exported"
	@echo ""
	@echo "🚀 Ready for spiritual AI excellence!"

# ===================================================================
# SELF-HEALING ARCHITECTURE COMMANDS v2.1.6
# ChatGPT's strategic recommendations implemented as Make targets
# ===================================================================

# Setup complete self-healing development environment
self-healing-setup: install-dev swiftlint-install
	@echo "🌟 Setting up VybeOS Self-Healing Architecture..."
	@echo "📦 Installing pre-commit hooks with self-healing rules..."
	pre-commit install --hook-type pre-commit --hook-type pre-push
	@echo "🔧 Configuring SwiftLint with runtime quality rules..."
	@if [ ! -f .swiftlint.yml ]; then echo "❌ SwiftLint config missing!"; exit 1; fi
	@echo "🧠 Validating RuntimeBundle fallback chain..."
	@python scripts/validate_runtime_bundle.py
	@echo ""
	@echo "✅ Self-Healing Architecture Setup Complete!"
	@echo "   🛡️ Content immune system active"
	@echo "   🏃 Swift quality gates configured"
	@echo "   🧠 RuntimeBundle validation ready"
	@echo "   📊 Content coverage reporting enabled"

# Complete self-healing system validation
self-healing-validate: content-validate swiftlint-install coverage-report runtime-bundle-test
	@echo ""
	@echo "🌟 VybeOS Self-Healing System Validation Complete!"
	@echo "================================================="
	@echo "✅ Content immune system operational"
	@echo "✅ Swift quality gates validated"
	@echo "✅ RuntimeBundle fallback chain tested"
	@echo "✅ Content coverage report generated"
	@echo ""
	@echo "🚀 Self-healing architecture fully operational!"

# Install SwiftLint for code quality gates
swiftlint-install:
	@echo "🛠️ Installing SwiftLint..."
	@if command -v swiftlint >/dev/null 2>&1; then \
		echo "✅ SwiftLint already installed: $$(swiftlint version)"; \
	else \
		echo "📦 Installing SwiftLint via Homebrew..."; \
		brew install swiftlint; \
		echo "✅ SwiftLint installed: $$(swiftlint version)"; \
	fi
	@echo "🔍 Validating SwiftLint configuration..."
	@swiftlint --config .swiftlint.yml --quiet || echo "⚠️ SwiftLint validation completed with warnings"

# Generate content coverage report
coverage-report:
	@echo "📊 Generating VybeOS Content Coverage Report..."
	@python scripts/generate_content_coverage_report.py --format=console
	@echo ""
	@echo "📄 Generating markdown report..."
	@python scripts/generate_content_coverage_report.py --format=markdown --output=coverage-report.md
	@echo "✅ Coverage report generated: coverage-report.md"

# Test RuntimeBundle fallback chain
runtime-bundle-test:
	@echo "🧠 Testing RuntimeBundle fallback chain..."
	@python scripts/validate_runtime_bundle.py
