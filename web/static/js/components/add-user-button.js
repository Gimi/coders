'use strict';

const React = require('react/addons');

const FloatingActionButton = require('material-ui/lib/floating-action-button');
const FontIcon = require('material-ui/lib/font-icon');

const AddUserButton = React.createClass({

  mixins: [React.addons.PureRenderMixin],

  propTypes: {
    style: React.PropTypes.object,
    onClick: React.PropTypes.func
  },

  getDefaultProps() {
    /* by default, it shows at the right-bottom corner */
    return {style: {
      position: "fixed",
      right: "5%",
      bottom: "5%"
    }};
  },

  render() {
    return (
      <FloatingActionButton style={this.props.style} onMouseUp={this.props.onClick} onTouchEnd={this.props.onClick}>
        <FontIcon className="material-icons">person_add</FontIcon>
      </FloatingActionButton>
    );
  }

});

module.exports = AddUserButton;
