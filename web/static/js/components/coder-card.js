'use strict';

const React = require('react/addons');

const Avatar      = require('material-ui/lib/avatar');
const CardAll     = require('material-ui/lib/card/index');
const Card        = CardAll.Card;
const CardHeader  = CardAll.CardHeader;
const CardText    = CardAll.CardText;
const CardActions = CardAll.CardActions;
const FlatButton  = require('material-ui/lib/flat-button');
const FontIcon    = require('material-ui/lib/font-icon');
const HomeIcon    = require('material-ui/lib/svg-icons/action/home');
const List        = require('material-ui/lib/lists/list');
const ListDivider = require('material-ui/lib/lists/list-divider');
const ListItem    = require('material-ui/lib/lists/list-item');
const Paper       = require('material-ui/lib/paper');

const CoderCard = React.createClass({
  propTypes: {
    user: React.PropTypes.object
  },

  getDefaultProps() {
    return {user: {}};
  },

  create_repo_listitem(repo, count_field, text) {
    if(!repo) return;
    // let link = <a href={repo.html_url}>{repo.name}</a>; 
    let link = repo.name;
    return(
      <ListItem primaryText={link} secondaryText={text + repo[count_field]} leftIcon={<HomeIcon />} />
    );
  },

  render() {
    let user = this.props.user;
    if(user.getValue) user = user.getValue();

    let repos = user.repos || {favorite_language: "Unknow"};

    return (
      <Card initiallyExpanded={false}>
        <CardHeader title={user.login} subtitle={user.name} avatar={<Avatar style={{color:'red'}} src={user.avatar_url} />} showExpandableButton={true} />
        <CardText expandable={true}>
          <Paper>
            <List subheader="Basic Info">
              <ListItem primaryText="Favorite Language" secondaryText={repos.favorite_language} leftIcon={<HomeIcon />} />
              <ListItem primaryText="Joined Github" secondaryText={user.created_at} leftIcon={<HomeIcon />} />
              <ListItem primaryText="Added To Watch" secondaryText={user.watched_at} leftIcon={<HomeIcon />} />
            </List>
          </Paper>
          <Paper>
            <List subheader="Repositories">
              { this.create_repo_listitem(repos.most_wanted, "watchers_count", "Most Watched by ") }
              { this.create_repo_listitem(repos.most_starred, "stargazers_count", "Most Starred by ") }
              { this.create_repo_listitem(repos.most_forked, "forks_count", "Most Forked by ") }
            </List>
          </Paper>
        </CardText>
        <CardActions expandable={true}>
          <FlatButton label="Refresh"/>
          <FlatButton label="Delete"/>
        </CardActions>
      </Card>
    );
  }
});

module.exports = CoderCard;
