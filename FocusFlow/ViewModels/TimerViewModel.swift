import SwiftUI

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var selectedDuration: TimeInterval = 25 * 60
    @Published var sessionLabel = "Focus"
    @Published var sessions: [FocusSession] = []

    private var timer: Timer?
    private var startTime: Date?
    private let storage = SessionStorage()

    let durationOptions: [(String, TimeInterval)] = [
        ("15 min", 15 * 60),
        ("25 min", 25 * 60),
        ("45 min", 45 * 60),
        ("60 min", 60 * 60),
        ("90 min", 90 * 60)
    ]

    let labelOptions = ["Focus", "Deep Work", "Study", "Reading", "Writing", "Coding"]

    init() {
        loadSessions()
    }

    var remainingTime: TimeInterval {
        max(0, selectedDuration - elapsedTime)
    }

    var progress: Double {
        guard selectedDuration > 0 else { return 0 }
        return min(1.0, elapsedTime / selectedDuration)
    }

    var formattedRemainingTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var todayTotalMinutes: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessions
            .filter { calendar.startOfDay(for: $0.startTime) == today }
            .reduce(0) { $0 + Int($1.duration / 60) }
    }

    var todaySessionCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessions.filter { calendar.startOfDay(for: $0.startTime) == today }.count
    }

    var weeklyStats: [DailyStats] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7).reversed().compactMap { daysAgo -> DailyStats? in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else { return nil }
            let daySessions = sessions.filter { calendar.startOfDay(for: $0.startTime) == date }
            let totalMinutes = daySessions.reduce(0) { $0 + Int($1.duration / 60) }
            return DailyStats(date: date, totalMinutes: totalMinutes, sessionCount: daySessions.count)
        }
    }

    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        pauseTimer()
        elapsedTime = 0
    }

    func completeSession() {
        guard elapsedTime > 0 else { return }

        let session = FocusSession(
            startTime: startTime ?? Date(),
            duration: elapsedTime,
            label: sessionLabel
        )

        storage.addSession(session)
        loadSessions()
        resetTimer()
    }

    func deleteSession(_ session: FocusSession) {
        storage.deleteSession(id: session.id)
        loadSessions()
    }

    private func tick() {
        elapsedTime += 1

        if elapsedTime >= selectedDuration {
            completeSession()
        }
    }

    private func loadSessions() {
        sessions = storage.loadSessions()
    }
}
