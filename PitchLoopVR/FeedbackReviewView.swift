import SwiftUI

struct FeedbackReviewView: View {
    let title: String
    let onBack: () -> Void

    @State private var selectedFilter = ""

    private var filters: [String] {
        switch title {
        case "Eye Contact Feedback":
            return ["Too fixed", "Just right", "Avoiding audience"]
        case "Volume Feedback":
            return ["Too quiet", "Just right", "Too loud"]
        case "Structure Feedback":
            return ["Too short", "Just right", "Too long"]
        default: // Pacing
            return ["Too fast", "Too slow", "Felt just right"]
        }
    }

    private var noteText: String {
        switch title {
        case "Eye Contact Feedback":
            return "Your gaze tends to anchor left. Try scanning the full room every 20–30 seconds. The 0:47 and 2:15 flags both occur during Q&A."
        case "Volume Feedback":
            return "You dropped in volume near the end of each section. Project through your final sentence before pausing. Flagged at 1:08 and 3:55."
        case "Structure Feedback":
            return "Two sections lacked a clear closing before moving on. Add a one-line transition summary between topics. Flagged at 2:02 and 4:10."
        default:
            return "You consistently rush at slide transitions. Practice a 1-second pause before each new section. Flagged at 1:14 and 1:32."
        }
    }

    // (position 0–1 along track, isHighlighted)
    private var dotPositions: [(CGFloat, Bool)] {
        switch title {
        case "Eye Contact Feedback":
            return [(0.08, false), (0.29, true), (0.45, false), (0.71, true), (0.88, false)]
        case "Volume Feedback":
            return [(0.15, false), (0.34, false), (0.58, true), (0.76, false), (0.91, true)]
        case "Structure Feedback":
            return [(0.22, true), (0.43, false), (0.61, true), (0.79, false), (0.95, false)]
        default: // Pacing
            return [(0.10, true), (0.38, false), (0.52, false), (0.67, false), (0.82, false)]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Header
            ZStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
            }

            // Filter pills
            HStack(spacing: 4) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(selectedFilter == filter ? .white : .primary.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(selectedFilter == filter ? Color.blue : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.white.opacity(0.08)))
            .frame(maxWidth: .infinity, alignment: .center)

            // Avatar row
            HStack(spacing: 18) {
                ReviewAvatar(label: "Everyone's\nFeed...", initials: nil)
                ReviewAvatar(label: "Lorena\nPazmino", initials: "LP")
                ReviewAvatar(label: "Carnaven\nChiu", initials: "CC")
                ReviewAvatar(label: "Amy\nDeDonato", initials: "AD")
                ReviewAvatar(label: "Jon\nDascola", initials: "JD")
            }
            .frame(maxWidth: .infinity, alignment: .center)

            // Description
            Text("There are 7 notifications in total, 4 too fast, 1 too slow, and 2 felt just right. Click on the buttons to see where the notifications are on the time stamp, or click the avatar to see each of the audiences' notifications.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.primary.opacity(0.85))
                .lineSpacing(3)

            // Timeline
            VStack(alignment: .leading, spacing: 10) {
                Text("During the session")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.22))
                            .frame(height: 4)
                            .padding(.horizontal, 6)

                        ForEach(dotPositions.indices, id: \.self) { i in
                            let (pos, isHighlighted) = dotPositions[i]
                            Circle()
                                .fill(isHighlighted ? Color.red : Color.white)
                                .frame(width: 12, height: 12)
                                .offset(x: pos * (geo.size.width - 12))
                        }
                    }
                }
                .frame(height: 16)

                HStack {
                    Text("0:00")
                    Spacer()
                    Text("0:20")
                    Spacer()
                    Text("0:40")
                    Spacer()
                    Text("1:00")
                }
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))

            // Prompt box
            Text("Please ask for more feedback from the audiences (diff prompt)")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))

            // Note card
            HStack(alignment: .top, spacing: 8) {
                Text("Note:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                Text(noteText)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(2)
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.teal.opacity(0.55)))

            // Bottom buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Replay this moment")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.65))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.1)))
                }
                .buttonStyle(.plain)

                Button(action: {}) {
                    Text("Practice this ↗")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.blue))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        .onAppear {
            switch title {
            case "Eye Contact Feedback": selectedFilter = "Too fixed"
            case "Volume Feedback":      selectedFilter = "Just right"
            case "Structure Feedback":   selectedFilter = "Too long"
            default:                     selectedFilter = "Too fast"
            }
        }
    }
}

private struct ReviewAvatar: View {
    let label: String
    let initials: String?

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 52, height: 52)
                .overlay {
                    if let initials {
                        Text(initials)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                    } else {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                }
            Text(label)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

#Preview {
    FeedbackReviewView(title: "Pacing Feedback", onBack: {})
        .frame(width: 560, height: 680)
        .fixedSize()
}
