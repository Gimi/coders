'use strict';

const Cortex  = require('cortexjs');
const request = require('superagent');
// const im      = require('immutable');

let GithubUsers = new Cortex([]);

GithubUsers.GET = function() {
  request
    .get("/api/github_users")
    .set("Accept", "application/json")
    .end((err, resp) => {
      if(resp.ok) {
        this.set(resp.body.data);
      } else {
        console.log("Failed to get users, " + resp.text);
      }
    })
}

module.exports = GithubUsers;
