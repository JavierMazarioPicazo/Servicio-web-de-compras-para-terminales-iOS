const Sequelize = require("sequelize");
const Op = Sequelize.Op;
const { models } = require("../models");
const attHelper = require("../helpers/attachments");

const moment = require('moment');

const paginate = require('../helpers/paginate').paginate;


// Autoload el product asociado a :productId
exports.load = async (req, res, next, productId) => {

    const options = {
        include: [
            { model: models.Attachment, as: 'attachment' },
        ]
    };

    try {
        const product = await models.Product.findByPk(productId, options);
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


// MW that allows actions only if the user is admin.
exports.adminRequired = (req, res, next) => {

    const isAdmin = !!req.loginUser.isAdmin;

    if (isAdmin) {
        next();
    } else {
        console.log('Prohibited operation: The logged in user is not the author of the quiz, nor an administrator.');
        res.send(403);
    }
};


// GET /products
exports.index = async (req, res, next) => {

    let countOptions = {
        where: {},
        include: []
    };
    let findOptions = {
        where: {},
        include: []
    };



    let title = "Products";

    // Search:
    const search = req.query.search || '';
    if (search) {
        const search_like = "%" + search.replace(/ +/g, "%") + "%";

        countOptions.where.reference = { [Op.like]: search_like };
        findOptions.where.reference = { [Op.like]: search_like };
    }

    try {
        const count = await models.Product.count(countOptions);

        // Pagination:

        const items_per_page = 10;

        // The page to show is given in the query
        const pageno = parseInt(req.query.pageno) || 1;

        // Create a String with the HTMl used to render the pagination buttons.
        // This String is added to a local variable of res, which is used into the application layout file.
        res.locals.paginate_control = paginate(count, items_per_page, pageno, req.url);


        findOptions.offset = items_per_page * (pageno - 1);
        findOptions.limit = items_per_page;

        findOptions.include.push({
            model: models.Attachment,
            as: 'attachment'
        });

        const products = await models.Product.findAll(findOptions);

        res.render('products/index.ejs', {
            products,
            search,
            title,
            attHelper
        });
    } catch (error) {
        next(error);
    }
};


// GET /products/:productId
exports.show = async (req, res, next) => {

    const { product } = req.load;

    try {

        res.render('products/show', {
            product,
            attHelper
        });
    } catch (error) {
        next(error);
    }
};


// GET /products/new
exports.new = (req, res, next) => {

    const product = {
        reference: "",
        color: "",
        category: "",
        price: "",
        composition: ""

    };

    res.render('products/new', { product });
};

// POST /products/create
exports.create = async (req, res, next) => {

    const {reference, color, category, price, composition, isAvailable } = req.body;

    let product = models.Product.build({ reference, color, category, price, composition, isAvailable });

    try {
        // Saves the fields  into the DDBB
        product = await product.save({ fields: [ "reference", "color", "category", "price", "composition"] });
        req.flash('success', 'Product created successfully.');

        try {
            if (!req.file) {
                req.flash('info', 'Product without attachment.');
                return;
            }

            // Create the product attachment
            await createProductAttachment(req, product);

        } catch (error) {
            req.flash('error', 'Failed to create attachment: ' + error.message);
        } finally {
            res.redirect('/products/' + product.id);
        }
    } catch (error) {
        if (error instanceof Sequelize.ValidationError) {
            req.flash('error', 'There are errors in the form:');
            error.errors.forEach(({ message }) => req.flash('error', message));
            res.render('products/new', { product });
        } else {
            req.flash('error', 'Error creating a new Product: ' + error.message);
            next(error)
        }
    } finally {
        // delete the file uploaded to ./uploads by multer.
        if (req.file) {
            attHelper.deleteLocalFile(req.file.path);
        }
    }
};

// Aux function to upload req.file to cloudinary, create an attachment with it, and
// associate it with the gien quiz.
// This function is called from the create an update middleware. DRY.
const createProductAttachment = async (req, product) => {

    // Save the attachment into Cloudinary
    const uploadResult = await attHelper.uploadResource(req);

    let attachment;
    try {
        // Create the new attachment into the data base.
        attachment = await models.Attachment.create({
            resource: uploadResult.resource,
            url: uploadResult.url,
            filename: req.file.originalname,
            mime: req.file.mimetype
        });
        await product.setAttachment(attachment);
        req.flash('success', 'Attachment saved successfully.');
    } catch (error) { // Ignoring validation errors
        req.flash('error', 'Failed linking attachment: ' + error.message);
        attHelper.deleteResource(uploadResult.resource);
        attachment && attachment.destroy();
    }
};


// GET /products/:productId/edit
exports.edit = (req, res, next) => {

    const { product } = req.load;

    res.render('products/edit', { product });
};


// PUT /products/:productId
exports.update = async (req, res, next) => {

    const { body } = req;
    const { product } = req.load;

    product.productId = body.productId;
    product.reference = body.reference;
    product.color = body.color;
    product.category = body.category;
    product.price = body.price;
    product.composition = body.composition;


    try {
        await product.save({ fields: ["productId", "reference", "color", "category", "price", "composition"] });
        req.flash('success',  'Product edited successfully.');

        try {
            if (req.body.keepAttachment) return; // Don't change the attachment.

            // The attachment can be changed if more than 1 minute has passed since the last change:
            if (product.attachment) {

                const now = moment();
                const lastEdition = moment(product.attachment.updatedAt);

                if (lastEdition.add(1, "m").isAfter(now)) {
                    req.flash('error', 'Attached file can not be modified until 1 minute has passed.');
                    return
                }
            }

            // Delete old attachment.
            if (product.attachment) {
                attHelper.deleteResource(product.attachment.resource);
                await product.attachment.destroy();
                await product.setAttachment();
            }

            if (!req.file) {
                req.flash('info', 'Product without attachment.');
                return;
            }

            // Create the product attachment
            await createProductAttachment(req, product);

        } catch (error) {
            req.flash('error', 'Failed saving the new attachment: ' + error.message);
        } finally {
            res.redirect('/products/' + product.id);
        }
    } catch (error) {
        if (error instanceof Sequelize.ValidationError) {
            req.flash('error', 'There are errors in the form:');
            error.errors.forEach(({ message }) => req.flash('error', message));
            res.render('products/edit', { product });
        } else {
            req.flash('error', 'Error editing the Product: ' + error.message);
            next(error);
        }
    } finally {
        // delete the file uploaded to ./uploads by multer.
        if (req.file) {
            attHelper.deleteLocalFile(req.file.path);
        }
    }
};


// DELETE /products/:productId
exports.destroy = async (req, res, next) => {

    const attachment = req.load.product.attachment;

    // Delete the attachment
    if (attachment) {
        try {
            attHelper.deleteResource(attachment.resource);
        } catch (error) {
        }
    }

    try {
        await req.load.product.destroy();
        attachment && await attachment.destroy();
        req.flash('success', 'Product deleted successfully.');
        res.redirect('/goback');
    } catch (error) {
        req.flash('error', 'Error deleting the Product: ' + error.message);
        next(error);
    }
};