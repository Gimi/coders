'use strict';

const Cortex = require('cortexjs');
const http   = require('../http');

class AppStore {
  constructor() {
    this.state = new Cortex({
      users: []
    });
  }

  getState() { return this.state; }

  getUsers() {
    http
      .get("/api/github_users")
      .end((err, resp) => {
        if(resp.ok) {
          this.state.users.set(resp.body.data);
        } else {
          console.log("Failed to get users, " + resp.text);
        }
      })
  }
}

module.exports = new AppStore();
