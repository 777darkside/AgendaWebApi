var database = require("../config/database.config");
var tarea = {};


tarea.selectAll = function(id, callback) {
  if(database) {
    database.query("SELECT tarea_id, tarea_descripcion, tarea_fecha, tarea_inicio, tarea_fin, tarea_estado FROM Tarea INNER JOIN Usuario ON tarea.tarea_usuario = usuario.usuario_id WHERE tarea.tarea_usuario = ?",id,
    function(error, resultados) {
      if(error) {
        throw error;
      } else {
        callback(null, resultados);
      }
    });
  }
}

tarea.select = function(id, callback) {
	if(database) {
		var query = "SELECT * FROM tarea  INNER JOIN usuario ON tarea.tarea_usuario = usuario.usuario_id  where tarea_id = ?";
    database.query(query, id,
    function(error, resultados) {
      if(error) {
        throw error;
      } else {
        callback(resultados);
      }
    });//Fin query
  }//Fin IF
}

tarea.insert = function(idUsuario, data, callback) {
  if(database) {
    database.query('CALL SP_AgregarTarea(?, now(), now(), ?, ?);', [data.descripcion, data.estado, idUsuario],
    function(error, resultado) {
      if(error) {
        throw error;
      } else {
          console.log("SI SE INSERTO")
        callback({"affectedRows": resultado.affectedRows});
      }
    });
  }
}


tarea.update = function(data, callback) {
  if(database) {
    var sql = "Update Tarea Set tarea_descripcion = ?, tarea_fecha = now(), tarea_inicio = now(), tarea_fin = now(), tarea_estado = ? WHERE tarea_id = ?;";
    database.query(sql, [data.descripcion, data.estado, data.tarea],
    function(error, resultado) {
      if(error) {
        throw error;
      } else {
        callback({"affectedRows": resultado.affectedRows});
      }
    });    
  }
}

tarea.delete = function(id, callback) {
	if(database) {
		database.query('DELETE FROM Tarea WHERE tarea_id = ?', id,
		function(error, resultado){
			if(error){
				throw error;
			} else {
				callback({"mensaje":"Eliminado"});
			}
		});
	}
}
module.exports = tarea;
