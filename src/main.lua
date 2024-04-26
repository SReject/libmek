return {
    utilities = {
        class = require('common.class'),
        utilities = require('common.utilities')
    },
    classes = {
        Peripheral = require('classes.peripheral'),
        Multiblock = require('classes.multiblock'),
        FissionReactor = require('classes.fission-reactor'),
        InductionMatrix = require('classes.induction-matrix'),
        IndustrialTurbine = require('classes.industrial-turbine'),
        ThermoelectricBoiler = require('classes.thermoelectric-boiler'),
        ThermoelectricBoilerValve = require('classes.thermoelectric-boiler-valve'),
    },
    mixins = {
        tank = require('mixins.tank')
    }
};