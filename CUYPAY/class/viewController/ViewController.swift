		//
//  ViewController.swift
//  CUYPAY
//
//  Created by DAMII on 16/04/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usuarioText: UITextField!
    
    @IBOutlet weak var contraseniaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.endEditing(true)
        
        agregarPaddingIzquierdo(usuarioText)
        agregarPaddingIzquierdo(contraseniaText)
    }
    	
    func agregarPaddingIzquierdo(_ textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }

    private func inicioSesion() {
            
            let urlString = "http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com/api/usuario/login"
            guard let url = URL(string: urlString) else {
                print("URL inválida")
                return
            }
        

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "usuario": usuarioText.text ?? "",
                "clave": contraseniaText.text ?? ""
            ]
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
                print("Error al crear el cuerpo de la solicitud")
                return
            }
        
            if let bodyDataString = String(data: httpBody, encoding: .utf8) {
                print("Cuerpo enviado: \(bodyDataString)")
            }
        
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                if let error = error {
                    print("Error de red: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No se recibió data")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Respuesta de la API: \(json)")
                        
                        if let status = json["status"] as? String, status.lowercased() == "ok" {
                            // Login exitoso
                            
                            DispatchQueue.main.async {
                                self?.performSegue(withIdentifier: "mostrarInicio", sender: nil)
                            }
                        } else {
                            // Error de login
                            let mensaje = json["message"] as? String ?? "Credenciales incorrectas"
                            
                            DispatchQueue.main.async {
                                self?.mostrarAlerta(titulo: "Error", mensaje: mensaje)
                                
                            }
                        }
                        
                    } else {
                        print("Formato de JSON no esperado")
                    }
                } catch {
                    print("Error al parsear JSON: \(error.localizedDescription)")
                }
                
            }.resume()
        }
    
    
    
    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        
        view.endEditing(true)
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    
    @IBAction func ingresar(_ sender: UIButton) {
        
        guard let usuario = usuarioText.text, !usuario.isEmpty,
                  let contrasenia = contraseniaText.text, !contrasenia.isEmpty else {
                mostrarAlerta(titulo: "Error", mensaje: "Por favor llena todos los campos.")
                return
        }
        
        inicioSesion()
        print("alo")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "mostrarInicio" {
            return false
        }
        return true
    }

    
}

