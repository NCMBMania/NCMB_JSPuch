//
// NiftyPushActivity.java
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//
//

package plugin.push.nifty;

import mobi.monaca.framework.MonacaApplication;
import mobi.monaca.framework.MonacaNotifActivity;
import mobi.monaca.framework.MonacaSScreenActivity;
import mobi.monaca.utils.gcm.GCMPushDataset;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.nifty.cloud.mb.NCMBPush;

public class NiftyPushActivity extends Activity
{
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		// handle richURL
		NCMBPush.richPushHandler(this, getIntent());

		JSONObject jsonData = null;
		try {
			jsonData = new JSONObject(getIntent().getExtras().getString("com.nifty.Data"));

		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        
		// handle receivedPush
		GCMPushDataset pushData;
		if(jsonData == null) {
			pushData = new GCMPushDataset("0", "");
		}
		else {
			pushData = new GCMPushDataset("0", jsonData.toString());			
		}

		
		MonacaApplication app = (MonacaApplication)getApplication();
		if (app.getPages().size() == 0) {
			Intent i = new Intent(this, MonacaSScreenActivity.class);
			i.putExtra(GCMPushDataset.KEY, pushData);
			startActivity(i);
		}
		else {
			Intent i = new Intent(MonacaNotifActivity.ACTION_RECEIVED_PUSH);
			i.putExtra(GCMPushDataset.KEY, pushData);
			sendBroadcast(i);
		}
        
		this.finish();        
	}
}

