local classes = require('classes.generated.index');

-- include/overwrite entries as needed
classes.Peripheral = require('internal.peripheral');
classes.Multiblock = require('internal.multiblock');

return classes;