package com.android.settings.development;

import android.content.Context;
import android.os.SystemProperties;
import androidx.annotation.VisibleForTesting;
import androidx.preference.Preference;
import androidx.preference.SwitchPreference;

import com.android.settingslib.development.DeveloperOptionsPreferenceController;

public class EinkFilterPreferenceController extends DeveloperOptionsPreferenceController
        implements Preference.OnPreferenceChangeListener {

    private static final String EINK_FILTER_KEY = "eink_filter_enable";
    
    // Updated to the persistent property defined in your SEPolicy
    @VisibleForTesting
    static final String EINK_PERSIST_PROPERTY = "persist.sys.sf.eink_filter";

    public EinkFilterPreferenceController(Context context) {
        super(context);
    }

    @Override
    public String getPreferenceKey() {
        return EINK_FILTER_KEY;
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        final boolean isEnabled = (Boolean) newValue;
        // The system_app domain now has set_prop(system_app, eink_filter_prop)
        SystemProperties.set(EINK_PERSIST_PROPERTY, isEnabled ? "1" : "0");
        return true;
    }

    @Override
    public void updateState(Preference preference) {
        // Read the persistent state on UI load
        final boolean isEnabled = SystemProperties.getBoolean(EINK_PERSIST_PROPERTY, false);
        ((SwitchPreference) preference).setChecked(isEnabled);
    }

    @Override
    protected void onDeveloperOptionsSwitchDisabled() {
        super.onDeveloperOptionsSwitchDisabled();
        // Reset to default (disabled) if Developer Options are turned off entirely
        SystemProperties.set(EINK_PERSIST_PROPERTY, "0");
        if (mPreference != null) {
            ((SwitchPreference) mPreference).setChecked(false);
        }
    }
}
