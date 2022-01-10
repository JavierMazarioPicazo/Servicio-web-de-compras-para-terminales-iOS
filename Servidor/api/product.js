const { models } = require('../models');
const Sequelize = require('sequelize');

const js2xmlparser = require("js2xmlparser");

const addPagenoToUrl = require('../helpers/paginate').addPagenoToUrl;


//-----------------------------------------------------------


// Autoload el product asociado a :productId.
// Includes attachment.
exports.load = async (req, res, next, productId) => {

    try {
        const product = await models.Product.findByPk(productId, {
            attributes: { exclude: ['createdAt', 'updatedAt', 'deletedAt'] },
            include: [
                {
                    model: models.Attachment,
                    as: 'attachment',
                    attributes: ['filename', 'mime', 'url']
                }
            ]
        });

        if (product) {
            req.load = { ...req.load, product };
            next();
        } else {
            throw new Error('There is no product with id=' + productId);
        }
    } catch (error) {
        next(error);
    }
};


// Autoload el product asociado a :productId
// Without includes.
exports.load_woi = async (req, res, next, productId) => {

    try {
        const product = await models.Product.findByPk(productId, {
            attributes: { exclude: ['createdAt', 'updatedAt', 'deletedAt'] }
        });
        if (product) {
            req.load = { ...req.load, product };
            next();
        } else {
            throw new Error('There is no product with id=' + productId);
        }
    } catch (error) {
        next(error);
    }
};

//-----------------------------------------------------------

// GET /api/products
exports.index = async (req, res, next) => {

    let countOptions = {
        where: {},
        include: []
    };

    // Search products which reference field contains the value given in the query.
    const search = req.query.search || '';
    if (search) {
        const search_like = "%" + search.replace(/ +/g, "%") + "%";

        countOptions.where.reference = { [Sequelize.Op.like]: search_like };
    }


    // Pagination:

    const items_per_page = 10;

    // The page to show is given in the query
    const pageno = parseInt(req.query.pageno) || 1;

    let totalItems = 0;

    try {
        const count = await models.Product.count(countOptions);

        totalItems = count;

        const findOptions = {
            ...countOptions,
            attributes: { exclude: ['createdAt', 'updatedAt', 'deletedAt'] },
            offset: items_per_page * (pageno - 1),
            limit: items_per_page
        };

        findOptions.include.push({
            model: models.Attachment,
            as: 'attachment',
            attributes: ['filename', 'mime', 'url']
        });

        let products = await models.Product.findAll(findOptions);

        products = products.map(product => ({
            id: product.id,
            productId: String(product.id),
            reference: product.reference,
            color: product.color,
            category: product.category,
            price: product.price,
            composition: product.composition,
            isAvailable: false,
            imageInfo: product.attachment && product.attachment.get({ plain: true }),
        }));

        let nextUrl = "";
        const totalPages = Math.ceil(totalItems / items_per_page);
        if (pageno < totalPages) {
            let nextPage = pageno + 1;

            // In production (Heroku) I will use https.
            let protocol = process.env.NODE_ENV === 'production' ? "https" : req.protocol;
            nextUrl = addPagenoToUrl(`${protocol}://${req.headers["host"]}${req.baseUrl}${req.url}`, nextPage)
        }

        const format = (req.params.format || 'json').toLowerCase();

        switch (format) {
            case 'json':

                res.json(products);
                break;

            case 'xml':

                var options = {
                    typeHandlers: {
                        "[object Null]": function (value) {
                            return js2xmlparser.Absent.instance;
                        }
                    }
                };

                res.set({
                    'Content-Type': 'application/xml'
                }).send(
                    js2xmlparser.parse("page", {
                        products,
                        pageno,
                        nextUrl
                    }, options)
                );
                break;

            default:
                console.log('No supported format \".' + format + '\".');
                res.sendStatus(406);
        }

    } catch (error) {
        next(error);
    }
};

//-----------------------------------------------------------


// GET /products/:productId
exports.show = (req, res, next) => {

    const { product, token } = req.load;

    const format = (req.params.format || 'json').toLowerCase();

    const data = {
        id: product.id,
        productId: product.productId,
        reference: product.reference,
        color: product.color,
        category: product.category,
        price: product.price,
        composition: product.composition,
        isAvailable: false,
        attachment: product.attachment && product.attachment.get({ plain: true }),
    };

    switch (format) {
        case 'json':

            res.json(data);
            break;

        case 'xml':

            var options = {
                typeHandlers: {
                    "[object Null]": function (value) {
                        return js2xmlparser.Absent.instance;
                    }
                }
            };

            res.set({
                'Content-Type': 'application/xml'
            }).send(
                js2xmlparser.parse("product", data, options)
            );
            break;

        default:
            console.log('No supported format \".' + format + '\".');
            res.sendStatus(406);
    }
};
