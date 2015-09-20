module.exports = function injectTapEventPlugin () {
  var React = require("react/addons");
  React.initializeTouchEvents(true);

  require('react/lib/EventPluginHub').injection.injectEventPluginsByName({
    "ResponderEventPlugin": require('./ResponderEventPlugin.js'),
    "TapEventPlugin":       require('./TapEventPlugin.js')
  });
};
