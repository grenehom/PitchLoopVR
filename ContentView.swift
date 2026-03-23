import SwiftUI

// struct --> reusable component
struct ContentView: View {
    var body: some View {
        EvaluationFeedbackView()
    }
}

// MARK: - Evaluation & Feedback View
struct EvaluationFeedbackView: View {
    @Environment(\.dismiss) private var dismiss

    let categories: [FeedbackCategory] = [
        FeedbackCategory(
            title: "Eye Contact (Presence)",
            subtitle: "How well you engaged with your audience visually",
            icon: "eye"
        ),
        FeedbackCategory(
            title: "Timing (Length)",
            subtitle: "Whether your presentation fit the allotted time",
            icon: "clock"
        ),
        FeedbackCategory(
            title: "Pace (Speed)",
            subtitle: "Your speaking rhythm and delivery speed",
            icon: "waveform"
        ),
        FeedbackCategory(
            title: "Confidence (Delivery)",
            subtitle: "Presence, posture, and vocal authority",
            icon: "person.fill"
        ),
        FeedbackCategory(
            title: "Structure (Clarity & Logic)",
            subtitle: "How clearly your ideas were organized and conveyed",
            icon: "list.bullet.rectangle"
        )
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("Evaluation & Feedback")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Color.clear
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, 28)
                .padding(.top, 28)
                .padding(.bottom, 20)

                Divider()
                    .padding(.horizontal, 24)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                            FeedbackRowView(category: category)

                            if index < categories.count - 1 {
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
            }
            .padding()
        }
    }
}

// MARK: - Feedback Row View
struct FeedbackRowView: View {
    let category: FeedbackCategory

    var body: some View {
        NavigationLink(destination: FeedbackDetailView(category: category)) {
            HStack(spacing: 14) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(category.subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Feedback Detail View
struct FeedbackDetailView: View {
    let category: FeedbackCategory
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: category.icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.secondary)

            Text(category.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text(category.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            VStack(spacing: 8) {
                Text("Score")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text("—")
                    .font(.system(size: 52, weight: .thin))
                    .foregroundStyle(.primary)
            }
            .padding(.top, 8)

            Button("Back") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Data Model
struct FeedbackCategory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

#Preview {
    ContentView()
}
