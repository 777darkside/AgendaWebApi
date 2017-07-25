var database = require("../config/database.config");
var Cita = {};


Cita.selectAll = function(idUsuario, callback) {
  if(database) {
	var query = "SELECT cita_id, cita_asunto, cita_fecha, cita_lugar, contacto.contacto_id, contacto_nombre, contacto_apellido FROM Cita INNER JOIN Contacto ON Cita.cita_contacto = contacto.contacto_id WHERE cita_usuario = ?;";
    database.query(query, idUsuario,
    function(error, resultados) {
      if(error) {
        throw error;
      } else {
        console.log(JSON.stringify(resultados));
        callback(null, resultados);
      }
    });
  }
}

Cita.select = function(id, callback) {
	if(database) {
		var query = "SELECT cita_id, cita_asunto, cita_fecha, cita_lugar, contacto.contacto_id, contacto_nombre, contacto_apellido FROM Cita  INNER JOIN contacto ON cita.cita_contacto = contacto.contacto_id  where cita_id = ?;";
    database.query(query, id,
    function(error, resultados) {
      if(error) {
        throw error;
      } else {
        callback(resultados);
      }
    });
  }
}
Cita.insert = function(data, callback) {
  if(database) {
		console.log("INSERT INTO -> " + data.fecha + data.lugar + data.asunto + data.idContacto + data.idUsuario)
    database.query('CALL SP_AgregarCita(?, ?, ?, ?, ?);',
    [data.fecha, data.lugar, data.asunto, data.idContacto, data.idUsuario],
    function(error, resultado) {
      if(error) {
        throw error;
      } else {
        callback({"affectedRows": resultado.affectedRows});
      }
    });
  }
}

Cita.update = function(data, callback){
	if(database) {
		database.query('UPDATE Cita SET cita_asunto = ?, cita_fecha = ?, cita_lugar = ?, cita_contacto = ?, cita_usuario = ? WHERE cita_id = ?',
		[data.asunto, data.fecha, data.lugar, data.idContacto, data.idUsuario, data.idCita],
		function(error, resultado){
			if(error) {
				throw error;
			} else {
				callback({"affectedRows": resultado.affectedRows});
			}
		});
	}
}

Cita.delete = function(id, callback) {

	if(database) {
		database.query('DELETE FROM Cita WHERE cita_id = ?', id,
		function(error, resultado){
			if(error){
				throw error;
			} else {
				callback({"mensaje":"Eliminado"});
			}
		});
	}
}


module.exports = Cita;
