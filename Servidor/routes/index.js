var express = require('express');
var router = express.Router();

const multer = require('multer');
const upload = multer({
    dest: './uploads/',
    limits: {fileSize: 20 * 1024 * 1024}});

const productController = require('../controllers/product');
const userController = require('../controllers/user');
const sessionController = require('../controllers/session');

//-----------------------------------------------------------

// Routes for the resource /login

// autologout
router.all('*',sessionController.checkLoginExpires);

// login form
router.get('/login', sessionController.new);

// create login session
router.post('/login',
    sessionController.create,
    sessionController.createLoginExpires);

// logout - close login session
router.delete('/login', sessionController.destroy);

//-----------------------------------------------------------

// History: Restoration routes.

// Redirection to the saved restoration route.
function redirectBack(req, res, next) {
    const url = req.session.backURL || "/";
    delete req.session.backURL;
    res.redirect(url);
}

router.get('/goback', redirectBack);

// Save the route that will be the current restoration route.
function saveBack(req, res, next) {
    req.session.backURL = req.url;
    next();
}
router.get(
    [
        '/',
        '/users',
        '/users/:id(\\d+)/products',
        '/products'
    ],
    saveBack);

//-----------------------------------------------------------

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index');
});


// Autoload for routes using :productId
router.param('productId', productController.load);
router.param('userId', userController.load);


// Routes for the resource /users
router.get('/users',
    sessionController.loginRequired,
    userController.index);
router.get('/users/:userId(\\d+)',
    sessionController.loginRequired,
    userController.show);

if (!!process.env.QUIZ_OPEN_REGISTER) {
    router.get('/users/new',
        userController.new);
    router.post('/users',
        userController.create);
} else {
    router.get('/users/new',
        sessionController.loginRequired,
        sessionController.adminRequired,
        userController.new);
    router.post('/users',
        sessionController.loginRequired,
        sessionController.adminRequired,
        userController.create);
}

router.get('/users/:userId(\\d+)/edit',
    sessionController.loginRequired,
    sessionController.adminRequired,
    userController.edit);
router.put('/users/:userId(\\d+)',
    sessionController.loginRequired,
    sessionController.adminRequired,
    userController.update);
router.delete('/users/:userId(\\d+)',
    sessionController.loginRequired,
    sessionController.adminRequired,
    userController.destroy);


router.put('/users/:userId(\\d+)/token',
    sessionController.loginRequired,
    sessionController.adminOrMyselfRequired,
    userController.createToken);   // generar un nuevo token


// Routes for the resource /products
router.get('/products',
    productController.index);
router.get('/products/:productId(\\d+)',
    sessionController.loginRequired,
    productController.adminRequired,
    productController.show);
router.get('/products/new',
    sessionController.loginRequired,
    productController.new);
router.post('/products',
    sessionController.loginRequired,
    upload.single('image'),
    productController.create);
router.get('/products/:productId(\\d+)/edit',
    sessionController.loginRequired,
    productController.adminRequired,
    productController.edit);
router.put('/products/:productId(\\d+)',
    sessionController.loginRequired,
    productController.adminRequired,
    upload.single('image'),
    productController.update);
router.delete('/products/:productId(\\d+)',
    sessionController.loginRequired,
    productController.adminRequired,
    productController.destroy);


module.exports = router;
