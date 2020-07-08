const functions = require('firebase-functions');
const app = require('express')();

const admin = require('firebase-admin');
admin.initializeApp();

const limitsDB = admin.firestore().collection('limits');
const paymentsDB = admin.firestore().collection('payments');

//Trata a requisição feita para a aba pagamentos
app.post('/payments', function(request, response)
{
  var order_number = request.body.order_number;
  if(order_number.length > 24) {return response.status(400).json("");}

  var year = order_number.substr(0,4);
  var month = order_number.substr(4,6);
  var day = order_number.substr(6,8);
  var item_id = order_number.charAt(8);
  var adult_amount = order_number.charAt(9);
  var kid_amount = order_number.charAt(10);

  paymentsDB.collection(year).collection(month).collection(day).add();

  response.status(200).json(order_number.length);
});

exports.app = functions.https.onRequest(app);