cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/plugin.push.nifty/www/nifty.js",
        "id": "plugin.push.nifty.NiftyCloud",
        "clobbers": [
            "NCMB.monaca"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "plugin.push.nifty": "1.0.0"
}
// BOTTOM OF METADATA
});