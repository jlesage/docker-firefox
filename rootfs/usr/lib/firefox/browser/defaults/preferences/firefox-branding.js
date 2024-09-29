// Default download directory.
pref("browser.download.dir", "/config/downloads");
pref("browser.download.folderList", 2);
// Disable the privacy notice page.
pref("toolkit.telemetry.reportingpolicy.firstRun", false);
// Disable some warning messages.
pref("security.sandbox.warn_unprivileged_namespaces", false);
// Prevent closing Firefox when closing the last tab.
pref("browser.tabs.closeWindowWithLastTab", false);
// Disable confirmation before quitting with Ctrl+Q.  Needed to allow Firefox
// to quit cleanly when container is shutted down.
pref("browser.warnOnQuitShortcut", false);
