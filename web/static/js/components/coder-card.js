'use strict';

const React = require('react/addons');

const muiCard = require('material-ui/lib/card/index');
const Card = muiCard.Card;
const CardHeader = muiCard.CardHeader;
const CardText = muiCard.CardText;
const CardActions = muiCard.CardActions;
const FlatButton = require('material-ui/lib/flat-button');
const Avatar = require('material-ui/lib/avatar');

const CoderCard = React.createClass({
  propTypes: {
    user: React.PropTypes.object
  },

  getDefaultProps() {
    return {user: null};
  },

  render() {
    if(this.props.user == null) return;
    let user = this.props.user.val();
    return (
      <Card initiallyExpanded={true}>
        <CardHeader title={user.login} subtitle={user.name} avatar={<Avatar style={{color:'red'}} src={user.avatar_url} />} showExpandableButton={true} />
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

module.exports = CoderCard;
