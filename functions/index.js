const functions = require('firebase-functions');
const app = require('express')();

const admin = require('firebase-admin');
admin.initializeApp();

const limitsDB = admin.firestore().collection('limits');
const paymentsDB = admin.firestore().collection('payments');

//Trata a requisição feita para a aba pagamentos
app.post('/payments', function(request, response)
{
  const order_number = request.body.order_number;
  const payment_status = parseInt(request.body.payment_status);

  if(order_number.length > 24) {response.status(400).json("Not a ticket payment");}
  if(payment_status !== 2 && payment_status !== 7){response.status(401).json("Unauthorized payment code");}

  const year = order_number.substr(0,4);
  const month = order_number.substr(4,6);
  const day = order_number.substr(6,8);

  const item_id = order_number.charAt(8);
  const adult_amount = parseInt(order_number.charAt(9));
  const kid_amount = parseInt(order_number.charAt(10));

  const data_to_send =
  {
    order_number: request.body.order_number,
    price: request.body.amount,
    checkout_cielo_order_number: request.body.checkout_cielo_order_number,
    created_date: request.body.created_date,
    customer_name: request.body.customer_name,
    customer_phone: request.body.customer_phone,
    customer_identity: request.body.customer_identity,
    customer_email: request.body.customer_email,
    payment_maskedcreditcard: request.body.payment_maskedcreditcard,
    payment_status: request.body.payment_status,
    product_id: item_id,
    product_adult_amount: adult_amount,
    product_kid_amount: kid_amount
  };

  const limitDoc = limitsDB.collection(year).collection(month).doc(day);
  const paymentCol = paymentsDB.collection(year).collection(month).collection(day);

  const add_amount = parseInt(adult_amount) + parseInt(kid_amount);
  limidDoc.get()
    .then(function(doc)
    {
      if(doc.exists)
      {
        const base_amount = doc.data().expected;
        const total_amount = base_amount + add_amount;

        doc.data().update({expected: total_amount});
        return null;
      }
      else
      {
        doc.set({total: 150, expected: add_amount});
        return null;
      }
    }).catch(function(error){});

  paymentCol.add(data_to_send)
    .then(function(){return response.status(200).json("Operation successful")})
    .catch(function(error){return response.status(500).json(error)});

});

exports.app = functions.https.onRequest(app);