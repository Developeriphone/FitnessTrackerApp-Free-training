import Foundation
extension Date {
	private static let workoutF: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMddHHmmss"
		return formatter
	}()
	func getWorkoutExportName() -> String {
		return Date.workoutF.string(from: self)
	}
}
