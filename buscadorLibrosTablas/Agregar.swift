//
//  Agregar.swift
//  buscadorLibrosTablas
//
//  Created by Carlos Buitrago on 25/03/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit

class Agregar: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var textoIn: UITextField!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var agregar: UIButton!
    let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var texIn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textoIn.delegate = self
        texto.font = UIFont.systemFontOfSize(22)
        texto.font = UIFont.boldSystemFontOfSize(20)
        texto.editable = false
        agregar.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        agregar.enabled = false
        sender.resignFirstResponder()
        texIn = textoIn.text!
        let urls2 = urls + texIn
        let url = NSURL(string: urls2)
        let datos = NSData(contentsOfURL: url!)
        if datos == nil{
            let alert = UIAlertController(title:"Error", message: "No hay conexion a Internet", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let textoS = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if textoS as! String == "{}"{
                let alert = UIAlertController(title:"Error", message: "El ISBN no existe", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
            else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    let dico2 = dico1["ISBN:"+texIn] as! NSDictionary
                    let titulo = dico2["title"] as! NSString as String
                    let dico3 = dico2["authors"] as! [NSDictionary]
                    
                    var autores = ""
                    for i in dico3{
                        if autores == ""{
                            autores += "-"
                            autores += i["name"] as! NSString as String
                        }else{
                            autores += "\n-"
                            autores += i["name"] as! NSString as String
                        }
                    }
                    let todo:String = "Titulo:\n" + titulo + "\nAutores:\n" + autores
                    texto.text = todo
                    let dico4 = dico2["cover"] as! NSDictionary?
                    if dico4 != nil{
                        ima.hidden = false
                        let foto = dico4!["large"]as! NSString as String
                        let fot = NSURL(string: foto)
                        let dat = NSData(contentsOfURL: fot!)
                        ima.image = UIImage(data:dat!)
                    }
                    else{
                        ima.hidden = true
                    }
                    agregar.enabled = true
                    
                    
                }
                catch _ {
                    
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cc = segue.destinationViewController as! TVC
        cc.datoIn = texIn
    }
    */

}
