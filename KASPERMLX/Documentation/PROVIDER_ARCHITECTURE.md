# 🏗️ KASPER Provider Architecture Documentation

**Version:** 2.1.5
**Created:** August 11, 2025
**Status:** ✅ Production Ready

## 🎯 Overview

The KASPER Provider Architecture implements a hot-swappable AI backend system that enables seamless switching between different spiritual intelligence providers without UI changes. This architecture supports template fallbacks, MLX stub models, and future real MLX/GPT integrations.

## 🏛️ Architecture Components

### Core Protocol Layer
```
KASPERMLX/MLXCore/
├── KASPERInferenceProvider.swift    # Main protocol + KASPERStrategy enum
└── StructuredInsight.swift          # Insight metadata structure
```

**Key Features:**
- `KASPERInferenceProvider` protocol defines common interface
- `KASPERStrategy` enum manages provider selection strategies
- `StructuredInsight` provides rich metadata with confidence scores

### Provider Implementations
```
KASPERMLX/MLXProviders/
├── KASPERTemplateProvider.swift     # Deterministic fallback (45% confidence)
├── KASPERStubProvider.swift         # Enhanced MLX stub (92% confidence)
├── CosmicDataProvider.swift         # Existing cosmic data provider
├── NumerologyDataProvider.swift     # Existing numerology provider
└── BiometricDataProvider.swift     # Existing biometric provider
```

**Provider Capabilities:**
- **Template Provider**: Always available, deterministic insights
- **Stub Provider**: RuntimeBundle integration with aggressive randomization
- **Data Providers**: Unchanged, provide spiritual context data

### Orchestration Layer
```
KASPERMLX/MLXIntegration/
├── KASPEROrchestrator.swift         # Strategy management + fallback chains
└── KASPERContentRouter.swift       # RuntimeBundle content routing
```

**Orchestrator Features:**
- Strategy selection (automatic, template, mlxStub, future providers)
- Automatic fallback chains (stub → template → always succeeds)
- Performance monitoring and metrics collection
- Debug mode and cloud provider permissions

### UI Integration
```
Views/Settings/
└── KASPERProviderSettingsView.swift # Provider selection interface
```

**UI Features:**
- Real-time provider status display
- Strategy switching interface
- Performance metrics visualization
- Debug toggles for development

### Engine Integration
```
KASPERMLX/MLXEngine/
└── KASPERMLXEngine.swift           # Updated with provider methods
```

**Engine Updates:**
- `setProviderStrategy()` - Switch providers programmatically
- `getCurrentStrategy()` - Get active strategy
- `getAvailableStrategies()` - List available options
- `getProviderPerformanceReport()` - Metrics access

## 🔄 Provider Flow

```
User Request → KASPERMLXEngine → KASPEROrchestrator → Provider → Insight
```

1. **Request Processing**: Engine receives insight request
2. **Strategy Selection**: Orchestrator selects provider based on strategy
3. **Provider Execution**: Selected provider generates insight
4. **Fallback Handling**: If provider fails, automatic fallback to template
5. **Metrics Recording**: Performance data collected for monitoring
6. **Result Delivery**: Insight returned with metadata

## 🎛️ Available Strategies

| Strategy | Provider | Confidence | Description |
|----------|----------|------------|-------------|
| `automatic` | Best Available | Variable | Auto-selects optimal provider |
| `mlxStub` | Stub Provider | 92% | RuntimeBundle + randomization |
| `template` | Template Provider | 45% | Deterministic fallback |
| `mlxLocal` | Future MLX | TBD | On-device ML inference |
| `gptHybrid` | Future GPT | TBD | Cloud-enhanced AI |

## 🚀 Provider Development

### Adding New Providers

1. **Implement Protocol**:
```swift
public actor MyMLXProvider: KASPERInferenceProvider {
    public let name = "My MLX"
    public let description = "Custom MLX implementation"
    public let averageConfidence = 0.95

    public var isAvailable: Bool { /* check model loaded */ }

    public func generateInsight(
        context: String, focus: Int, realm: Int, extras: [String: Any]
    ) async throws -> String {
        // Your MLX inference logic here
    }
}
```

2. **Register in Orchestrator**:
```swift
private func initializeProviders() async {
    providers[.mlxLocal] = MyMLXProvider()
    // Update getAvailableStrategies() to include new strategy
}
```

3. **Update Strategy Enum**:
```swift
public enum KASPERStrategy {
    case myMLX = "My MLX"
    // Add display name and description
}
```

### Testing New Providers

Use `KASPERInferenceProvidersTests.swift` as template:
```swift
func testMyMLXProvider() async throws {
    let provider = MyMLXProvider()
    let insight = try await provider.generateInsight(/*...*/)
    XCTAssertFalse(insight.isEmpty)
    XCTAssertEqual(await provider.name, "My MLX")
}
```

## 📊 Performance Monitoring

The orchestrator automatically tracks:
- Response times per provider
- Success rates
- Cache hit ratios
- Usage patterns

Access via:
```swift
let orchestrator = KASPEROrchestrator.shared
let report = orchestrator.getPerformanceReport()
print(report)
```

## 🔧 Configuration

### Strategy Selection
```swift
// Programmatic
await KASPERMLXEngine.shared.setProviderStrategy(.mlxStub)

// UI-based
// Navigate to Settings → KASPER AI Providers
```

### Debug Options
```swift
let orchestrator = KASPEROrchestrator.shared
await orchestrator.setDebugMode(true)
await orchestrator.setCloudProvidersAllowed(true)
```

## 🛡️ Error Handling

### Automatic Fallback Chain
1. **Primary Provider Fails** → Try fallback provider
2. **Fallback Fails** → Template provider (never fails)
3. **All Fail** → Return meaningful error message

### Error Types
- `providerUnavailable` - Selected provider not ready
- `modelNotLoaded` - ML model initialization failed
- `inferenceTimeout` - Generation took too long
- `networkError` - Cloud provider connection issues

## 📈 Future Roadmap

### Phase 1: Real MLX Integration
- Implement `KASPERMLXLocalProvider`
- Add model loading and inference logic
- Performance optimization for on-device inference

### Phase 2: Cloud Enhancement
- Implement `KASPERGPTProvider`
- Privacy controls and user consent
- Hybrid on-device + cloud processing

### Phase 3: Advanced Features
- Provider composition (multiple providers for single insight)
- A/B testing framework
- Machine learning provider selection optimization

## 🔍 Troubleshooting

### Common Issues

**Provider Not Found**:
- Ensure all new provider files are added to Xcode project
- Check provider registration in `initializeProviders()`

**Compilation Errors**:
- Verify `KASPERStrategy` enum includes all cases
- Check async/await usage follows Swift 6 concurrency rules

**Performance Issues**:
- Monitor provider metrics in settings
- Consider caching strategies for expensive operations
- Use appropriate provider for use case (template for speed, stub for quality)

### Debug Commands
```swift
// Check available strategies
let strategies = await engine.getAvailableStrategies()

// Get performance report
let report = orchestrator.getPerformanceReport()

// Test specific provider
await orchestrator.setStrategy(.template)
let insight = try await orchestrator.generateInsight(/*...*/)
```

---

**Built with:** Swift 6, SwiftUI, Actor Concurrency
**Compatible with:** iOS 17+, MLX Framework
**Maintained by:** KASPER MLX Team
