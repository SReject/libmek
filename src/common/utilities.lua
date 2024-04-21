return {
    copyArray = function (subject)
        local result = {};
        for k,v in pairs(subject) do
            result[k] = v;
        end
        return result;
    end
};