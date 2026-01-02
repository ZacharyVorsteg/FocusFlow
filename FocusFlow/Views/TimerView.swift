import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            timerCircle

            controlButtons

            Spacer()

            todayStats
        }
        .padding()
    }

    private var timerCircle: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: viewModel.progress)

            VStack(spacing: 8) {
                Text(viewModel.formattedRemainingTime)
                    .font(.system(size: 56, weight: .light, design: .monospaced))
                    .foregroundStyle(.primary)

                Text(viewModel.sessionLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 280, height: 280)
    }

    private var controlButtons: some View {
        HStack(spacing: 24) {
            if viewModel.isRunning {
                Button {
                    viewModel.pauseTimer()
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.title)
                        .frame(width: 64, height: 64)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }

                Button {
                    viewModel.completeSession()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .frame(width: 64, height: 64)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            } else {
                Button {
                    viewModel.resetTimer()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .frame(width: 56, height: 56)
                        .background(Color.gray.opacity(0.2))
                        .foregroundStyle(.primary)
                        .clipShape(Circle())
                }

                Button {
                    viewModel.startTimer()
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .frame(width: 72, height: 72)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }

                Menu {
                    ForEach(viewModel.durationOptions, id: \.1) { option in
                        Button(option.0) {
                            viewModel.selectedDuration = option.1
                            viewModel.resetTimer()
                        }
                    }
                } label: {
                    Image(systemName: "clock")
                        .font(.title2)
                        .frame(width: 56, height: 56)
                        .background(Color.gray.opacity(0.2))
                        .foregroundStyle(.primary)
                        .clipShape(Circle())
                }
            }
        }
    }

    private var todayStats: some View {
        HStack(spacing: 32) {
            VStack(spacing: 4) {
                Text("\(viewModel.todayTotalMinutes)")
                    .font(.title2.bold())
                Text("minutes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .frame(height: 40)

            VStack(spacing: 4) {
                Text("\(viewModel.todaySessionCount)")
                    .font(.title2.bold())
                Text("sessions")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
