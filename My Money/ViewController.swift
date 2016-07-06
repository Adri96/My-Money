
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var pointButton: UIButton!
    var enter: Int = 0
    var decimal: Int = 0
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var arrayIncome = [Double]()
    var arrayIncomeName = [String]()
    var arrayWaste = [Double]()
    var arrayWasteName = [String]()
    var number: Double = 0.0
    var moneyCount: Double = 0.0
    var monthA: Int = 0
    var pointPushed = false
    var zeroEnZero = false
    var zeroEnZeroPrimer = true
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordView: UIView!
     var firstTime: Bool = false
    var passwordPassed: Bool = false
    @IBOutlet var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            arrayWasteName = defaults.objectForKey("arrayWasteName")as! Array
        }
        if defaults.objectForKey("moneyCount") == nil {
            moneyCount = 0.0
        }else{
            moneyCount = defaults.objectForKey("moneyCount")as! Double
            
        }
        
        if defaults.objectForKey("monthA") == nil{
            monthA = 0
        } else {
            monthA = defaults.objectForKey("monthA") as! Int
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.component(.Month, fromDate: date)
        let month = components
        if month > monthA && monthA != 0{
            print(month)
            var n = 0.0
            for(var i = 0; i < arrayIncome.count; i++){
                n = n + arrayIncome[i]
            }
            moneyCount = moneyCount + n;
            defaults.setObject(moneyCount, forKey: "moneyCount")
            let alert = UIAlertController(title: "A new month is here!", message: "All the income and expenses values have been charged", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        defaults.setObject(month, forKey: "monthA")
        productNameTextField.delegate = self
        
        if defaults.objectForKey("firstTime") == nil {
            firstTime = true
            passwordField.secureTextEntry = false
            print(enterButton.titleLabel?.text)
            enterButton.titleLabel?.text = "new password"
            print(enterButton.titleLabel?.text)
        }else{
            firstTime = defaults.objectForKey("firstTime")as! Bool
            passwordField.secureTextEntry = true
        }
        defaults.setBool(false, forKey: "firstTime")
        passwordField.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches as Set<UITouch>, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func goPassword() {
            if(firstTime) {
                self.view.endEditing(true)
                defaults.setObject(passwordField.text, forKey: "password")
                self.view.endEditing(true)
                passwordPassed = true
                goToMainView()
                print("OK")
            } else {
                let password = defaults.objectForKey("password") as! String
                if(passwordField.text == password){
                    self.view.endEditing(true)
                    passwordPassed = true
                    goToMainView()
                    print("OK")
                } else {
                    print("Wrong password")
                }
            }
    }
    
    func goToMainView() {
        if(passwordPassed) {
            passwordView.hidden = true
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if(passwordPassed) {
            let view2 = self.storyboard?.instantiateViewControllerWithIdentifier("view2") as! TableViewController
            self.presentViewController(view2, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(sender: UIButton) {
        enter = 0
        decimal = 0
        zeroEnZero = false
        zeroEnZeroPrimer = true
        updateLabel()
        pointPushed = true
        point(pointButton)
        productNameTextField.text = "Name"
    }
    
    @IBAction func income(sender: UIButton){
        if productNameTextField.text == "Name"{
            let alert = UIAlertController(title: "No income name", message: "Write a new one!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            numberValue()
            arrayIncome.append(number)
            arrayIncomeName.append(productNameTextField!.text!)
            priceTag.text = "OK!"
            defaults.setObject(arrayIncome, forKey: "arrayIncome")
            defaults.setObject(arrayIncomeName, forKey: "arrayIncomeName")
            defaults.synchronize()
            clear2()
        }
    }
    
    @IBAction func expenses(sender: UIButton){
        if productNameTextField.text == "Name"{
            let alert = UIAlertController(title: "No expenses name", message: "Write a new one!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            numberValue()
            arrayIncome.append(-number)
            arrayIncomeName.append(productNameTextField.text!)
            priceTag.text = "OK!"
            defaults.setObject(arrayIncome, forKey: "arrayIncome")
            defaults.setObject(arrayIncomeName, forKey: "arrayIncomeName")
            defaults.synchronize()
            clear2()
        }
    }
    
    @IBAction func one(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 1
        }else{
            enter = enter*10 +  1
        }
        updateLabel()
    }

    @IBAction func two(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 2
        }else{
            enter = enter*10 +  2
        }
        updateLabel()
    }
    
    @IBAction func three(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 3
        }else{
         enter = enter*10 +  3
        }
        updateLabel()
    }

    @IBAction func four(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 4
        }else{
         enter = enter*10 +  4
        }
        updateLabel()
    }

    @IBAction func five(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 5
        }else{
         enter = enter*10 +  5
        }
        updateLabel()
    }

    @IBAction func six(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 6
        }else{
         enter = enter*10 +  6
        }
        updateLabel()
    }

    @IBAction func seven(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 7
        }else{
         enter = enter*10 +  7
        }
        updateLabel()
    }

    @IBAction func eight(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 8
        }else{
         enter = enter*10 +  8
        }
        updateLabel()
    }
    
    @IBAction func nine(sender: UIButton){
        if pointPushed{
            decimal = decimal*10 + 9
        }else{
         enter = enter*10 +  9
        }
        updateLabel()
    }

    @IBAction func point(sender: UIButton){
        if(pointPushed) {
            pointPushed = false
            pointButton.backgroundColor = UIColor.orangeColor()
        } else {
          pointPushed = true
          pointButton.backgroundColor = UIColor.lightGrayColor()
        }
    }

    @IBAction func zero(sender: UIButton) {
        if pointPushed{
            if decimal > 0{
                decimal = decimal*10
            }else{
                zeroEnZero = true
            }
        }else{
            if enter > 0{
                enter = enter*10
            }
        }
        updateLabel()
    }
    
    @IBAction func add(sender: UIButton) {
        if productNameTextField.text == "Name"{
            let alert = UIAlertController(title: "No aportation of money name", message: "Write a new one!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            numberValue()
            arrayWaste.append(number)
            moneyCount = moneyCount + number
            defaults.setObject(moneyCount, forKey: "moneyCount")
            arrayWasteName.append(productNameTextField.text!)
            priceTag.text = "OK"
            defaults.setObject(arrayWaste, forKey: "arrayWaste")
            defaults.setObject(arrayWasteName, forKey: "arrayWasteName")
            defaults.synchronize()
            clear2()
        }
    }
    
    @IBAction func minus(sender: UIButton) {
        if productNameTextField.text == "Name"{
            let alert = UIAlertController(title: "No expense name", message: "Write a new one!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            numberValue()
            arrayWaste.append(-number)
            moneyCount = moneyCount - number
            defaults.setObject(moneyCount, forKey: "moneyCount")
            arrayWasteName.append(productNameTextField.text!)
            priceTag.text = "OK"
            defaults.setObject(arrayWaste, forKey: "arrayWaste")
            defaults.setObject(arrayWasteName, forKey: "arrayWasteName")
            defaults.synchronize()
            clear2()
        }
    }
    
    @IBAction func canIAffordThis(sender: UIButton) {
        if enter == 0 && decimal == 0 {
            priceTag.text = "It's FREE!"
        } else {
            var valor:Double = 0.0
            for var i = 0; i < arrayIncome.count; i++ {
                valor = valor + arrayIncome[i]
            }
            var valorMitja: Double = 0.0
            for var i = 0; i < arrayWaste.count; i++ {
                valorMitja = valorMitja + -arrayWaste[i]
            }
            valorMitja = valorMitja/Double(arrayWaste.count)
            numberValue()
            valor = valor - number - valorMitja
            if valor > 0{
                priceTag.text = "YES!"
            }else{
                priceTag.text = "NO"
            }
        }
    }
    
    func updateLabel(){
        if zeroEnZero{
            if zeroEnZeroPrimer{
                puntsAlsMilers(enter.description)
                priceTag.text = enter.description + "." + decimal.description
                zeroEnZeroPrimer = false
            } else{
                priceTag.text = enter.description + ".0" + decimal.description
            }
        }else {
            priceTag.text = enter.description + "." + decimal.description
        }
        
    }
    
    func puntsAlsMilers(var Nenter: String) -> String{
        //print(Nenter[0])
        return Nenter
    }
    
    func elevar(base: Int, exp: Int) -> Double{
        var resultat: Double = 1
        for(var i = 0; i < exp; i++){
            resultat = resultat * Double(base)
        }
        return resultat;
    }
    
    func numberValue() {
        var decimalCount = 1
        var decimal2 = decimal
        while(decimal2 > 9){
            decimal2 = decimal2/10
            decimalCount = decimalCount + 1
        }
        var decimal3: Double
        decimal3 = Double(decimal)/(elevar(10, exp: decimalCount));
        print(decimal)
        if zeroEnZero{
          number = Double(enter) + Double(decimal3)*0.1
        }else{
         number = Double(enter) + Double(decimal3)
        }
        //print(number)
    }
    
    func clear2() {
        enter = 0
        decimal = 0
        zeroEnZero = false
        zeroEnZeroPrimer = true
        productNameTextField.text = "Name"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
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
            arrayWasteName = defaults.objectForKey("arrayWasteName")as! Array
        }
        if defaults.objectForKey("moneyCount") == nil {
            moneyCount = 0.0
        }else{
            moneyCount = defaults.objectForKey("moneyCount")as! Double
            
        }
    }
    
}

