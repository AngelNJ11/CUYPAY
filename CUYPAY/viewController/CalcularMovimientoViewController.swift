//
//  CalcularMovimientoViewController.swift
//  CUYPAY
//
//  Created by DAMII on 28/04/25.
//

import UIKit

class CalcularMovimientoViewController: UIViewController {

    @IBOutlet weak var montoLable: UILabel!
    
    @IBOutlet weak var gastoLable: UILabel!
    
    @IBOutlet weak var ingresoLable: UILabel!
    
    let userId = 2
    let mesActual = Int(Calendar.current.component(.month, from: Date()))
    let anioActual = Int(Calendar.current.component(.year, from: Date()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enviarPeticionBalanza()
        enviarPeticionIngreso()
        enviarPeticionGasto()
        
    }
    
    
    @IBAction func cerrarBotton(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "Cerrar Sessión ", message: "¿Deseas cerrar sesión?", preferredStyle: .alert
            )
        
        let cerrarAction = UIAlertAction(title: "Si", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(cerrarAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func enviarPeticionGasto(){
            let baseURL="http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com"

            let movimientoURL="/api/movimiento"

            let peticionCalcularBalance="/gasto"//GET

            let id = userId

            let urlPeticion=URL(string:baseURL+movimientoURL+peticionCalcularBalance+"?id=\(id)&mes=\(mesActual)&anio=\(anioActual)")

            //Crear elemento peticion/request

            var urlRequest = URLRequest(url:urlPeticion!)

            //definir metodo

            urlRequest.httpMethod="GET"

            //Crear Consulta

            let peticion=URLSession.shared.dataTask(with: urlRequest,
                                                    completionHandler:{(data:Data?,
                                                                        urlResponse:URLResponse?,
                                                                        error:Error?) in

              if(error==nil){

                //no hay errors

                if(data != nil && urlResponse != nil){

                  //Procesar datos

                  do{

                    let json = try JSONSerialization.jsonObject(with:data!) as? [String: Any]

                      let campo = json!["GastoMensual"] as! Double
                          print("GastoMensual")
                           
                          DispatchQueue.main.async{
                              
                              self.gastoLable.text = "\(campo)"

                          }
                  }catch{

                    print(error.localizedDescription)

                  }
                }else{

                  print("Data es vacia o urlResponse es vacio")
                }
              }else{
                  print(error?.localizedDescription as Any)
              }
            })
            //ejecuta consulta
            peticion.resume()
        }
        
        func enviarPeticionIngreso(){
            let baseURL="http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com"

            let movimientoURL="/api/movimiento"

            let peticionCalcularBalance="/ingreso"//GET

            let id = userId

            let urlPeticion=URL(string:baseURL+movimientoURL+peticionCalcularBalance+"?id=\(id)&mes=\(mesActual)&anio=\(anioActual)")

            //Crear elemento peticion/request

            var urlRequest = URLRequest(url:urlPeticion!)

            //definir metodo

            urlRequest.httpMethod="GET"

            //Crear Consulta

            let peticion=URLSession.shared.dataTask(with: urlRequest,
                                                    completionHandler:{(data:Data?,
                                                                        urlResponse:URLResponse?,
                                                                        error:Error?) in

              if(error==nil){

                //no hay errors

                if(data != nil && urlResponse != nil){

                  //Procesar datos

                  do{

                    let json = try JSONSerialization.jsonObject(with:data!) as? [String: Any]

                      let campo = json!["IngresoMensual"] as! Double
                          print("CalcularMovimento")
                      print(json as Any)
                          DispatchQueue.main.async{
                              
                              self.ingresoLable.text = "\(campo)"
                        
                          }
                  }catch{

                    print(error.localizedDescription)

                  }
                }else{

                  print("Data es vacia o urlResponse es vacio")
                }
              }else{
                  print(error?.localizedDescription as Any)
              }
            })
            //ejecuta consulta
            peticion.resume()
        }
        func enviarPeticionBalanza(){

            let baseURL="http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com"

            let movimientoURL="/api/movimiento"

            let peticionCalcularBalance="/balance"//GET

            let id = userId

            let urlPeticion=URL(string:baseURL+movimientoURL+peticionCalcularBalance+"?id=\(id)&mes=\(mesActual)&anio=\(anioActual)")

            //Crear elemento peticion/request

            var urlRequest = URLRequest(url:urlPeticion!)

            //definir metodo

            urlRequest.httpMethod="GET"

            //Crear Consulta

            let peticion=URLSession.shared.dataTask(with: urlRequest,
                                                    completionHandler:{(data:Data?,
                                                                        urlResponse:URLResponse?,
                                                                        error:Error?) in

              if(error==nil){

                //no hay errors

                if(data != nil && urlResponse != nil){

                  //Procesar datos

                  do{

                    let json = try JSONSerialization.jsonObject(with:data!) as? [String: Any]

                  let campo = json!["BalanceMensual"] as! Double
                          print("CalcularMovimento")
                          DispatchQueue.main.async{
                              
                              self.montoLable.text = "\(campo)"
                              
                              
                          }
                  }catch{

                    print(error.localizedDescription)

                  }
                }else{

                  print("Data es vacia o urlResponse es vacio")
                }
              }else{
                  print(error?.localizedDescription as Any)
              }
            })
            //ejecuta consulta
            peticion.resume()
          }

}
