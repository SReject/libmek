return {
    utilities = {
        class = require('common.class'),
        utilities = require('common.utilities')
    },
    classes = {
        Peripheral = require('classes.peripheral'),
        Multiblock = require('classes.multiblock'),
        FissionReactor = require('classes.fission-reactor'),
        FissionReactorPort = require('classes.fission-reactor-port'),
        InductionMatrix = require('classes.induction-matrix'),
        InductionMatrixPort = require('classes.induction-matrix-port'),
        IndustrialTurbine = require('classes.industrial-turbine'),
        SupercriticalPhaseShifter = require('classes.supercritical-phase-shifter'),
        SupercriticalPhaseShifterPort = require('classes.supercritical-phase-shifter-port'),
        ThermalEvaporationPlant = require('classes.thermal-evaporation-plant'),
        ThermoelectricBoiler = require('classes.thermoelectric-boiler'),
        ThermoelectricBoilerValve = require('classes.thermoelectric-boiler-valve'),
    },
    mixins = {
        tank = require('mixins.tank'),
        energyBuffer = require('mixins.energy-buffer')
    }
};