//
//  ViewController.swift
//  TechtaGram
//
//  Created by maya on 2020/09/18.
//  Copyright © 2020 maya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工の元画像
    var originalImage: UIImage!
    //加工するフィルターの宣言
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //camera button
    @IBAction func takePhoto() {
        
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        } else {
            // カメラが使えない時のエラー
            print("error")
        }
        
    }
    
    //カメラ, カメラロールを使った時に選択した画像をアプリ内に表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }

    //save button
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    //filter button
    @IBAction func colorFilter() {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIPixellate")!
        //CIColorControls
        filter.setValue(filterImage, forKey: kCIInputImageKey)
//        //彩度
//        filter.setValue(1.0, forKey: "inputSaturation")
//        //明度
//        filter.setValue(0.5, forKey: "inputBrightness")
//        //コントラスト
//        filter.setValue(2.5, forKey: "inputContrast")
        filter.setValue(15.00, forKey: "inputScale")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    //album button
    @IBAction func openAlbum() {
        //カメラロールを使えるか
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //カメラロールの画像を選択して保存
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    //share button
    @IBAction func snsPhoto() {
        // 投稿するときに一緒に載せるコメント
        let shareText = "写真加工いえい"
        
        //投稿時の画像
        let shareImage = cameraImageView.image
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage!]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }
}

