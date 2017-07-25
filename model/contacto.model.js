var database = require("../config/database.config");
var Contacto = {};

Contacto.select = function(idUsuario, callback) {
  if(database) {
		console.log("LOGGED USER*****> " + idUsuario)
		database.query('CALL SP_MostrarContactos(?);', idUsuario,
     function(error, resultados){
			if(error) {
				throw error;
			} else {
				callback(resultados[0]);
			}
		});
	}
}

Contacto.insert = function(data, callback) {
	console.log('CALL SP_AgregarContacto(?, ?, ?, ?, ?, ?, ?);',
		[data.nombre, data.apellido, data.telefono, data.direccion, data.correo, data.idCategoria, data.idUsuario]);
  if(database) {
		database.query('CALL SP_AgregarContacto(?, ?, ?, ?, ?, ?, ?);',
		[data.nombre, data.apellido, data.telefono, data.direccion, data.correo, data.idCategoria, data.idUsuario],
    function(error, resultado) {
      if(error) {
        throw error;	
      } else {
        callback({"affectedRows": resultado.affectedRows});
      }
    });
  }
}

Contacto.update = function(data, callback){
	if(database) {
		console.log('call SP_ModificarContacto(' + data.idContacto + ', "'+ data.nombre +'", "'+
		 data.apellido+'", "'+ data.direccion +'", "'+ data.telefono +'", "'+ data.correo +'", '+ data.idCategoria +');')
		database.query('call SP_ModificarContacto(?, ?, ?, ?, ?, ?, ?);',
		[data.idContacto, data.nombre, data.apellido, data.direccion, data.telefono, data.correo, data.idCategoria],
		function(error, resultado){
			if(error) {
				throw error;
			} else {
				callback({"affectedRows": resultado.affectedRows});
			}
		});
	}
}

Contacto.delete = function(idContacto, callback) {
	if(database) {
		database.query('call SP_EliminarContacto(?);', idContacto,
		function(error, resultado){
			if(error){
				throw error;
			} else {
				callback({"mensaje":"Eliminado"});
			}
		});
	}
}

module.exports = Contacto;
