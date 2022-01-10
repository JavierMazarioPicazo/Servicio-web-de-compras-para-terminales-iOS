const express = require('express');
const router = express.Router();

const tokenApi = require('../api/token');

const productApi = require('../api/product');
const userApi = require('../api/user');

//-----------------------------------------------------------

// Debug trace.
router.all('*', function(req, res, next) {

    console.log("=== API ===>", req.url);
    next();
});


//-----------------------------------------------------------

// Autoload the objects associated to the given route parameter.
router.param('userId',       userApi.load);
router.param('productId',       productApi.load);

router.param('productId_woi',   productApi.load_woi);

//-----------------------------------------------------------

// Routes for the users resource.

router.get('/users',
    userApi.index);

router.get('/users/:userId(\\d+)',
    userApi.show);

router.get('/users/tokenOwner',
    userApi.loadToken,
    userApi.show);

//-----------------------------------------------------------

// Routes for the products resource.

router.get('/products.:format?',
    productApi.index);

router.get('/products/:productId(\\d+).:format?',
    productApi.show);


// If I am here, then the requested route is not defined.
router.all('*', function(req, res, next) {

    var err = new Error('Ruta API no encontrada');
    err.status = 404;
    next(err);
});

//-----------------------------------------------------------

// Error
router.use(function(err, req, res, next) {

    var emsg = err.message || "Error Interno";

    console.log(emsg);

    res.status(err.status || 500)
        .send({error: emsg})
        .end();
});

//-----------------------------------------------------------

module.exports = router;