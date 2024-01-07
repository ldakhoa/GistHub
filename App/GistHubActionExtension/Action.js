//
//  Action.js
//  GistHubActionExtension
//
//  Created by Khoa Le on 15/07/2023.
//

var Action = function() {};

Action.prototype = {
    run: function(arguments) {
        arguments.completionFunction({
            "url": document.URL
        })
    },
    finalize: function(arguments) {
        var openingUrl = arguments["deeplink"]
        if (openingUrl) {
            document.location.href = openingUrl
        }
    }
};
    
var ExtensionPreprocessingJS = new Action
