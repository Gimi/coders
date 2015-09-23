'use strict';

const React = require('react');

const AppBar       = require('material-ui/lib/app-bar');
const Paper        = require('material-ui/lib/paper');
const ThemeManager = require('material-ui/lib/styles/theme-manager')();

const AddUserButton = require('./add-user-button');
const CoderList     = require('./coder-list');
const AddUserDialog = require('./add-user-dialog');

let AppStore = require('../datastore/app_store');

const App = React.createClass({

  getInitialState() {
    return AppStore.getState();
  },

  childContextTypes: {
    muiTheme: React.PropTypes.object,
    users: React.PropTypes.object
  },

  getChildContext() {
    return {
      muiTheme: ThemeManager.getCurrentTheme(),
      users: this.state.users
    };
  },

  render() {
    return (
      <Paper>
        <AppBar title="Coder Fun Facts!"  />
        <AddUserButton onClick={this.handleAddUser} />
        <CoderList users={this.state.users} />
        <AddUserDialog ref="add_user_dialog" />
      </Paper>
    );
  },

  componentWillMount() {
    this.state.onUpdate((updates) => {
      this.setState(updates);
    });

    AppStore.getUsers();
  },

  handleAddUser() {
    this.refs.add_user_dialog.show();
  }

});

module.exports = App;
