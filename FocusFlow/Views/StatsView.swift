import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                weeklyChart

                sessionsList
            }
            .padding()
        }
    }

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(viewModel.weeklyStats, id: \.date) { stat in
                    VStack(spacing: 4) {
                        Text("\(stat.totalMinutes)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor(for: stat))
                            .frame(width: 36, height: barHeight(for: stat))

                        Text(stat.formattedDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func barHeight(for stat: DailyStats) -> CGFloat {
        let maxMinutes = viewModel.weeklyStats.map(\.totalMinutes).max() ?? 1
        guard maxMinutes > 0 else { return 8 }
        let ratio = CGFloat(stat.totalMinutes) / CGFloat(maxMinutes)
        return max(8, ratio * 100)
    }

    private func barColor(for stat: DailyStats) -> Color {
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(stat.date)
        return isToday ? Color.accentColor : Color.accentColor.opacity(0.5)
    }

    private var sessionsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Sessions")
                .font(.headline)

            if viewModel.sessions.isEmpty {
                Text("No sessions yet. Start your first focus session!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.sessions.prefix(20)) { session in
                        SessionRow(session: session) {
                            viewModel.deleteSession(session)
                        }
                    }
                }
            }
        }
    }
}

struct SessionRow: View {
    let session: FocusSession
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.label)
                    .font(.subheadline.weight(.medium))

                Text(session.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(session.formattedDuration)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundStyle(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
