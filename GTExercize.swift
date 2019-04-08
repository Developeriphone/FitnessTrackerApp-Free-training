import Foundation
import CoreData
@objc(GTExercize)
public class GTExercize: GTPart {
	public var title: String {
		fatalError("Abstract property not implemented")
	}
	public var summary: String {
		fatalError("Abstract property not implemented")
	}
	public func summaryWithSecondaryInfoChange(from ctrl: ExecuteWorkoutController) -> NSAttributedString {
		return NSAttributedString(string: summary)
	}
}
