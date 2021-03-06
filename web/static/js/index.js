'use strict';

// Import dependencies
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// ------------------- My App -----------------------

// Needed for onTouchTap
// Can go away when react 1.0 release
require("react-tap-event-plugin")();

// get constant references to React and Material-UI
// components, as we will not be modifying these
const React = require('react');
const App   = require('./components/app');

React.render(<App />, document.getElementById("app-dom"));
