import Foundation
import MBLibrary
extension GTCircuit {
	static let circuitTag = "circuit"
	static let exercizesTag = "exercizes"
	override func export() -> String {
		var res = "<\(GTCircuit.circuitTag)>"
		res += "<\(GTCircuit.exercizesTag)>\(self.exercizeList.map { $0.export() }.reduce("") { $0 + $1 })</\(GTCircuit.exercizesTag)>"
		res += "</\(GTCircuit.circuitTag)>"
		return res
	}
	override class func `import`(fromXML xml: XMLNode, withDataManager dataManager: DataManager) throws -> GTCircuit {
		guard xml.name == GTCircuit.circuitTag,
			let ex = xml.children.first(where: { $0.name == GTCircuit.exercizesTag })?.children else {
				throw GTError.importFailure([])
		}
		let c = dataManager.newCircuit()
		for e in ex {
			do {
				let o = try GTDataObject.import(fromXML: e, withDataManager: dataManager)
				guard let exercize = o as? GTSetsExercize else {
					throw GTError.importFailure(c.subtreeNodes.union([o]))
				}
				c.add(parts: exercize)
			} catch GTError.importFailure(let obj) {
				throw GTError.importFailure(c.subtreeNodes.union(obj))
			}
		}
		if c.isSubtreeValid {
			return c
		} else {
			throw GTError.importFailure(c.subtreeNodes)
		}
	}
}
