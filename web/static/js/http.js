'use strict';

/*
 * A thin wrapper of superagent,
 * to make other components easier
 * to make API calls to our backend.
 */
const request = require('superagent');

module.exports = {
  get(url) {
    return request.get(url).set("Accept", "application/json")
  },

  post(url) {
    return request.post(url)
      .set("Accept", "application/json")
      .set("Content-Type", "application/json")
  }
}
