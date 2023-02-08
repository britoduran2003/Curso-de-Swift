//
//  ViewController.swift
//  martesCoreData
//
//  Created by user233135 on 2/7/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var listadePaises = [Paises]()
    
    //Referencia al contenedor de CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var miTabla: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leerTareas()
        //     miTabla.dataSource = self
        //    miTabla.delegate   = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func nuevoPais(_ sender: UIBarButtonItem) {
        var nombrePais = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo país", message: "Mensaje", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Add", style: .default){ (_) in
            
            let nuevoPais = Paises(context:self.contexto)
            
            nuevoPais.nombre = nombrePais.text
            nuevoPais.seleccionado = false
            
            self.listadePaises.append(nuevoPais)
            
            self.guardar()
            
        }
        
        alerta.addTextField { textFieldAlerta in
            textFieldAlerta.placeholder = "Escribe el nuevo país"
            
            nombrePais = textFieldAlerta
        }
        
        alerta.addAction(okAction)
        present(alerta,animated: true)
    }
    
    
    
    func guardar(){
        do {
            try contexto.save()
        } catch  {
            print(error.localizedDescription)
        }
        self.miTabla.reloadData()
    }
    
    func leerTareas(){
        let solicitud: NSFetchRequest<Paises> = Paises.fetchRequest()
        
        do {
            listadePaises = try contexto.fetch(solicitud)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
}

    extension  ViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listadePaises.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = miTabla.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            
            let filaPais = listadePaises[indexPath.row]
            
            cell.textLabel?.text = filaPais.nombre
            cell.textLabel?.textColor = filaPais.seleccionado ? .black : .blue
            //   cell.detailTextLabel?.text = filaPais.capital
            
            //Marcar con una paloma los paises seleccionados
            
            cell.accessoryType = filaPais.seleccionado ? .checkmark : .none
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //Para poner y quitar el Check
            if miTabla.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                
                miTabla.cellForRow(at: indexPath)?.accessoryType = .none
                
            }else {
                miTabla.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            //Editar en Core Data
            
            listadePaises[indexPath.row].seleccionado = !listadePaises[indexPath.row].seleccionado
            
            guardar()
            
            
            //deseleccionar la fila
            
            miTabla.deselectRow(at: indexPath, animated: true)
            
        }
        
       
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let accionEliminar = UIContextualAction(style: .normal, title: "Eliminar"){ _,_,_ in
                
                self.contexto.delete(self.listadePaises[indexPath.row])
                
                self.listadePaises.remove(at: indexPath.row)
                
                self.guardar()
            }
            accionEliminar.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [accionEliminar])
        }
        
    }
    
