// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// ------------------- My App -----------------------
//
// get constant references to React and Material-UI
// components, as we will not be modifying these

const React = require('react/addons');

const muiCard = require('material-ui/lib/card/index');
const Card = muiCard.Card;
const CardHeader = muiCard.CardHeader;
const CardText = muiCard.CardText;
const CardActions = muiCard.CardActions;
const FlatButton = require('material-ui/lib/flat-button');
const Avatar = require('material-ui/lib/avatar');

const AppBar = require('material-ui/lib/app-bar');

const FloatingActionButton = require('material-ui/lib/floating-action-button');

const ThemeManager = require('material-ui/lib/styles/theme-manager')();

const CoderCard = React.createClass({
  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  getChildContext() {
    return {
      muiTheme: ThemeManager.getCurrentTheme()
    };
  },

  render() {
    return (
      <Card initiallyExpanded={true}>
        <CardHeader title="DHH" subtitle="David Heinemeier Hansson" avatar={<Avatar style={{color:'red'}} src="https://avatars.githubusercontent.com/u/2741?v=3" />} showExpandableButton={true} />
        <CardText expandable={true}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Donec mattis pretium massa. Aliquam erat volutpat. Nulla facilisi.
          Donec vulputate interdum sollicitudin. Nunc lacinia auctor quam sed pellentesque.
          Aliquam dui mauris, mattis quis lacus id, pellentesque lobortis odio.
        </CardText>
        <CardActions expandable={true}>
          <FlatButton label="Action1"/>
          <FlatButton label="Action2"/>
        </CardActions>
        <CardText expandable={true}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Donec mattis pretium massa. Aliquam erat volutpat. Nulla facilisi.
          Donec vulputate interdum sollicitudin. Nunc lacinia auctor quam sed pellentesque.
          Aliquam dui mauris, mattis quis lacus id, pellentesque lobortis odio.
        </CardText>
      </Card>
    );
  }
});

const CodersApp = React.createClass({

  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  getChildContext() {
    return {
      muiTheme: ThemeManager.getCurrentTheme()
    };
  },

  render() {
    return (
      <div>
        <AppBar title="Coder Fun Facts!" iconElementRight={<FloatingActionButton iconClassName="muidocs-icon-content-add" mini={true} />} />
        <CoderCard />
        <CoderCard />
        <CoderCard />
      </div>
    );
  }

});

React.render(<CodersApp />, document.getElementById('app-dom'));
