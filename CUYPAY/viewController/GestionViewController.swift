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

    @IBOutlet weak var montoText: UITextField!
    
    @IBOutlet weak var bntTipo: UIButton!
    
    @IBOutlet weak var bntTipoGasto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func seleccionarTipo(_ sender:UIAction ){
        print(sender.title)
        self.bntTipo.setTitle(sender.title, for: .normal)
        movimiento.tipo = sender.title
    }
    
    
    @IBAction func selecccionarTipoGasto(_ sender:UIAction ){
        print(sender.title)
        self.bntTipoGasto.setTitle(sender.title, for: .normal)
        movimiento.descripcion = sender.title
    }
    
    @IBAction func volver(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmar(_ sender: UIButton) {
        guard let montoText = montoText.text,
                  let monto = Double(montoText) else {
                print("Monto inválido")
                return
            }
            
            movimiento.monto = monto
            ingresarMovimiento()
        
    }
    
    
    private func ingresarMovimiento() {
        let urlString = "http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com/api/movimiento/insertar"
            guard let url = URL(string: urlString) else {
                print("URL inválida")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "monto": movimiento.monto,
                "descripcion": movimiento.descripcion,
                "tipo": movimiento.tipo
            ]

            guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
                print("Error al crear el cuerpo de la solicitud")
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error en la solicitud: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Código de respuesta: \(httpResponse.statusCode)")
                }

                if let data = data,
                   let respuesta = String(data: data, encoding: .utf8) {
                    print("Respuesta de la API: \(respuesta)")
                }
            }.resume()
        
    }
    
    
}
