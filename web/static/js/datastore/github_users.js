'use strict';

const Cortex = require('cortexjs');
const http   = require('../http');

let GithubUsers = new Cortex([]);

GithubUsers.GET = function() {
  http
    .get("/api/github_users")
    .end((err, resp) => {
      if(resp.ok) {
        this.set(resp.body.data);
      } else {
        console.log("Failed to get users, " + resp.text);
      }
    })
}

module.exports = GithubUsers;
