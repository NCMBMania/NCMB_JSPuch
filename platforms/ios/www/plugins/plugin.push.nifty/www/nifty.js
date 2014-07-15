cordova.define("plugin.push.nifty.NiftyCloud", function(require, exports, module) { 
/**
 * Nifty PushNotification API
*/ 

var NCMB = function(){};

NCMB.prototype.setDeviceToken = function (applicationKey,clientKey, senderId)
{
    cordova.exec(null, null, "NiftyPushNotification", "setDeviceToken", [applicationKey, clientKey, senderId]);
};

NCMB.prototype.success = function (msg)
{
    alert(msg);
};

NCMB.prototype.fail = function (msg)
{
    alert(msg);
};

NCMB.prototype.setHandler = function (callback)
{
    
    window.monaca.cloud = window.monaca.cloud || {};
    window.monaca.cloud.Push = window.monaca.cloud.Push || {};
        
    if (typeof callback === "function") {
        window.monaca.cloud.Push.callback = callback;
    }
};

module.exports = new NCMB();

});
