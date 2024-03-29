//
//  Extensions.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit
import JGProgressHUD
// This is a helper class to design the UI. Since I'm not using the storyboard in this app I'm using this helper class to design the UI
// since "Nanameue" is not developed using storyboard I'm not using it in this app

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoading(_ show: Bool, showText: Bool, description: String? = nil){
        view.endEditing(true)
        UIViewController.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        UIViewController.hud.indicatorView?.tintColor = UIColor.white
        
        if show {
            UIViewController.hud.show(in: view, animated: true)
            if showText {
                UIViewController.hud.textLabel.text = description
            } else {
                UIViewController.hud.textLabel.text = ""
            }
        } else {
            UIViewController.hud.dismiss(animated: true)
        }
    }
    
    func showErrorMessage(showErorText: Bool, error: String? = nil){
        view.endEditing(true)
        UIViewController.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        UIViewController.hud.indicatorView?.tintColor = UIColor(named: "red_50_color")
        
        UIViewController.hud.show(in: view, animated: true)
        if showErorText {
            UIViewController.hud.textLabel.text = error
        }
        
        UIViewController.hud.dismiss(afterDelay: 2.0)
    }
}

extension UIButton {
    func attributedText(firstString: String, secondString: String){
        let attribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16)]
        
        let attributedFirstText = NSMutableAttributedString(string: firstString, attributes: attribute)
        
        let boldAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        attributedFirstText.append(NSMutableAttributedString(string: secondString, attributes: boldAttribute))
       
        setAttributedTitle(attributedFirstText, for: .normal)
    }
    
    func defaultButtonStyle(title: String, backgroundColorString: String){
        backgroundColor = UIColor(named: backgroundColorString)
        setTitle(title, for: .normal)
        tintColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        layer.cornerRadius = 25
        isUserInteractionEnabled = true
        setHeight(55)
    }
}

extension UILabel {
    func defaultTitleStyle(titleString: String){
        text = titleString
        font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textColor = .black
        textAlignment = .center
        numberOfLines = -1
    }
}

extension UITextField {
    func showError() {
        borderStyle = .none
        layer.cornerRadius = 12
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
    }
    
    func removeError() {
        borderStyle = .none
        layer.cornerRadius = 12
        layer.borderColor = UIColor(named: "lite_gray_2")!.cgColor
        layer.borderWidth = 1
    }

}

//This extension is used to calculate the height of given String based on font and font size
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func doesContainsWhiteSpace() -> Bool {
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        
        if range != nil {
            return true
        } else {
            return false
        }
    }
}

// Not going to use this extension still it might be useful in future
extension UIImageView {
    public func imageFromURL(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}

//This extension will convert given Timestamp to Time ago format text
extension Date {
    func getTimeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// Below extenson basically it's a class which add constrains to views
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}
