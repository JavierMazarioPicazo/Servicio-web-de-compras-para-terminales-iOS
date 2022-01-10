'use strict';

module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.createTable(
            'Products',
            {
                id: {
                    type: Sequelize.INTEGER,
                    allowNull: false,
                    primaryKey: true,
                    autoIncrement: true,
                    unique: true
                },
                reference: {
                    type: Sequelize.STRING,
                    validate: { notEmpty: { msg: "Reference must not be empty" } }
                },
                color: {
                    type: Sequelize.STRING,
                    validate: { notEmpty: { msg: "Color must not be empty" } }
                },
                category: {
                    type: Sequelize.STRING,
                    validate: { notEmpty: { msg: "Category must not be empty" } }
                },
                price: {
                    type: Sequelize.DOUBLE,
                    validate: { notEmpty: { msg: "Price must not be empty" } }
                },
                composition: {
                    type: Sequelize.STRING,
                    validate: { notEmpty: { msg: "Composition must not be empty" } }
                },
                createdAt: {
                    type: Sequelize.DATE,
                    allowNull: false
                },
                updatedAt: {
                    type: Sequelize.DATE,
                    allowNull: false
                }
            },
            {
                sync: { force: true }
            }
        );
    },

    down: async (queryInterface, Sequelize) => {
        await queryInterface.dropTable('Products');
    }
};