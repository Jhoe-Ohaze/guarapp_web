'use strict';
const functions = require('firebase-functions');
const app = require('express')();

const admin = require('firebase-admin');
admin.initializeApp();

const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});
let transporter = nodemailer.createTransport({
  host:"mail.guarapark.com",
  port:"465",
  secure: true,
  auth: 
  {
    user: 'noreply@guarapark.com',
    pass: 'Acqu4s&nder'  
  }
});

//////////////////////////////////////////////////
//Trata a requisição feita para a aba pagamentos//
//////////////////////////////////////////////////
app.post('/payments', (request, response) =>
{
  const order_number = request.body.order_number;
  const payment_status = parseInt(request.body.payment_status);

  if(order_number.length > 24) {response.status(400).json("Not a ticket payment");}
  else if(payment_status !== 2 && payment_status !== 7){response.status(401).json("Unauthorized payment code");}
  else
  {
    const year = order_number.substr(0,4);
    const month = order_number.substr(4,2);
    const day = order_number.substr(6,2);

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

    var customeremail = request.body.customer_email;  

    try
    {
      cors(request, response, () => 
      {
        var image = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${order_number}`;
        let email = {
          from: 'Guará Acqua Park',
          to: customeremail,
          subject: 'Bilhete de ingresso',
          html: `<p style="font-size: 16px;">
                 </p>
                 <br />
                 <img src= ${image} />`
        };
    
        transporter.sendMail(email, (error, info) => 
        {
          if(error) 
          {
            return console.log(error);
          }
          return console.log('Mensagem %s enviada: %s', info.messageId, info.response);
        });
      });
    }
    catch(e)
    {
      return response.status(501).json(e);
    }

    const limitCol = admin.firestore().collection('limits').doc('years').collection(year)
      .doc('months').collection(month).doc(day);

    const paymentCol = admin.firestore().collection('payments').doc('years').collection(year)
      .doc('months').collection(month).doc('days').collection(day).doc(order_number);

    const add_amount = adult_amount + kid_amount;

    try
    {
      limitCol.get()
          .then((doc) =>
          {
            var expected = doc.data().expected;
            expected = expected + add_amount;
            limitCol.update({expected: expected});
            return null;
          }).catch((error) => {limitCol.set({limit: 150, expected: add_amount});});
    }
    catch(error){limitCol.set({limit: 150, expected: add_amount});}


    paymentCol.set(data_to_send)
      .then(() => {response.status(200).json("Operation successful"); return null;})
      .catch((error) => {response.status(500).json(error);});
  }
});
exports.app = functions.https.onRequest(app);