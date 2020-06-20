//
//  SaveLoad.swift
//  ZombieSurvival
//
//  Created by Fernando on 19/06/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import UIKit
import SpriteKit

class SaveLoad: SKScene {
    
    func saveGame(){
           //  Recupera el directorio de la Biblioteca de la aplicación interactuando con el sistema de archivos usando el FileManager
           let fileManager = FileManager.default
           guard let directory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
               else{return}
           // Configura la URL del directorio para el nuevo archivo
           let saveURL = directory.appendingPathComponent("SavedGames")
           // La creación de directorios puede fallar por varias razones. Adjuntando esto en un intento ... catch le permite capturar y mostrar cualquier error que ocurra. Esto no fallará si el directorio ya existe.
           do{
               try fileManager.createDirectory(atPath: saveURL.path, withIntermediateDirectories: true, attributes: nil)
           }catch let error as NSError{
               fatalError("Failed to create directory: \(error.debugDescription)")
           }
           // Luego configura la ruta final para el nuevo archivo. Imprimir el nombre del archivo es útil para que luego pueda ubicarlo en el sistema de archivos.
           let fileURL = saveURL.appendingPathComponent("saved-game")
           print("* saving: \(fileURL.path)")
           // Finalmente, archivas la escena en el archivo. NSKeyedArchiver comienza en el nivel de escena y serializa cada nodo en el gráfico de objetos de escena.
           do{
           let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
           try data.write(to: fileURL)
           }catch{print("Couldn't write file")}
       }
       
    
       func loadGame() -> SKScene? { print("* loading game")
       var scene: SKScene?
           
       // Obtener el directorio de la biblioteca.
       let fileManager = FileManager.default
       guard let directory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
           else { return nil }
           
         // Crea la URL para el juego guardado.
       let url = directory.appendingPathComponent( "SavedGames/saved-game")
       print(url)
       // Si existe un juego guardado, desarchive la escena del archivo del juego. Después de desarchivar, elimine el archivo guardado.
           do{
            let data = try Data(contentsOf: url)
               if FileManager.default.fileExists(atPath: url.path) {
                scene = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [SKScene.self], from: data) as? SKScene
               _ = try? fileManager.removeItem(at: url)
               }
           }catch{
               print("couldn't read the file")
           }
       
         return scene
       }

}
