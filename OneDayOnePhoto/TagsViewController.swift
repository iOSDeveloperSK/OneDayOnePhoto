import UIKit

class TagsViewController: UITableViewController {
    var tags: [PhotoTag]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newTagButtonPressed:")
    }
    
    func newTagButtonPressed (sender: AnyObject?) {
        let alertController = UIAlertController(title: "New Tag", message: "Setup name for new tag", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler(nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (alertAction) -> Void in
            if let tagTextField = alertController.textFields?.first as UITextField? {
                let tagText = tagTextField.text
                let tag = PhotoTag(text: tagText)
                self.tags?.append(tag)
                self.tableView.reloadData()
            }
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tags = self.tags {
            return tags.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if let tag = self.tags?[indexPath.row] {
            cell.textLabel.text = tag.text
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            self.tags?.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
}
