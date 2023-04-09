// Disable the privacy notice page.
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
// Prevent closing Firefox when closing the last tab.
user_pref("browser.tabs.closeWindowWithLastTab", false);
// Disable confirmation before quitting with Ctrl+Q.  Needed to allow Firefox
// to quit cleanly when container is shutted down.
user_pref("browser.warnOnQuitShortcut", false);
