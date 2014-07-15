//
//  NiftyPushNotification.java
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//
//

package plugin.push.nifty;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;

import com.nifty.cloud.mb.NCMB;
import com.nifty.cloud.mb.NCMBException;
import com.nifty.cloud.mb.NCMBInstallation;
import com.nifty.cloud.mb.NCMBPush;
import com.nifty.cloud.mb.NCMBQuery;
import com.nifty.cloud.mb.RegistrationCallback;

public class NiftyPushNotification extends CordovaPlugin {
    public static final String TAG = "NiftyPushNotification";

    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArry of arguments for the plugin.
     * @param callbackContext   The callback id used when calling back into JavaScript.
     * @return                  True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if (action.equals("setDeviceToken")) {
            
            String APP_KEY = args.optString(0);
            String CLIENT_KEY = args.optString(1);
            String SENDER_ID = args.optString(2);

            Context context = cordova.getActivity().getApplicationContext();
            
            NCMB.initialize(context, APP_KEY, CLIENT_KEY);

            final NCMBInstallation installation = NCMBInstallation.getCurrentInstallation();
            installation.getRegistrationIdInBackground(SENDER_ID, new RegistrationCallback() {
                @Override
                public void done(NCMBException e) {             
                    if (e == null) {
                        try {
                            installation.save();
                        } catch (NCMBException le) {
                            if (NCMBException.DUPLICATE_VALUE.equals(le.getCode())) {
                                NCMBQuery<NCMBInstallation> query = NCMBInstallation.getQuery();
                                query.whereEqualTo("deviceToken", installation.get("deviceToken"));
                                try {
                                    NCMBInstallation prevInstallation = query.getFirst();
                                    String objectId = prevInstallation.getObjectId();
                                    installation.setObjectId(objectId);
                                    installation.save();
                                } catch(NCMBException le2) {
                                    le2.printStackTrace();
                                }
                            } else {
                                le.printStackTrace();
                            }                           
                        }
                    } else {
                        e.printStackTrace();
                    }
                }
            });

            NCMBPush.setDefaultPushCallback(context, NiftyPushActivity.class);            
        }
        else {
            return false;
        }
        return true;
    }

}


