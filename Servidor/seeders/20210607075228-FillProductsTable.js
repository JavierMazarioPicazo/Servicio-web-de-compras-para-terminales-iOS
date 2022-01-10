'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {

    await queryInterface.bulkInsert('Products', [
      {
        reference: "APS21234",
        color: "GRANATE",
        category: "SUÉTER",
        price: 39.95,
        composition: "60% ALGODÓN 40% POLIÉSTER",
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        reference: "APW21006",
        color: "DENIM",
        category: "SUÉTER",
        price: 39.95,
        composition: "50% ALGODÓN 50% ACRÍLICO",
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        reference: "APW21003",
        color: "GRANATE",
        category: "SUÉTER",
        price: 39.95,
        composition: "45% ALGODÓN 45% ACRÍLICO 10% NAILÓN",
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        reference: "APS21008",
        color: "VERDE",
        category: "POLO",
        price: 49.95,
        composition: "100% ALGODÓN",
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        reference: "APW21120",
        color: "TOSTADO",
        category: "CAMISA",
        price: 49.95,
        composition: "100% ALGODÓN",
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        reference: "APW20012",
        color: "MARINO",
        category: "SUÉTER",
        price: 49.95,
        composition: "100% MERINO LAVABLE",
        createdAt: new Date(),
        updatedAt: new Date()
      },
    ]);
  },

  down: async (queryInterface, Sequelize) => {

    await queryInterface.bulkDelete('Products', null, {});
  }
};
