'use strict';

exports.setup = function(parsoidConfig) {
    parsoidConfig.setMwApi({
        uri: 'http://localhost/api.php'
    });
    parsoidConfig.serverPort = 8142;
    parsoidConfig.useSelser = true;
};
