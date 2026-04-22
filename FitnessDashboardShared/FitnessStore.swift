import Combine
import Foundation

@MainActor
final class FitnessStore: ObservableObject {
    @Published private(set) var permissionState: PermissionState {
        didSet {
            permission.save(permissionState)
            refresh()
        }
    }
    @Published private(set) var workouts: [Workout] {
        didSet {
            save()
            refresh()
        }
    }
    @Published private(set) var summary: ActivitySummary
    @Published private(set) var trends: [TrendPoint]

    private let defaults: UserDefaults
    private let workoutsKey: String
    private let permission: FitnessPermissionManager
    private var refreshTask: Task<Void, Never>?

    init(
        defaults: UserDefaults = .standard,
        workoutsKey: String = "fitness.workouts",
        permissionKey: String = "fitness.permission"
    ) {
        self.defaults = defaults
        self.workoutsKey = workoutsKey
        permission = FitnessPermissionManager(defaults: defaults, key: permissionKey)
        permissionState = permission.load()
        workouts = defaults.data(forKey: workoutsKey).map { try! JSONDecoder().decode([Workout].self, from: $0) } ?? []
        summary = ActivitySummary(moveGoal: 500, move: 0, exerciseGoal: 30, exercise: 0, standGoal: 12, stand: 0)
        trends = []
        refresh()
    }

    deinit {
        refreshTask?.cancel()
    }

    func grantPermission() {
        permissionState = .granted
    }

    func denyPermission() {
        permissionState = .denied
    }

    func addWorkout(type: WorkoutType, durationMinutes: Int, date: Date = Date()) {
        guard permissionState == .granted else { return }

        workouts.insert(
            Workout(
                id: UUID(),
                type: type,
                durationMinutes: durationMinutes,
                calories: durationMinutes * type.caloriesPerMinute,
                date: date
            ),
            at: 0
        )
    }

    func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }

    func refresh() {
        let now = Date()
        let moveGoal = 500
        let exerciseGoal = 30
        let standGoal = 12

        guard permissionState == .granted else {
            summary = ActivitySummary(
                moveGoal: moveGoal,
                move: 0,
                exerciseGoal: exerciseGoal,
                exercise: 0,
                standGoal: standGoal,
                stand: 0
            )
            trends = trendPoints(for: now)
            return
        }

        let calendar = Calendar.current
        let todayWorkouts = workouts.filter { calendar.isDate($0.date, inSameDayAs: now) }
        let move = todayWorkouts.reduce(0) { $0 + $1.calories }
        let exercise = todayWorkouts.reduce(0) { $0 + $1.durationMinutes }
        let stand = Set(todayWorkouts.map { calendar.component(.hour, from: $0.date) }).count

        summary = ActivitySummary(
            moveGoal: moveGoal,
            move: move,
            exerciseGoal: exerciseGoal,
            exercise: exercise,
            standGoal: standGoal,
            stand: stand
        )
        trends = trendPoints(for: now)
    }

    func startBackgroundUpdates(intervalSeconds: UInt64 = 60) {
        stopBackgroundUpdates()
        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: intervalSeconds * 1_000_000_000)
                await self?.refresh()
            }
        }
    }

    func stopBackgroundUpdates() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    private func save() {
        defaults.set(try! JSONEncoder().encode(workouts), forKey: workoutsKey)
    }

    private func trendPoints(for now: Date) -> [TrendPoint] {
        let calendar = Calendar.current
        var totals: [Date: Int] = [:]

        for workout in workouts {
            let day = calendar.startOfDay(for: workout.date)
            totals[day, default: 0] += workout.calories
        }

        var points: [TrendPoint] = []
        for offset in stride(from: 6, through: 0, by: -1) {
            let day = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -offset, to: now)!)
            points.append(TrendPoint(date: day, move: Double(totals[day, default: 0])))
        }

        return points
    }
}
