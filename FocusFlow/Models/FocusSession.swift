import Foundation

struct FocusSession: Codable, Identifiable, Equatable {
    let id: UUID
    let startTime: Date
    let duration: TimeInterval
    let label: String

    init(id: UUID = UUID(), startTime: Date = Date(), duration: TimeInterval, label: String) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.label = label
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
}

struct DailyStats: Equatable {
    let date: Date
    let totalMinutes: Int
    let sessionCount: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
