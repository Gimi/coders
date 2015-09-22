'use strict';

const React = require('react');

const AppBar       = require('material-ui/lib/app-bar');
const ThemeManager = require('material-ui/lib/styles/theme-manager')();

const AddUserButton = require('./add-user-button');
const CoderList     = require('./coder-list');
const AddUserDialog = require('./add-user-dialog');

const Cortex = require('cortexjs');

const Main = React.createClass({

  propTypes: {
    users: React.PropTypes.object,
  },

  getDefaultProps() {
    return {users: new Cortex([])};
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
        <AppBar title="Coder Fun Facts!"  />
        <AddUserButton onClick={this.handleAddUser} />
        <CoderList users={this.props.users} />
        <AddUserDialog ref="add_user_dialog" />
      </div>
    );
  },

  handleAddUser() {
    this.refs.add_user_dialog.show();
  }

});

module.exports = Main;
