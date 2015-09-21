'use strict';

const React = require('react');
const CoderCard = require('./coder-card');
const Cortex = require('cortexjs');
// const im     = require('immutable');
const CoderList = React.createClass({

  shouldComponentUpdate(nextProps, _) {
    return nextProps.users !== this.props.users;
  },

  /*
  propTypes: {
    users: React.PropTypes.object
  },
  */

  getDefaultProps() {
    return {"users": []};
  },

  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  render() {
    let cards = this.props.users.map((user) => {
      return <CoderCard user={user} />
    });

    return (
      <div>
        {cards}
      </div>
    );
  }

});

module.exports = CoderList;
