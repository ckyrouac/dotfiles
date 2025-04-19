'use strict';

import Gio from 'gi://Gio';
import GLib from 'gi://GLib';

import * as FileUtils from './fileUtils.js';

// import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
let Extension;
try {
    let extensionObj = await import('resource:///org/gnome/shell/extensions/extension.js');
    Extension = extensionObj.Extension;
} catch (e) {
    let extensionPrefsObj = await import('resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js');
    Extension = extensionPrefsObj.ExtensionPreferences;
}

export function find(iconName) {
    let iconPath = `${FileUtils.current_extension_path}/icons/${iconName}`;
    if (GLib.file_test(iconPath, GLib.FileTest.EXISTS)) {
        return Gio.icon_new_for_string(`${iconPath}`);
    }

    return Gio.ThemedIcon.new_from_names([iconName]);
    
}

export function findPath(iconName) {
    let iconPath = `${FileUtils.current_extension_path}/icons/${iconName}`;
    if (GLib.file_test(iconPath, GLib.FileTest.EXISTS)) {
        return iconPath;
    }

    return null;
}
