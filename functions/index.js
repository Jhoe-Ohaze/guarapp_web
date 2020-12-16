'use strict';
const functions = require('firebase-functions');
const app = require('express')();

const admin = require('firebase-admin');
admin.initializeApp();

const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});
let transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
      user: '************',
      pass: '************'
  }
});

//////////////////////////////////////////////////
//Trata a requisição feita para a aba pagamentos//
//////////////////////////////////////////////////
app.post('/payments', (request, response) =>
{
  const order_number = request.body.order_number;
  const payment_status = parseInt(request.body.payment_status);
  var customeremail = request.body.customer_email;  

  if(order_number.length > 24) {response.status(400).json("Not a ticket payment");}
  else if(payment_status === 3)
  {
    var negatedmail = ``;
    if(customeremail !== null)
    {
      negatedmail = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

      <html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">
      <head>
      <!--[if gte mso 9]><xml><o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><![endif]-->
      <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
      <meta content="width=device-width" name="viewport"/>
      <!--[if !mso]><!-->
      <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
      <!--<![endif]-->
      <title></title>
      <!--[if !mso]><!-->
      <!--<![endif]-->
      <style type="text/css">
          body {
            margin: 0;
            padding: 0;
          }
      
          table,
          td,
          tr {
            vertical-align: top;
            border-collapse: collapse;
          }
      
          * {
            line-height: inherit;
          }
      
          a[x-apple-data-detectors=true] {
            color: inherit !important;
            text-decoration: none !important;
          }
        </style>
      <style id="media-query" type="text/css">
          @media (max-width: 670px) {
      
            .block-grid,
            .col {
              min-width: 320px !important;
              max-width: 100% !important;
              display: block !important;
            }
      
            .block-grid {
              width: 100% !important;
            }
      
            .col {
              width: 100% !important;
            }
      
            .col>div {
              margin: 0 auto;
            }
      
            img.fullwidth,
            img.fullwidthOnMobile {
              max-width: 100% !important;
            }
      
            .no-stack .col {
              min-width: 0 !important;
              display: table-cell !important;
            }
      
            .no-stack.two-up .col {
              width: 50% !important;
            }
      
            .no-stack .col.num4 {
              width: 33% !important;
            }
      
            .no-stack .col.num8 {
              width: 66% !important;
            }
      
            .no-stack .col.num4 {
              width: 33% !important;
            }
      
            .no-stack .col.num3 {
              width: 25% !important;
            }
      
            .no-stack .col.num6 {
              width: 50% !important;
            }
      
            .no-stack .col.num9 {
              width: 75% !important;
            }
      
            .video-block {
              max-width: none !important;
            }
      
            .mobile_hide {
              min-height: 0px;
              max-height: 0px;
              max-width: 0px;
              display: none;
              overflow: hidden;
              font-size: 0px;
            }
      
            .desktop_hide {
              display: block !important;
              max-height: none !important;
            }
          }
        </style>
      </head>
      <body class="clean-body" style="margin: 0; padding: 0; -webkit-text-size-adjust: 100%; background-color: #ffffff;">
      <!--[if IE]><div class="ie-browser"><![endif]-->
      <table bgcolor="#ffffff" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #ffffff; width: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td style="word-break: break-word; vertical-align: top;" valign="top">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#ffffff"><![endif]-->
      <div style="background-color:#3c68d0;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#3c68d0;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 0px solid #5976CF; border-left: 0px solid #5976CF; border-bottom: 0px solid #5976CF; border-right: 0px solid #5976CF;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid #5976CF; border-left:0px solid #5976CF; border-bottom:0px solid #5976CF; border-right:0px solid #5976CF; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <div align="center" class="img-container center autowidth" style="padding-right: 0px;padding-left: 0px;">
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 0px;padding-left: 0px;" align="center"><![endif]--><img align="center" alt="Guará Acqua Park" border="0" class="center autowidth" src="https://pbs.twimg.com/media/EebkkkjXoAAWHM7?format=jpg&amp;name=small" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: 0; width: 100%; max-width: 650px; display: block;" title="Guará Acqua Park" width="650"/>
      <!--[if mso]></td></tr></table><![endif]-->
      </div>
      <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px;" valign="top">
      <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-top: 0px solid transparent; height: 0px; width: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top"><span></span></td>
      </tr>
      </tbody>
      </table>
      </td>
      </tr>
      </tbody>
      </table>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:transparent;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px;" valign="top">
      <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-top: 0px solid transparent; height: 0px; width: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top"><span></span></td>
      </tr>
      </tbody>
      </table>
      </td>
      </tr>
      </tbody>
      </table>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:transparent;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 4px solid #6F8BCD; border-left: 4px solid #6F8BCD; border-bottom: 4px solid #6F8BCD; border-right: 4px solid #6F8BCD;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:55px; padding-bottom:60px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 642px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:4px solid #6F8BCD; border-left:4px solid #6F8BCD; border-bottom:4px solid #6F8BCD; border-right:4px solid #6F8BCD; padding-top:55px; padding-bottom:60px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]-->
      <div style="color:#3c68d0;font-family:Poppins, Arial, Helvetica, sans-serif;line-height:1.2;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;">
      <div style="line-height: 1.2; font-size: 12px; color: #3c68d0; font-family: Poppins, Arial, Helvetica, sans-serif; mso-line-height-alt: 14px;">
      <p style="font-size: 14px; line-height: 1.2; word-break: break-word; text-align: center; mso-line-height-alt: 17px; margin: 0;"><strong><span style="font-size: 30px;">Olá ${request.body.customer_name},</span></strong></p>
      </div>
      </div>
      <!--[if mso]></td></tr></table><![endif]-->
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 50px; padding-left: 50px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]-->
      <div style="color:#707b9d;font-family:Poppins, Arial, Helvetica, sans-serif;line-height:1.2;padding-top:10px;padding-right:50px;padding-bottom:10px;padding-left:50px;">
      <div style="line-height: 1.2; font-size: 12px; color: #707b9d; font-family: Poppins, Arial, Helvetica, sans-serif; mso-line-height-alt: 14px;">
      <p style="font-size: 28px; line-height: 1.2; word-break: break-word; text-align: center; mso-line-height-alt: 34px; margin: 0;"><span style="font-size: 28px;">infelizmente o responsável pelo seu meio de pagamento negou a transação do seu pedido de ID ${request.body.order_number}. Por favor, tente novamente ou compre seu ingresso diretamente na bilheteria.</span></p>
      </div>
      </div>
      <!--[if mso]></td></tr></table><![endif]-->
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:transparent;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <div></div>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      </td>
      </tr>
      </tbody>
      </table>
      <!--[if (IE)]></div><![endif]-->
      </body>
      </html>`;
    }

    try
    {
      cors(request, response, () => 
      {
        var image = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${order_number}`;
        let email = {
          from: '"Guará Acqua Park" <noreply@guarapark.com>',
          to: customeremail,
          subject: 'Bilhete de ingresso',
          html: negatedmail
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
  }
  else if(payment_status !== 2 && payment_status !== 7){response.status(200).json("ok, but not paid");}
  else
  {
    const year = order_number.substr(0,4);
    const month = order_number.substr(4,2);
    const day = order_number.substr(6,2);

    const item_id = order_number.charAt(8);
    const adult_amount = parseInt(order_number.charAt(9));
    const kid_amount = parseInt(order_number.charAt(10));

    const limitNumber = 600;

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
      confirmed_status: "",
      payment_maskedcreditcard: request.body.payment_maskedcreditcard,
      payment_status: request.body.payment_status,
      product_id: item_id,
      product_adult_amount: adult_amount,
      product_kid_amount: kid_amount
    };

    var code_request = `http://barcodes4.me/barcode/c128b/${request.body.order_number}.jpg?resolution=2&margin=40&height=400`;
    var emailhtml = ``;
    var emailLogo = `https://pbs.twimg.com/media/EebkkkjXoAAWHM7?format=jpg&name=small`;
    
    if(customeremail !== null) 
    {
      emailhtml = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

      <html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">
      <head>
      <!--[if gte mso 9]><xml><o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><![endif]-->
      <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
      <meta content="width=device-width" name="viewport"/>
      <!--[if !mso]><!-->
      <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
      <!--<![endif]-->
      <title></title>
      <!--[if !mso]><!-->
      <!--<![endif]-->
      <style type="text/css">
          body {
            margin: 0;
            padding: 0;
          }
      
          table,
          td,
          tr {
            vertical-align: top;
            border-collapse: collapse;
          }
      
          * {
            line-height: inherit;
          }
      
          a[x-apple-data-detectors=true] {
            color: inherit !important;
            text-decoration: none !important;
          }
        </style>
      <style id="media-query" type="text/css">
          @media (max-width: 670px) {
      
            .block-grid,
            .col {
              min-width: 320px !important;
              max-width: 100% !important;
              display: block !important;
            }
      
            .block-grid {
              width: 100% !important;
            }
      
            .col {
              width: 100% !important;
            }
      
            .col>div {
              margin: 0 auto;
            }
      
            img.fullwidth,
            img.fullwidthOnMobile {
              max-width: 100% !important;
            }
      
            .no-stack .col {
              min-width: 0 !important;
              display: table-cell !important;
            }
      
            .no-stack.two-up .col {
              width: 50% !important;
            }
      
            .no-stack .col.num4 {
              width: 33% !important;
            }
      
            .no-stack .col.num8 {
              width: 66% !important;
            }
      
            .no-stack .col.num4 {
              width: 33% !important;
            }
      
            .no-stack .col.num3 {
              width: 25% !important;
            }
      
            .no-stack .col.num6 {
              width: 50% !important;
            }
      
            .no-stack .col.num9 {
              width: 75% !important;
            }
      
            .video-block {
              max-width: none !important;
            }
      
            .mobile_hide {
              min-height: 0px;
              max-height: 0px;
              max-width: 0px;
              display: none;
              overflow: hidden;
              font-size: 0px;
            }
      
            .desktop_hide {
              display: block !important;
              max-height: none !important;
            }
          }
        </style>
      </head>
      <body class="clean-body" style="margin: 0; padding: 0; -webkit-text-size-adjust: 100%; background-color: #ffffff;">
      <!--[if IE]><div class="ie-browser"><![endif]-->
      <table bgcolor="#ffffff" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #ffffff; width: 100%;" valign="top" width="100%">
      <tbody>
      <tr style="vertical-align: top;" valign="top">
      <td style="word-break: break-word; vertical-align: top;" valign="top">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#ffffff"><![endif]-->
      <div style="background-color:#3c68d0;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: #3c68d0;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:#3c68d0;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#3c68d0;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:#3c68d0"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:#3c68d0;width:650px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <div align="center" class="img-container center autowidth" style="padding-right: 45px;padding-left: 45px;">
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 45px;padding-left: 45px;" align="center"><![endif]-->
      <div style="font-size:1px;line-height:45px"></div><img align="center" alt="Alternate text" border="0" class="center autowidth" src="${emailLogo}" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: 0; width: 100%; max-width: 650px; display: block;" title="Alternate text" width="650"/>
      <div style="font-size:1px;line-height:45px"></div>
      <!--[if mso]></td></tr></table><![endif]-->
      </div>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:#ffffff;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#ffffff;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 5px; padding-left: 5px; padding-top:5px; padding-bottom:5px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 5px; padding-left: 5px;">
      <!--<![endif]-->
      <div></div>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:#ffffff;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#ffffff;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 4px solid #6F8BCD; border-left: 4px solid #6F8BCD; border-bottom: 0px solid #6F8BCD; border-right: 4px solid #6F8BCD;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:55px; padding-bottom:60px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 642px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:4px solid #6F8BCD; border-left:4px solid #6F8BCD; border-bottom:0px solid #6F8BCD; border-right:4px solid #6F8BCD; padding-top:55px; padding-bottom:60px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]-->
      <div style="color:#0049ff;font-family:Poppins, Arial, Helvetica, sans-serif;line-height:1.2;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;">
      <div style="line-height: 1.2; font-size: 12px; color: #0049ff; font-family: Poppins, Arial, Helvetica, sans-serif; mso-line-height-alt: 14px;">
      <p style="font-size: 14px; line-height: 1.2; word-break: break-word; text-align: center; mso-line-height-alt: 17px; margin: 0;"><strong><span style="font-size: 30px;">Olá ${request.body.customer_name},</span></strong></p>
      </div>
      </div>
      <!--[if mso]></td></tr></table><![endif]-->
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 50px; padding-left: 50px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]-->
      <div style="color:#575f79;font-family:Poppins, Arial, Helvetica, sans-serif;line-height:1.2;padding-top:10px;padding-right:50px;padding-bottom:10px;padding-left:50px;">
      <div style="line-height: 1.2; font-size: 12px; color: #575f79; font-family: Poppins, Arial, Helvetica, sans-serif; mso-line-height-alt: 14px;">
      <p style="font-size: 28px; line-height: 1.2; word-break: break-word; text-align: center; mso-line-height-alt: 34px; margin: 0;"><span style="font-size: 28px;">Aqui está o QR Code referente ao seu pedido de ID ${request.body.order_number}. Por Favor, apresente-o na bilheteria</span></p>
      </div>
      </div>
      <!--[if mso]></td></tr></table><![endif]-->
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:transparent;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:transparent;width:650px; border-top: 0px solid transparent; border-left: 4px solid #6F8BCD; border-bottom: 4px solid #6F8BCD; border-right: 4px solid #6F8BCD;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:60px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 642px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:4px solid #6F8BCD; border-bottom:4px solid #6F8BCD; border-right:4px solid #6F8BCD; padding-top:0px; padding-bottom:60px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <div align="center" class="img-container center autowidth" style="padding-right: 0px;padding-left: 0px;">
      <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 0px;padding-left: 0px;" align="center"><![endif]--><img align="center" alt="Alternate text" border="0" class="center autowidth" src="${code_request}" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: 0; width: 100%; max-width: 300px; display: block;" title="Alternate text" width="300"/>
      <!--[if mso]></td></tr></table><![endif]-->
      </div>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <div style="background-color:#ffffff;">
      <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 650px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: #ffffff;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:#ffffff;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#ffffff;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:650px"><tr class="layout-full-width" style="background-color:#ffffff"><![endif]-->
      <!--[if (mso)|(IE)]><td align="center" width="650" style="background-color:#ffffff;width:650px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;"><![endif]-->
      <div class="col num12" style="min-width: 320px; max-width: 650px; display: table-cell; vertical-align: top; width: 650px;">
      <div style="width:100% !important;">
      <!--[if (!mso)&(!IE)]><!-->
      <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
      <!--<![endif]-->
      <div></div>
      <!--[if (!mso)&(!IE)]><!-->
      </div>
      <!--<![endif]-->
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
      </div>
      </div>
      </div>
      <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
      </td>
      </tr>
      </tbody>
      </table>
      <!--[if (IE)]></div><![endif]-->
      <p>Barcodes Generated by <a href="https://the-refinery.io">Cleveland Web Design company, The Refinery</a>.</p>
      </body>
      </html>`;
    }

    try
    {
      cors(request, response, () => 
      {
        var image = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${order_number}`;
        let email = {
          from: '"Guará Acqua Park" <noreply@guarapark.com>',
          to: customeremail,
          subject: 'Bilhete de ingresso',
          html: emailhtml
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
          }).catch((error) => {limitCol.set({limit: limitNumber, expected: add_amount});});
    }
    catch(error){limitCol.set({limit: limitNumber, expected: add_amount});}

    paymentCol.set(data_to_send)
      .then(() => {response.status(200).json("Operation successful"); return null;})
      .catch((error) => {response.status(500).json(error);});
  }
});

exports.app = functions.https.onRequest(app);
