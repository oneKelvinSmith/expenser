import DeviseAuthenticator from 'ember-simple-auth/authenticators/devise';
import Ember from 'ember';
import ENV from '../config/environment';

const { RSVP, isEmpty, run } = Ember;

export default DeviseAuthenticator.extend({
  serverTokenEndpoint: ENV.apiURL + '/users/sign_in',

  restore(data) {
    return new RSVP.Promise((resolve, reject) => {
      if (!isEmpty(data.accessToken) &&
          !isEmpty(data.expiry) &&
          !isEmpty(data.tokenType) &&
          !isEmpty(data.uid) &&
          !isEmpty(data.client)) {
        resolve(data);
      } else {
        reject();
      }
    });
  },

  authenticate(identification, password) {
    return new RSVP.Promise((resolve, reject) => {
      const data = { password };
      const identificationAttributeName = this.get('identificationAttributeName');

      data[identificationAttributeName] = identification;

      this
        .makeRequest(data)
        .then((response, status, xhr) => {
          const result = {
            accessToken: xhr.getResponseHeader('access-token'),
            expiry: xhr.getResponseHeader('expiry'),
            tokenType: xhr.getResponseHeader('token-type'),
            uid: xhr.getResponseHeader('uid'),
            client: xhr.getResponseHeader('client')
          };

          run(null, resolve, result);
        }, xhr => {
          run(null, reject, xhr.responseJSON || xhr.responseText);
        });
    });
  }
});
