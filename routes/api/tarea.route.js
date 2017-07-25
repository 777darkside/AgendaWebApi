var express = require('express');
var tarea = require('../../model/tarea.model');
var services = require('../../services');
var router = express.Router();


router.get('/tarea/', services.verificar, function(req, res, next) {
  var idUsuario = req.usuario.usuario_id;
  tarea.selectAll(idUsuario, function(error, resultados){
        if(typeof resultados !== undefined) {
          res.json(resultados);
        } else {
          res.json({"Mensaje": "No hay tareas"});
        }
      });
    
});
    


router.get('/tarea/:id', services.verificar, function(req, res, next) {
  var idTarea = req.params.id;
  tarea.select(idTarea, function(resultado) {
    if(typeof resultado !== 'undefined') {
        console.log("WHAT I FOUND" + resultado.find(c => c.tarea_id == idTarea))
      res.json(resultado.find(c => c.tarea_id == idTarea));
    } else {
      res.json({"mensaje" : "No hay tareas"});
    }
  });
});

router.post('/tarea', services.verificar, function(req, res, next) {
  var id = req.usuario.usuario_id;
  var data = {
    idTarea : req.body.tarea_id,
    descripcion : req.body.tarea_descripcion,
    estado : req.body.tarea_estado,
  };
console.log("SE ARMO EL JSON" + data)
  tarea.insert(id, data, function(resultado){
    if(resultado && resultado.affectedRows > 0) {
      res.json({
        estado: true,
        mensaje: "Se agrego la Tarea"
      });
    } else {
      res.json({"mensaje":"No se ingreso la Tarea"});
    }
  });
});

router.put('/tarea/:id', services.verificar, function(req, res, next){
  var id = req.params.id;
  var data = {
    tarea : id,
    descripcion : req.body.tarea_descripcion,
    fecha: req.body.tarea_fecha,
    inicio : req.body.tarea_inicio,
    fin : req.body.tarea_fin,
    estado : req.body.tarea_estado,
    usuario: req.usuario.usuario_id
  }
  tarea.update(data, function(resultado){
    if(resultado && resultado.affectedRows > 0) {
      res.json({
        estado: true,
        mensaje: "Se ha modificado con exito"
      });
    } else {
      res.json({
        estado: false,
        mensaje: "No se pudo modificar"
      });
    }
  });
});
router.delete('/tarea/:id', services.verificar, function(req, res, next){
  var idC = req.params.id;
  var idU = req.usuario.idUsuario;
  var data = {
    idUsuario: idU,
    idContacto: idC
  }
  tarea.delete(idC, function(resultado){
    if(resultado && resultado.mensaje ===	"Eliminado") {
      res.json({
        estado: true,
        "mensaje":"Se elimino la tarea correctamente"
      });
    } else {
      res.json({
        estado: false,
        "mensaje":"No se elimino la tarea"});
    }
  });
});

module.exports = router;