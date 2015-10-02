
import UIKit

// MARK: - Delegate
@objc public protocol WMFTableOfContentsViewControllerDelegate {
    
    func tableOfContentsController(controller: WMFTableOfContentsViewController, didSelectSection: MWKSection)
}


// MARK: - Controller
public class WMFTableOfContentsViewController: UITableViewController {
    
    // MARK: - init
    public required init(sections: Array<MWKSection>, delegate: WMFTableOfContentsViewControllerDelegate) {
        self.sections = sections
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let delegate: WMFTableOfContentsViewControllerDelegate
    
    // MARK: - Sections
    let sections: Array<MWKSection>

    func sectionAtIndexPath(indexPath: NSIndexPath) -> MWKSection? {
        guard indexPath.row < self.sections.count else {
            return nil
        }
        return self.sections[indexPath.row]
    }
    
    func indexPathForSection(section: MWKSection) -> NSIndexPath? {
        if let row = self.sections.indexOf(section) {
            return NSIndexPath.init(forRow: row, inSection: 0)
        } else {
            return nil
        }
    }
    
    public func scrollToSection(section: MWKSection, animated: Bool) {
        if let indexPath = self.indexPathForSection(section) {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
        }
    }

    public func selectAndScrollToSection(section: MWKSection, animated: Bool) {
        if let indexPath = self.indexPathForSection(section) {
            self.tableView.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: UITableViewScrollPosition.Top)
        }
    }
    
    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(WMFTableOfContentsCell.wmf_classNib(), forCellReuseIdentifier: WMFTableOfContentsCell.reuseIdentifier());
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - UITableViewDataSource
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sections.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(WMFTableOfContentsCell.reuseIdentifier(), forIndexPath: indexPath) as! WMFTableOfContentsCell
        if let section = self.sectionAtIndexPath(indexPath) {
            cell.section = section
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let section = self.sectionAtIndexPath(indexPath) {
            self.delegate.tableOfContentsController(self, didSelectSection: section)
        }
    }
}
