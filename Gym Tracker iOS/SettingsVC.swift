import UIKit
import MBLibrary
import GymTrackerCore
class SettingsViewController: UITableViewController {
	private var appInfo: String!
	private var errNoBackup: String!
	private var backupUsageManual: String!
	private var backupUsageAuto: String!
	private var iCloudEnabled = false
	private var documentController: UIActivityViewController?
	override func viewDidLoad() {
		super.viewDidLoad()
		appDelegate.settings = self
		appInfo = GTLocalizedString("REPORT_TEXT", comment: "Report problem") + "\n\nFitness Tracker App \(AppVersion.currentVersion) (\(AppVersion.bundleVersion))\n© 2019 JunFeng Li"
		errNoBackup = GTLocalizedString("ERR_BACKUP_UNAVAILABLE", comment: "Cannot use becuase...")
		backupUsageManual = GTLocalizedString("BACKUP_USAGE_MANUAL", comment: "How-to")
		backupUsageAuto = GTLocalizedString("BACKUP_USAGE_AUTO", comment: "How-to")
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 0:
			return appInfo
		default:
			return nil
		}
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 2
		default:
			fatalError("Unknown section")
		}
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			return tableView.dequeueReusableCell(withIdentifier: indexPath.row == 0 ? "sourceCode" : "contact", for: indexPath)
		default:
			fatalError("Unknown section")
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			UIApplication.shared.open(URL(string: "https://github.com/Developeriphone/FitnessTrackerApp-Free-training")!)
		default:
			break
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	@IBAction func enableDisableBackups(_ sender: UISwitch) {
		guard iCloudEnabled else {
			return
		}
		appDelegate.dataManager.preferences.useBackups = sender.isOn
		tableView.reloadSections([0], with: .automatic)
		if sender.isOn {
			appDelegate.dataManager.importExportManager.doBackup()
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let id = segue.identifier else {
			return
		}
		switch id {
		case "contact":
			let dest = (segue.destination as! UINavigationController).topViewController as! ContactMeViewController
			dest.appName = "GymTracker"
		default:
			break
		}
	}
}
