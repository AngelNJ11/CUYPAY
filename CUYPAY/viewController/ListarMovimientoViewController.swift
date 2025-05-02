//
//  ListarMovimientoViewController.swift
//  CUYPAY
//
//  Created by DAMII on 28/04/25.
//

import UIKit
import CoreData

class ListarMovimientoViewController: UIViewController {

    @IBOutlet weak var fechaDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var movimientoTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var movimmiento:[Movimiento] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movimientoTable.dataSource = self
        movimientoTable.delegate = self
        
        listarMovimento()
    }
    

    @IBAction func datePickerCambio(_ sender: UIDatePicker) {
        
    }
    
    @IBAction func volverBotton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func obtenerIdGuardado()->Int64{
        let fetchRequest: NSFetchRequest<user> = user.fetchRequest()
        do{
            let res = try context.fetch(fetchRequest)
            if let sesion = res.first{
                print("id: \(sesion.id)")
                return Int64(sesion.id)
            }else{
                print("no hay datos en datacore")
                return 0
            }
        }catch{
            return 0
        }
    }
        
    
    func listarMovimento(){
        let baseURL="http://cuypayapi-env.eba-mwhcscrk.us-east-1.elasticbeanstalk.com"

        let movimientoURL="/api/movimiento"

        let peticionCalcularBalance="/listar"//GET

          
            
            
            
        let id = obtenerIdGuardado()
        print("funcion obtenerIdGuardado() = \(id)")
        let mesActual = Calendar.current.component(.month, from: fechaDatePicker.date)
        let anioActual = Calendar.current.component(.year, from: fechaDatePicker.date)
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
                      let lista = json!["ListaMovimiento"] as! [[String : Any]]
                      
                      var movimentosCargados:[Movimiento] = []
                      
                       for item in lista {
                           let descripcion = item["descripcion"] as? String ?? ""
                           let monto = item["monto"] as? Double ?? 0.0
                           let tipo = item["tipo"] as? String ?? ""
                           
                    
                           let movimiento = Movimiento(monto: monto, descripcion: descripcion, tipo: tipo)
                           movimentosCargados.append(movimiento)
                           
                       }
                      DispatchQueue.main.async {
                          self.movimmiento = movimentosCargados
                          self.movimientoTable.reloadData()
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
    
    
extension ListarMovimientoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movimmiento.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "moviminetoCelda", for: indexPath) as! MovimentoTableViewCell
        let movimmiento = movimmiento[indexPath.row]
        celda.descripcionLable.text = movimmiento.descripcion
        celda.montoLable.text = String(movimmiento.monto)
        
        //codicional del fondo de color
        if movimmiento.tipo == "ingreso"{
            celda.contentView.backgroundColor = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 1.0)
                } else {
                    celda.contentView.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0)
                }
        return celda
    }
}
extension ListarMovimientoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            movimmiento.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
