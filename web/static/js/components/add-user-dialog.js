'use strict';

const React  = require('react/addons');
const FlatButton = require('material-ui/lib/flat-button');
const Dialog = require('material-ui/lib/dialog');
const TextField = require('material-ui/lib/text-field');
const Loader    = require('halogen/RingLoader');

const GithubUsers = require('../datastore/github_users');
const http = require('../http');

const AddUserDialog = React.createClass({
  getInitialState() {
    return {processing: false};
  },

  mixins: [React.addons.PureRenderMixin],

  render() {
    let actions = [
      <FlatButton disabled={this.state.processing} onTouchTap={this._cancelDialog} key="cancel" >Cancel</FlatButton>,
      <FlatButton disabled={this.state.processing} onTouchTap={this._addUser} key="submit" ref="submit" >Submit</FlatButton>
    ];

    return(
      <Dialog ref="dialog" title="Add A Github User to Watchlist" actions={actions} actionFocus="submit" modal={true}>
        <TextField
          ref="textfield"
          hintText="Github Login Name"
          floatingLabelText="Who do you want to watch?"
          disabled={this.state.processing}
          errorText={this.state.error}
          onEnterKeyDown={this._addUser} />
        <Loader ref="loader" color="#F60" size="12" loading={this.state.processing} />
      </Dialog>
    )
  },

  /* proxy to Dialog.show */
  show() { this.refs.dialog.show() },

  _addUser() {
    let text = this.refs.textfield;
    let v = text.getValue().trim();

    if(v == "") {
      /* text.setErrorText("Username can't be empty!"); // Can't do this since errorText prop was set in JSX */
      this.setState({processing: false, error: "Username can't be empty!"});
    } else {
      http.post("/api/github_users")
        .send({login: v})
        .end((err, resp) => {
          let nextState = {processing: false};

          if(err) {
            let msg = resp.body.message || resp.text;
            let r_i = msg.indexOf("\n");
            if(r_i > 0) { msg = msg.slice(0, r_i - 1) }
            nextState["error"] = msg;
          } else {
            if(resp.body.data) { GithubUsers.push(resp.body.data) }
            this.refs.dialog.dismiss();
          }
          this.setState(nextState);
        });

      this.setState({processing: true, error: null});
    }
  },

  _cancelDialog() {
    this.setState({processing: false, error: null});
    this.refs.dialog.dismiss();
  }
});

module.exports = AddUserDialog;
