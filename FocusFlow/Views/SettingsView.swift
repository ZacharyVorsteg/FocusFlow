import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showingClearConfirmation = false

    var body: some View {
        List {
            labelSection
            durationSection
            dataSection
            aboutSection
        }
        .confirmationDialog(
            "Clear All Sessions",
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All", role: .destructive) {
                SessionStorage().clearAllSessions()
                viewModel.sessions = []
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all your focus session history. This action cannot be undone.")
        }
    }

    private var labelSection: some View {
        Section("Session Label") {
            ForEach(viewModel.labelOptions, id: \.self) { label in
                Button {
                    viewModel.sessionLabel = label
                } label: {
                    LabelRow(label: label, isSelected: viewModel.sessionLabel == label)
                }
            }
        }
    }

    private var durationSection: some View {
        Section("Default Duration") {
            ForEach(viewModel.durationOptions, id: \.1) { option in
                Button {
                    viewModel.selectedDuration = option.1
                } label: {
                    DurationRow(title: option.0, isSelected: viewModel.selectedDuration == option.1)
                }
            }
        }
    }

    private var dataSection: some View {
        Section("Data") {
            Button(role: .destructive) {
                showingClearConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Clear All Sessions")
                }
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }

            Link(destination: URL(string: "https://focusflow-support.netlify.app/privacy.html")!) {
                LinkRow(title: "Privacy Policy")
            }

            Link(destination: URL(string: "https://focusflow-support.netlify.app/support.html")!) {
                LinkRow(title: "Support")
            }
        }
    }
}

private struct LabelRow: View {
    let label: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

private struct DurationRow: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

private struct LinkRow: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "arrow.up.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
