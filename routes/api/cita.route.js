var express = require('express');
var cita = require('../../model/cita.model');
var services = require('../../services');
var router = express.Router();


router.get('/cita/', services.verificar, function(req, res, next) {
  var idUsuario = req.usuario.usuario_id;
      cita.selectAll(idUsuario, function(error, resultados){
        if(typeof resultados !== undefined) {
          res.json(resultados);
        } else {
          res.json({"Mensaje": "No hay Citas"});
        }
      });

});

router.get('/cita/:id', services.verificar, function(req, res, next) {
  var id = req.params.id;
  cita.select(id, function(citas) {
    if(typeof citas !== 'undefined') {
        console.log("WHAT I FOUND ->" + citas.find(c => c.idCita == id))
      res.json(citas.find(c => c.cita_id == id));
    } else {
      res.json({"mensaje" : "No hay citas"});
    }
  });
});

router.post('/cita', services.verificar, function(req, res, next) {
  var data = {
   asunto : req.body.cita_asunto,
    fecha : req.body.cita_fecha,
    lugar : req.body.cita_lugar,
    idContacto : req.body.contacto_id,
    idUsuario: req.usuario.usuario_id
  };
  console.log(data)
  cita.insert(data, function(resultado){
    if(resultado && resultado.affectedRows > 0) {
      res.json({
        estado: true,
        mensaje: "Se agrego la cita"
      });
    } else {
      res.json({"mensaje":"No se ingreso la cita"});
    }
  });
});

router.put('/cita/:id', services.verificar, function(req, res, next){
  var c = req.params.id;
  var data = {
   asunto : req.body.cita_asunto,
    fecha : req.body.cita_fecha,
    lugar : req.body.cita_lugar,
    idContacto : req.body.contacto_id,
    idUsuario: req.usuario.usuario_id,
    idCita: c
  }
  cita.update(data, function(resultado){
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


router.delete('/cita/:id', services.verificar, function(req, res, next){
  var idC = req.params.id;
  var idU = req.usuario.usuario_id;
  cita.delete(idC, function(resultado){
    if(resultado && resultado.mensaje ===	"Eliminado") {
      res.json({
        estado: true,
        "mensaje":"Se elimino el cita correctamente"
      });
    } else {
      res.json({
        estado: false,
        "mensaje":"No se elimino el cita"});
    }
  });
});

module.exports = router;
