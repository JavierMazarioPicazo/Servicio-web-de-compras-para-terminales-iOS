const express = require('express');
const router = express.Router();
const braintree = require('braintree');
const logger = require('debug');


router.post('/', (req, res, next) => {
  const gateway = new braintree.BraintreeGateway({
    environment: braintree.Environment.Sandbox,
    // Use your own credentials from the sandbox Control Panel here
    merchantId: '...',
    publicKey: '...',
    privateKey: '...'
  });

const {amount, payment_method_nonce: paymentMethodNonce} = req.body;


  const newTransaction = gateway.transaction.sale({
    amount,
    paymentMethodNonce,
    options: {
      // This option requests the funds from the transaction
      // once it has been authorized successfully
      submitForSettlement: true
    }

  }, (error, result) => {
      if (result) {
        res.send(result);
        console.log(req.body);
        console.log(result);
      } else {
        res.status(500).send(error);
        console.log(req.body);
      }
  });
});

module.exports = router;