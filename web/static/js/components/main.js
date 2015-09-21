'use strict';

const React = require('react');

const AppBar = require('material-ui/lib/app-bar');
const FloatingActionButton = require('material-ui/lib/floating-action-button');
const ThemeManager = require('material-ui/lib/styles/theme-manager')();

const CoderList = require('./coder-list');
//const im     = require('immutable');
const Cortex = require('cortexjs');

const Main = React.createClass({

  /*
  propTypes: {
    users: React.PropTypes.array
  },
  */

  getDefaultProps() {
    return {"users": []};
  },

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
        <CoderList users={this.props.users} />
      </div>
    );
  }

});

module.exports = Main;
