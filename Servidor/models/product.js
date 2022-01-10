'use strict';

const {Model} = require('sequelize');

// Definition of the Quiz model:
module.exports = (sequelize, DataTypes) => {
    class Product extends Model {
    }

    Product.init(
        {
          reference: {
              type: DataTypes.STRING
          },
          color: {
              type: DataTypes.STRING
          },
          category: {
              type: DataTypes.STRING
          },
          price: {
              type: DataTypes.DOUBLE
          },
          composition: {
              type: DataTypes.STRING
          }
        }, 
        { sequelize }
      );

    return Product;
};
