//
//  HistoryPdfGeneratorViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 05/07/2021.
//

import UIKit
import WebKit

class HistoryPdfGeneratorViewController: BaseViewController, TopBarDelegate, WKNavigationDelegate {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var webView: WKWebView!
    //MARK: - Var& Objects
    
    var pdfRecordsList = [HistoryTaskViewModel]()
    //MARK: - override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.createPDF()
       //createPDFFileAndReturnPath()
        if let container = self.mainContainer{
            container.delegate = self
            
        }
    }

    //MARK: - Functions
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createPDF() {
        
        let text = getHistoryDetails()
        
        let html = "<p>\(text)</p> <hr>"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChecklistReport").appendingPathExtension("pdf")
        else { fatalError("Destination URL not created") }
        
        pdfData.write(toFile: "\(documentsPath)/ChecklistReport.pdf", atomically: true)
        loadPDF(filename: "ChecklistReport.pdf")
    }
    
    func loadPDF(filename: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(filename)//.appendingPathExtension(".pdf")
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func getHistoryDetails() -> String {
        //let image = #imageLiteral(resourceName: "splash_logo")
        //<img src=\"\(image)\" width=\"50\" height=\"50\">
        var text = "<h1>Technician Completed Task </h1>  <hr> <br> </br> Tech name &emsp; CheckList Name &emsp; Check In &emsp; Check out "
        for record in pdfRecordsList {
            
            let  name = (record.technician?.firstName ?? "") + " " + (record.technician?.lastName ?? "")
            //name = name
            
            let catName = record.categoryName ?? ""
            
            let checkIn = record.activity?.checkIn ?? ""
            
            var checkOut = record.activity?.checkOut ?? ""
            if checkOut.isEmpty {
                checkOut = "N/A"
            }
            text =  text + "<p>" + name + "&emsp;" + catName + "&emsp;" + checkIn + "&emsp;" + checkOut + "&emsp;" + "</p>"
        }
        
        return text
    }
    
//    func generateString() -> String? {
//        var resultString: String?
//
//        let firstString = "<DOCTYPE HTML> \r <html lang=\"en\" \r <head> \r <meta charset = \"utf-8\"> \r </head> \r <body>"
//        let endString = "</body> \r </html>";
//        resultString = firstString + self.receivedContent! + endString;
//
//        return resultString
//    }

    
    // not in use
    func createPDFFileAndReturnPath()  {
        
        let fileName = "ChecklistReport"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let pathForPDF = documentsDirectory.appending("/" + fileName)
        
        UIGraphicsBeginPDFContextToFile(pathForPDF, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 100, height: 400), nil)
        
        let font = UIFont(name: "System", size: 12.0)
        
        let textRect = CGRect(x: 5, y: 3, width: 300, height: 18)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.left
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let textColor = UIColor.black
        
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        var text:String = "CeckList Report *** \n"
        for record in pdfRecordsList {
            text =  text + (record.technician?.lastName ?? "") + "\n"
        }
        
        print(text)
        //let text:NSString = "Hello world"
        
        
        //text.draw(in: textRect, withAttributes: textFontAttributes )
        
    
            
            text.draw(in: textRect)
        
        UIGraphicsEndPDFContext()
        loadPDF(filename: fileName)
        //return fileName//pathForPDF
    }
}
