'use strict';

const React = require('react/addons');
const CoderCard = require('./coder-card');
const Cortex = require('cortexjs');

const CoderList = React.createClass({

  mixins: [React.addons.PureRenderMixin],

  propTypes: {
    users: React.PropTypes.object
  },

  getDefaultProps() {
    return {"users": new Cortex([])};
  },

  render() {
    return (
      <div>
      {this.props.users.map((user) => {
        return <CoderCard key={user.val().login} user={user} />
      })}
      </div>
    );
  }

});

module.exports = CoderList;
