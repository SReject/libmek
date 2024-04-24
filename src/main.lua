return {
    utilities = {
        class = require('common.class'),
        utilities = require('common.utilities')
    },
    classes = {
        Peripheral = require('classes.peripheral'),
        Multiblock = require('classes.multiblock'),
        ThermoelectricBoiler = require('classes.thermoelectric-boiler'),
        IndustrialTurbine = require('classes.industrial-turbine'),
        FissionReactor = require('classes.fission-reactor')
    },
    mixins = {
        tank = require('mixins.tank')
    }
};