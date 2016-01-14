import DeviseAuthenticator from 'ember-simple-auth/authenticators/devise';
import Ember from 'ember';
import ENV from '../config/environment';

const { RSVP, isEmpty } = Ember;

export default DeviseAuthenticator.extend({
  serverTokenEndpoint: ENV.apiURL + '/auth/sign_in',

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
      const credentials = { password };
      const identificationAttributeName = this.get('identificationAttributeName');

      credentials[identificationAttributeName] = identification;

      const success = (_response, _status, xhr) => {
        resolve({
          accessToken: xhr.getResponseHeader('access-token'),
          expiry: xhr.getResponseHeader('expiry'),
          tokenType: xhr.getResponseHeader('token-type'),
          uid: xhr.getResponseHeader('uid'),
          client: xhr.getResponseHeader('client'),
        });
      };

      const failure = ({ responseJSON }) => reject(responseJSON);

      this
        .makeRequest(credentials)
        .then(success, failure);
    });
  }
});
