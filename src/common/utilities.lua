return {
    copyArray = function (subject)
        local result = {};
        for k,v in pairs(subject) do
            result[k] = v;
        end
        return result;
    end,

    ---Converts a machine's port mode to an enum value
    ---@param mode LibmekMachinePortDualState|boolean
    ---@return LibmekMachinePortDualState
    portModeToEnum = function (mode)
        if (mode == true or mode == 'OUTPUT') then
            return 'OUTPUT';
        end
        return 'INPUT';
    end,

    ---Converts a machine's port mode to a boolean value
    ---@param mode LibmekMachinePortDualState|boolean
    ---@return boolean
    portModeFromEnum = function (mode)
        if (mode == true or mode == 'OUTPUT') then
            return true;
        end
        return false
    end

};