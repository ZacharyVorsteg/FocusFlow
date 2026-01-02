import Foundation

final class SessionStorage {
    private let sessionsKey = "focusflow_sessions"
    private let defaults = UserDefaults.standard

    func saveSessions(_ sessions: [FocusSession]) {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        defaults.set(data, forKey: sessionsKey)
    }

    func loadSessions() -> [FocusSession] {
        guard let data = defaults.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([FocusSession].self, from: data) else {
            return []
        }
        return sessions
    }

    func addSession(_ session: FocusSession) {
        var sessions = loadSessions()
        sessions.insert(session, at: 0)
        saveSessions(sessions)
    }

    func deleteSession(id: UUID) {
        var sessions = loadSessions()
        sessions.removeAll { $0.id == id }
        saveSessions(sessions)
    }

    func clearAllSessions() {
        saveSessions([])
    }
}
