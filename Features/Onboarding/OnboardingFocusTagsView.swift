import SwiftUI

struct OnboardingFocusTagsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    // Define a grid layout for the tags
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // Adjust count for more/less columns

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Focus Tags")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Select tags that resonate with your current life focus. These help tailor insights and content to your journey.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.focusTagOptions, id: \.self) { tag in
                        Button(action: {
                            toggleTagSelection(tag)
                        }) {
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(viewModel.selectedFocusTags.contains(tag) ? Color.accentColor : Color.secondary.opacity(0.2))
                                .foregroundColor(viewModel.selectedFocusTags.contains(tag) ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Text("Choose as many as you like. These tags help us filter and suggest relevant themes for your daily insights and journal prompts.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
    }

    private func toggleTagSelection(_ tag: String) {
        if let index = viewModel.selectedFocusTags.firstIndex(of: tag) {
            viewModel.selectedFocusTags.remove(at: index)
        } else {
            viewModel.selectedFocusTags.append(tag)
        }
    }
}

struct OnboardingFocusTagsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Pre-select some tags for preview
        viewModel.selectedFocusTags = ["Purpose", "Well-being"]
        return OnboardingFocusTagsView(viewModel: viewModel)
            .padding()
    }
} 