
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var segmentedControl:UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet weak var totalOfMoney: UILabel!
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var arrayIncome = [Double]()
    var arrayIncomeName = [String]()
    var arrayWaste = [Double]()
    var arrayWasteName = [String]() 
    var moneyCount: Double = 0.0
    var expensesSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .FlipHorizontal
        updateLabel()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadData()
        updateLabel()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeRight)
        tableView2.hidden = true
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func loadData() {
        if defaults.objectForKey("arrayIncome") == nil {
            arrayIncome = []
            arrayIncomeName = []
        }else{
            arrayIncome = defaults.objectForKey("arrayIncome") as! Array
            arrayIncomeName = defaults.objectForKey("arrayIncomeName") as! Array
        }
        
        if defaults.objectForKey("arrayWaste") == nil {
            arrayWaste = []
            arrayWasteName = []
        }else{
            arrayWaste = defaults.objectForKey("arrayWaste")as! Array
            arrayWasteName = defaults.objectForKey("arrayWasteName") as! Array
        }
        
        if defaults.objectForKey("moneyCount") == nil {
            moneyCount = 0.0
        }else{
            moneyCount = defaults.objectForKey("moneyCount") as! Double
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel() {
        if expensesSelected{
            totalOfMoney.text = moneyCount.description
        } else {
            var money : Double = 0.0
            for (var i = 0; i < arrayIncome.count; i++) {
                money = money + arrayIncome[i]
            }
            totalOfMoney.text = money.description
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableView2){
            return arrayIncome.count
        }else{
            return arrayWaste.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell")
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellSubtitle")
        if (tableView == tableView2){
            cell.textLabel!.text = self.arrayIncomeName[indexPath.row]
            cell.detailTextLabel?.text = self.arrayIncome[indexPath.row].description
            cell.backgroundColor = UIColor.clearColor()
            cell.opaque = false
            cell.backgroundView = nil
            cell.textLabel!.textColor = UIColor.orangeColor()
            cell.detailTextLabel?.textColor = UIColor.orangeColor()
            return cell
        } else {
            cell.textLabel!.text = self.arrayWasteName[indexPath.row]
            cell.detailTextLabel?.text = self.arrayWaste[indexPath.row].description
            cell.backgroundColor = UIColor.clearColor()
            cell.opaque = false
            cell.backgroundView = nil
            cell.textLabel!.textColor = UIColor.orangeColor()
            cell.detailTextLabel?.textColor = UIColor.orangeColor()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    @IBAction func segmentedChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            expensesSelected = true
            tableView.hidden = false
            tableView2.hidden = true
            updateLabel()
        case 1:
            expensesSelected = false
            tableView2.hidden = false
            tableView.hidden = true
            updateLabel()
        default:
            break;
        }
    }
   
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let i = indexPath.row
            if (expensesSelected){
                moneyCount = moneyCount - arrayWaste[i]
                arrayWaste.removeAtIndex(i)
                arrayWasteName.removeAtIndex(i)
                defaults.setObject(arrayWaste, forKey: "arrayWaste")
                defaults.setObject(arrayWasteName, forKey: "arrayWasteName")
                defaults.setObject(moneyCount, forKey: "moneyCount")
                defaults.synchronize()
                updateLabel()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            } else {
                arrayIncome.removeAtIndex(i)
                arrayIncomeName.removeAtIndex(i)
                defaults.setObject(arrayIncome, forKey: "arrayIncome")
                defaults.setObject(arrayIncomeName, forKey: "arrayIncomeName")
                defaults.synchronize()
                updateLabel()
                tableView2.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            }
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
