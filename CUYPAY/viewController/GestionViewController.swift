//
//  GestionViewController.swift
//  CUYPAY
//
//  Created by KAWORU on 3/05/25.
//

import UIKit

class GestionViewController: UIViewController {
    
    var movimiento = Movimiento(
        monto: 00.0,
        descripcion: "",
        tipo: ""
    )

    @IBOutlet weak var bntTipo: UIButton!
    
    
    @IBOutlet weak var bntTipoGasto: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func seleccionarTipo(_ sender:UIAction ){
        print(sender.title)
        self.bntTipo.setTitle(sender.title, for: .normal)
    }
    
    
    @IBAction func selecccionarTipoGasto(_ sender:UIAction ){
        print(sender.title)
        self.bntTipoGasto.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func volver(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
