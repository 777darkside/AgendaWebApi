var mysql = require('mysql');
var parametros =  {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'AgendaCool'
}
var connection = mysql.createConnection(parametros);

module.exports = connection;
