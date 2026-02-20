package com.capacitor.plugin.spmtraits;

import com.getcapacitor.Logger;

public class PluginWithTraits {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
